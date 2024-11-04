import { NextFunction, Request, Response } from "npm:express@4.18.2";
import { Queries } from "./index.ts";

// createDBMiddleware creates a middlware for express
export function createDBMiddleware(db: Queries) {
    return (req: Request, _res: Response, next: NextFunction) => {
        req.db = db;
        next();
    };
}

// Defines a global type on the db express middleware
declare global {
    namespace Express {
        interface Request {
            db: Queries;
        }
    }
}
