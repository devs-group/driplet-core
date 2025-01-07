import { express, STATUS_CODE } from "../deps.ts";
import { type EventMessage, publishMessage } from "../pubsub/pubsub.ts";
import { l } from "../logger.ts";

export async function POST_collect(
  req: express.Request,
  res: express.Response,
) {
  const { event } = req.body;

  if (!event || typeof event !== "object") {
    res.status(STATUS_CODE.BadRequest).send({
      message: "Event is required and must be an object",
    });
    return;
  }

  if (!req.user) {
    res.status(STATUS_CODE.Unauthorized).send({
      message: "User must be authenticated",
    });
    return;
  }

  const messageData: EventMessage = {
    event,
    user: req.user,
    timestamp: new Date().toISOString(),
  };

  try {
    const messageId = await publishMessage(messageData);
    res.status(STATUS_CODE.OK).send({
      message: "Event collected successfully",
      messageId,
    });
  } catch (error) {
    l.error("Failed to publish message:", {
      error: error,
      event: messageData,
    });
    res.status(STATUS_CODE.InternalServerError).send({
      message: "Error publishing message",
      error: err.message
    });
    return;
  }
  res.status(STATUS_CODE.InternalServerError).send({
    message: "Failed to collect event",
  });
}
