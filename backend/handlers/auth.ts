import { express, passport, STATUS_CODE } from "../deps.ts";

// Main auth endpoint
export function GET_auth(req: express.Request, res: express.Response) {
    passport.authenticate("google", {
        scope: ["profile", "email"],
    })(req, res);
}

export function GET_authCallback(req: express.Request, res: express.Response) {
    passport.authenticate("google", {
        successRedirect: "/auth/success",
        failureRedirect: "/auth/failure",
    })(req, res);
}

export function GET_authSuccess(req: express.Request, res: express.Response) {
    if (req.isAuthenticated()) {
        res.status(STATUS_CODE.OK).send({
            "message": "Authentication successful",
            "user": req.user,
        });
    } else {
        res.redirect("/auth");
    }
}

export function GET_authFailure(_req: express.Request, res: express.Response) {
    res.status(STATUS_CODE.Unauthorized).send({
        "message": "Authentication failed",
    });
}

export function GET_logout(req: express.Request, res: express.Response) {
    req.logout(() => {
        res.redirect("/auth");
    });
}
