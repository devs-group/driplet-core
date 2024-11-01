const config = {
    port: Deno.env.get("PORT") || 1991,
    google: {
        clientID: Deno.env.get("GOOGLE_CLIENT_ID") || "",
        clientSecret: Deno.env.get("GOOGLE_CLIENT_SECRET") || "",
        callbackURL: Deno.env.get("GOOGLE_CALLBACK_URL") || "",
    },
    session: {
        secret: Deno.env.get("SESSION_SECRET") || "your-secret-key",
    },
};

export { config };
