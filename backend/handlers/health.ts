import { express } from "../deps.ts";

function GET_health(_: express.Request, res: express.Response) {
    res.send("OK");
}

export { GET_health };
