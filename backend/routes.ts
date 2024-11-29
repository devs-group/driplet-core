import { express } from "./deps.ts";
import { GET_getUser, GET_getTest } from "./handlers/auth.ts";
import { GET_health } from "./handlers/health.ts";
import { POST_collect } from "./handlers/collect.ts";
import { authMiddleware } from "./middlewares/auth.ts";

export function routes(app: express.Application) {
    app.get("/health", GET_health);
    app.get("/auth/user", authMiddleware, GET_getUser);
    app.post("/collect/client-event", authMiddleware, POST_collect);
    app.get("/test", authMiddleware, GET_getTest);
}
