import { express, GoogleStrategy, passport } from "../deps.ts";
import { config } from "../config.ts";

// Configure passport Google strategy
passport.use(
    new GoogleStrategy({
        clientID: config.google.clientID,
        clientSecret: config.google.clientSecret,
        callbackURL: config.google.callbackURL,
    }, (accessToken: string, refreshToken: string, profile: any, done: any) => {
        // In a real application, you would typically:
        // 1. Check if the user exists in your database
        // 2. Create a new user if they don't exist
        // 3. Return the user object
        return done(null, profile);
    }),
);

// Serialize user for the session
passport.serializeUser((user: any, done: any) => {
    done(null, user);
});

// Deserialize user from the session
passport.deserializeUser((user: any, done: any) => {
    done(null, user);
});

// Main auth endpoint
function GET_auth(_req: express.Request, res: express.Response) {
    res.send(`
        <html>
            <body>
                <h1>Authentication</h1>
                <a href="/auth/google">Login with Google</a>
            </body>
        </html>
    `);
}

// Callback handler
function GET_authCallback(req: express.Request, res: express.Response) {
    passport.authenticate("google", {
        successRedirect: "/auth/success",
        failureRedirect: "/auth/failure",
    })(req, res);
}

// Add these routes to handle success/failure
function GET_authSuccess(req: express.Request, res: express.Response) {
    if (req.isAuthenticated()) {
        res.send(`
            <html>
                <body>
                    <h1>Authentication Successful</h1>
                    <p>Welcome ${(req.user as any)?.displayName || "User"}!</p>
                    <a href="/auth/logout">Logout</a>
                </body>
            </html>
        `);
    } else {
        res.redirect("/auth");
    }
}

function GET_authFailure(_req: express.Request, res: express.Response) {
    res.send(`
        <html>
            <body>
                <h1>Authentication Failed</h1>
                <a href="/auth">Try Again</a>
            </body>
        </html>
    `);
}

export { GET_auth, GET_authCallback, GET_authFailure, GET_authSuccess };
