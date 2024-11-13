import { PubSub, Topic } from "npm:@google-cloud/pubsub@4.1.0";
import { config } from "../config.ts";
import { Buffer } from "node:buffer";
import { l } from "../logger.ts";

export interface EventMessage {
  event: Record<string, unknown>;
  user_id: string;
  timestamp: string;
}

const pubsub = new PubSub({ projectId: config.google.projectId });
let cachedTopic: Topic | null = null;
const MAX_RETRIES = 3;
const RETRY_DELAY = 1000;

const delay = (ms: number): Promise<void> => 
  new Promise(resolve => setTimeout(resolve, ms));

async function ensureTopicExists(attempt = 1): Promise<Topic> {
  try {
    if (cachedTopic) {
      const [exists] = await cachedTopic.exists();
      if (exists) return cachedTopic;
    }

    const topicName = config.google.pubsubTopicClientEvents;
    const [exists] = await pubsub.topic(topicName).exists();
    
    if (exists) {
      cachedTopic = pubsub.topic(topicName);
      l.info(`Topic ${topicName} already exists`);
    } else {
      [cachedTopic] = await pubsub.createTopic(topicName);
      l.info(`Topic ${topicName} created successfully`);
    }

    return cachedTopic;
  } catch (error) {
    if (attempt < MAX_RETRIES) {
      l.warn(`Failed to ensure topic exists (attempt ${attempt}/${MAX_RETRIES}): ${error.message}`);
      await delay(RETRY_DELAY * attempt);
      return ensureTopicExists(attempt + 1);
    }
    throw new Error(`Failed to ensure topic exists after ${MAX_RETRIES} attempts: ${error.message}`);
  }
}

export async function publishMessage(messageData: EventMessage): Promise<string> {
  const topic = await ensureTopicExists();
  const messageBuffer = Buffer.from(JSON.stringify(messageData));
  
  const messageId = await topic.publishMessage({
    data: messageBuffer,
    attributes: {
      timestamp: messageData.timestamp,
      user_id: messageData.user_id,
    },
  });

  l.info(`Published message ${messageId} to topic ${config.google.pubsubTopicClientEvents}`);
  return messageId;
}
