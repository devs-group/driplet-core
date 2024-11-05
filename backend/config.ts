export const config = {
    port: Deno.env.get("PORT") || 1991,
    google: {
        projectId: Deno.env.get("GOOGLE_PROJECT_ID") || "",
        pubsubTopicClientEvents: Deno.env.get("GOOGLE_PUBSUB_TOPIC_CLIENT_EVENTS") || "",
        clientID: Deno.env.get("GOOGLE_CLIENT_ID") || "",
        clientSecret: Deno.env.get("GOOGLE_CLIENT_SECRET") || "",
        callbackURL: Deno.env.get("GOOGLE_CALLBACK_URL") || "",
    },
    session: {
        secret: Deno.env.get("SESSION_SECRET") || "your-secret-key",
    },
    postgres: {
        user: Deno.env.get("POSTGRES_USER") || "postgres",
        password: Deno.env.get("POSTGRES_PASSWORD") || "postgres",
        db: Deno.env.get("POSTGRES_DB") || "postgres",
        host: Deno.env.get("POSTGRES_HOST") || "database",
        port: parseInt(Deno.env.get("POSTGRES_PORT") || "5432"),
    },
};
