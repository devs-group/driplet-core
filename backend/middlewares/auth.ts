import { express, STATUS_CODE } from "../deps.ts";

export function requireAuth(req: express.Request, res: express.Response, next: express.NextFunction) {
  if (req.isAuthenticated()) {
    return next();
  }
  res.status(STATUS_CODE.Unauthorized).json({ message: "Authentication required" });
}
