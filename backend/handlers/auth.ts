import { express, STATUS_CODE } from "../deps.ts";
import { ExpressUser } from "../types/types.ts";

export async function GET_getUserCredits(
  req: express.Request,
  res: express.Response,
) {
  const u = req.user as ExpressUser;
  const result = await req.db.getUserByEmail(u.email);
  result.match(
    (user) =>
      res.status(STATUS_CODE.OK).send({
        credits: user?.credits,
      }),
    () => res.status(STATUS_CODE.InternalServerError),
  );
}

export async function POST_saveUser(
  req: express.Request,
  res: express.Response,
) {
  const u = req.user as ExpressUser;
  const result = await req.db.saveUser(u.email, u.user_id);
  result.match(
    (user) => res.status(STATUS_CODE.OK).send(user ?? {}),
    () => res.status(STATUS_CODE.InternalServerError),
  );
}
