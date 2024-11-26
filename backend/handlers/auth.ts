import { express,  STATUS_CODE } from "../deps.ts";


export function GET_getUser(req: express.Request, res: express.Response) {
    if (req.user?.id) {
        res.status(STATUS_CODE.OK).send({
            "user": req.user,
        })
    } else {
        res.status(STATUS_CODE.Unauthorized).send({
            "message": "User could not be found in session"
        })
    }
}
export function GET_getTest(req: express.Request, res: express.Response) {
    if (req.user?.userId) {
        res.status(STATUS_CODE.OK).send({
            "user": req.user,
        })
    } else {
        res.status(STATUS_CODE.Unauthorized).send({
            "message": "User could not be found in session"
        })
    }
}