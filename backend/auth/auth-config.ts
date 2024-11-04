import { GoogleStrategy, passport } from "../deps.ts";
import { config } from "../config.ts";
import { l } from "../logger.ts";
import { Queries } from "../db/index.ts";

interface GooglePhoto {
    value: string;
}

interface GoogleEmail {
    value: string;
    verified: boolean;
}

interface GoogleName {
    familyName: string;
    givenName: string;
}

interface GoogleProfile {
    id: string;
    displayName: string;
    name: GoogleName;
    emails: GoogleEmail[];
    photos: GooglePhoto[];
    provider: string;
}

export function configureAuth(db: Queries) {
    // Configuration of passport Google strategy
    passport.use(
        new GoogleStrategy(
            {
                clientID: config.google.clientID,
                clientSecret: config.google.clientSecret,
                callbackURL: config.google.callbackURL,
            },
            async (
                accessToken: string,
                refreshToken: string,
                profile: GoogleProfile,
                done: any,
            ) => {
                // 1. Check if the user exists in your database
                // 2. Create a new user if they don't exist
                // 3. Return the user object
                try {
                    l.debug(
                        `authenticating user with oauth_id: ${
                            JSON.stringify(profile.id)
                        }`,
                    );
                    const user = await db.getUserByOAuthIdAndEmail(
                        profile.id,
                        profile.emails[0].value,
                    );
                    if (user) {
                        l.debug(
                            `user with oauth_id: ${
                                JSON.stringify(profile.id)
                            } found in our db`,
                        );
                        l.debug(`user: ${JSON.stringify(user)}`);
                        return done(null, user);
                    } else {
                        l.debug(
                            `user with oauth_id: ${profile.id} not found in our db`,
                        );
                        l.debug(`saving user to our db...`);
                        const newUser = await db.saveUser(
                            profile.emails[0].value,
                            profile.id,
                        );
                        return done(null, newUser);
                    }
                } catch (err) {
                    l.error(
                        `unable to query user by oauth id and email: ${profile.id}: ${err}`,
                    );
                    return done(err);
                }
            },
        ),
    );

    // Serialize user for the session
    passport.serializeUser((user: any, done: any) => {
        done(null, user);
    });

    // Deserialize user from the session
    passport.deserializeUser((user: any, done: any) => {
        done(null, user);
    });
}
