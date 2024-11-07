import { express } from "./deps.ts";
import {
    GET_auth,
    GET_authCallback,
    GET_authFailure,
    GET_authSuccess,
    GET_logout,
} from "./handlers/auth.ts";
import { GET_health } from "./handlers/health.ts";
import { POST_collect } from "./handlers/collect.ts";
import { requireAuth } from "./middlewares/auth.ts";


export function routes(app: express.Application) {
    app.get("/health", GET_health);
    app.get("/auth/google", GET_auth);
    app.get("/auth/google/callback", GET_authCallback);
    app.get("/auth/success", GET_authSuccess);
    app.get("/auth/failure", GET_authFailure);
    app.get("/auth/logout", GET_logout);
    app.post("/collect/client-event", requireAuth, POST_collect);
}
