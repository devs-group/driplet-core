import { express } from "./deps.ts";
import { GET_getUserCredits, POST_saveUser } from "./handlers/auth.ts";
import { GET_health } from "./handlers/health.ts";
import { POST_collect } from "./handlers/collect.ts";
import { authMiddleware } from "./middlewares/auth.ts";

export function routes(app: express.Application) {
  app.get("/health", GET_health);
  app.get("/auth/user/credits", authMiddleware, GET_getUserCredits);
  app.post("/auth/user", authMiddleware, POST_saveUser);
  app.post("/collect/client-event", authMiddleware, POST_collect);
}
