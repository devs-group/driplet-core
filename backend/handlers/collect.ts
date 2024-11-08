import { express, STATUS_CODE } from "../deps.ts";
import { publishMessage, type EventMessage } from "../pubsub/pubsub.ts";
import { l } from "../logger.ts";

export async function POST_collect(req: express.Request, res: express.Response) {
  const { event } = req.body;

  if (!event || typeof event !== 'object') {
    res.status(STATUS_CODE.BadRequest).send({ 
      message: "Event is required and must be an object" 
    });
    return;
  }

  if (!req.user?.id) {
    res.status(STATUS_CODE.Unauthorized).send({ 
      message: "User must be authenticated" 
    });
    return;
  }

  const messageData: EventMessage = {
    event,
    user_id: req.user.id,
    timestamp: new Date().toISOString(),
  };

  try {
    const messageId = await publishMessage(messageData);
    res.status(STATUS_CODE.OK).send({ 
      message: "Event collected successfully",
      messageId,
    });
  } catch (error) {
    l.error('Failed to publish message:', {
      error: error.message,
      event: messageData,
    });

    res.status(STATUS_CODE.InternalServerError).send({ 
      message: "Failed to collect event",
      error: error.message,
    });
  }
}