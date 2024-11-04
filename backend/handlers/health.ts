import { express, STATUS_CODE } from "../deps.ts";

export function GET_health(_: express.Request, res: express.Response) {
    res.status(STATUS_CODE.OK).send({ "message": "healthy" });
}
