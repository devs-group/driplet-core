export const config = {
    env: Deno.env.get("ENV") || "development",
    port: Deno.env.get("PORT") || 1991,
    google: {
        projectId: Deno.env.get("GOOGLE_PROJECT_ID") || "",
        pubsubTopicClientEvents:
            Deno.env.get("GOOGLE_PUBSUB_TOPIC_CLIENT_EVENTS") || "",
        clientID: Deno.env.get("GOOGLE_CLIENT_ID") || "",
        clientSecret: Deno.env.get("GOOGLE_CLIENT_SECRET") || "",
        callbackURL: Deno.env.get("GOOGLE_CALLBACK_URL") || "",
    },
    session: {
        secret: Deno.env.get("SESSION_SECRET") || "your-secret-key",
    },
    postgres: {
        connectionString: Deno.env.get("POSTGRES_CONNECTION_STRING") || "",
    },
};
