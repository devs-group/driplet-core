import { pg } from "../deps.ts";
import { config } from "../config.ts";
import { err, ok, Result } from "npm:neverthrow";

export interface User {
  id: string;
  email: string;
  oauthId: string;
  credits: string;
}

export interface Queries {
  saveUser: (
    email: string,
    oauthId: string,
  ) => Promise<Result<User | null, Error>>;
  updateUserCredits: (
    email: string,
    credits: number,
  ) => Promise<Result<User | null, Error>>;
  getPool(): pg.Pool;
  getUserByEmail(
    email: string,
  ): Promise<Result<User | null, Error>>;
}

export async function DB(): Promise<Queries> {
  const { Pool } = pg;
  const pool = new Pool({
    user: config.postgres.user,
    password: config.postgres.password,
    host: config.postgres.host,
    port: config.postgres.port,
    database: config.postgres.db,
  });
  const client = await pool.connect();

  function getPool(): pg.Pool {
    return pool;
  }

  async function getUserByEmail(
    email: string,
  ): Promise<Result<User | null, Error>> {
    return await client
      .query<User>(`SELECT * FROM users WHERE email = $1 LIMIT 1`, [email])
      .then((result) => ok(result.rows[0] || null))
      .catch((error) =>
        err(new Error(`Failed to get user by email: ${error.message}`))
      );
  }

  async function saveUser(
    email: string,
    oauthId: string,
  ): Promise<Result<User | null, Error>> {
    return await client
      .query<User>(
        `INSERT INTO users (email, oauth_id)
         VALUES ($1, $2)
         ON CONFLICT (email) DO NOTHING
         RETURNING *`,
        [email, oauthId],
      )
      .then((result) => ok(result.rows[0] || null))
      .catch((error) =>
        err(new Error(`Failed to save user: ${error.message}`))
      );
  }

  async function updateUserCredits(
    email: string,
    credits: number,
  ): Promise<Result<User | null, Error>> {
    return await client
      .query<User>(
        `UPDATE users SET credits = $1 WHERE email = $2 RETURNING *`,
        [credits.toString(), email],
      )
      .then((result) => ok(result.rows[0] || null))
      .catch((error) =>
        err(
          new Error(`Failed to update user credits: ${error.message}`),
        )
      );
  }

  return {
    getUserByEmail,
    saveUser,
    updateUserCredits,
    getPool,
  };
}
