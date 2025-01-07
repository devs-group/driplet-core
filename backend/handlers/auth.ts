import { express, STATUS_CODE } from "../deps.ts";

export function GET_getUser(req: express.Request, res: express.Response) {
  if (req.user) {
    res.status(STATUS_CODE.OK).send({
      "user": req.user,
    });
  } else {
    res.status(STATUS_CODE.Unauthorized).send({
      "message": "User could not be found in session",
    });
  }
}
