import { express, STATUS_CODE } from "../deps.ts";
import { PubSub } from "npm:@google-cloud/pubsub@4.1.0";
import { config } from "../config.ts";
import { Buffer } from "node:buffer";
import { type } from "node:os";

const pubsub = new PubSub({
  projectId: config.google.projectId,
});
const clientEventTopic = await pubsub.topic(config.google.pubsubTopicClientEvents);

export async function POST_collect(req: express.Request, res: express.Response) {
  const { event } = req.body;

  if (!event) {
    res.status(STATUS_CODE.BadRequest).send({ message: "Event is required" });
    return;
  }

  try {
    await clientEventTopic.publishMessage({
      data: Buffer.from(type.toString(event)),
    });
  } catch (error) {
    console.error(`Error publishing message: ${error}`);
    res.status(STATUS_CODE.InternalServerError).send({ message: "Error publishing message" });
  }

  res.status(STATUS_CODE.OK).send({ message: "collected" });
}
