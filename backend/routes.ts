import { express, passport } from "./deps.ts";
import {
    GET_authCallback,
    GET_authFailure,
    GET_authSuccess,
} from "./handlers/auth.ts";
import { GET_health } from "./handlers/health.ts";

export function routes(app: express.Application): express.Application {
    app.get("/health", GET_health);
    app.get(
        "/auth/google",
        passport.authenticate("google", {
            scope: ["profile", "email"],
        }),
    );
    app.get("/auth/google/callback", GET_authCallback);
    app.get("/auth/success", GET_authSuccess);
    app.get("/auth/failure", GET_authFailure);
    app.get("/auth/logout", (req: express.Request, res: express.Response) => {
        req.logout(() => {
            res.redirect("/auth");
        });
    });
    return app;
}
