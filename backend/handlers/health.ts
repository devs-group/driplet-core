import { express } from "../deps.ts";

function GET_health(_: express.Request, res: express.Response) {
    res.send(200, { "message": "ok" });
}

export { GET_health };
