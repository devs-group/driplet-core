import { pg } from "../deps.ts";
import { l } from "../logger.ts";
import { config } from "../config.ts";

export interface User {
    id: string;
    email: string;
    oauthId: string;
}

export interface Queries {
    getUserByID: (id: string) => Promise<User | null>;
    getUserByOAuthIdAndEmail: (
        oauthId: string,
        email: string,
    ) => Promise<User | null>;
    saveUser: (email: string, oauthId: string) => Promise<User | null>;
    getPool: () => pg.Pool;
}

export async function DB(): Promise<Queries> {
    const { Pool } = pg;
    const pool = new Pool({
        connectionString: config.postgres.connectionString,
    });
    const client = await pool.connect();

    function getPool() {
        return pool;
    }

    async function getUserByID(id: string): Promise<User | null> {
        try {
            const { rows } = await client.query<User>(
                `SELECT * FROM users WHERE id = $1 LIMIT 1`,
                [id],
            );
            return rows[0];
        } catch (err) {
            l.error(`unable to query user by id: ${id}: ${err}`);
            throw err;
        }
    }

    async function getUserByOAuthIdAndEmail(
        oauthId: string,
        email: string,
    ): Promise<User | null> {
        try {
            const { rows } = await client.query<User>(
                `SELECT * FROM users WHERE oauth_id = $1 AND email = $2 LIMIT 1`,
                [oauthId, email],
            );
            return rows[0];
        } catch (err) {
            l.error(
                `unable to query user by oauth_id: ${oauthId} and email: ${email}: ${err}`,
            );
            throw err;
        }
    }

    async function saveUser(
        email: string,
        oauthId: string,
    ): Promise<User | null> {
        try {
            const { rows } = await client.query<User>(
                `INSERT INTO users (email, oauth_id) VALUES ($1, $2) RETURNING *`,
                [email, oauthId],
            );
            return rows[0];
        } catch (err) {
            l.error(
                `unable to insert user with: ${oauthId} and email: ${email}: ${err}`,
            );
            throw err;
        }
    }

    return {
        getUserByID,
        getUserByOAuthIdAndEmail,
        saveUser,
        getPool,
    };
}
