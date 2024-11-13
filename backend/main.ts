import { config } from "./config.ts";
import {
  bodyParser,
  express,
  expressSession,
  passport,
  pgSession,
} from "./deps.ts";
import { l } from "./logger.ts";
import { routes } from "./routes.ts";
import { configureAuth } from "./auth/auth-config.ts";
import { createDBMiddleware } from "./db/middleware.ts";
import { DB } from "./db/index.ts";

const app = express();

app.use(bodyParser.json());

// Initialize db connection and inject into request
const db = await DB();
app.use(createDBMiddleware(db));

// Initialize passport oauth configuration
configureAuth(db);

// Create PostgreSQL session store
const PostgresqlStore = pgSession(expressSession);

// Session middleware with PostgreSQL store
app.use(expressSession({
  store: new PostgresqlStore({
    pool: db.getPool(),
    tableName: "session",
    pruneSessionInterval: 60 * 15, // Clear expired sessions every 15 minutes
  }),
  secret: config.session.secret,
  resave: false,
  saveUninitialized: false,
  cookie: {
    maxAge: 30 * 24 * 60 * 60 * 1000, // 30 days
    secure: config.env !== "development",
    httpOnly: true,
  },
}));

// Initialize passport and restore authentication state from session
app.use(passport.initialize());
app.use(passport.session());

// Serve static folder
app.use(express.static("static"));

// Register all API endpoints
routes(app);

app.listen(config.port);
l.info(`Server listening on port ${config.port}`);
