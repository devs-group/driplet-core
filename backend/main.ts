import { config } from "./config.ts";
import { express, expressSession, passport, bodyParser } from "./deps.ts";
import { l } from "./logger.ts";
import { routes } from "./routes.ts";
import { configureAuth } from "./auth/auth-config.ts";
import { createDBMiddleware } from "./db/middleware.ts";
import { DB } from "./db/index.ts";

const app = express();

app.use(bodyParser.json())

// Initialize db connection and inject into request
const db = await DB();
app.use(createDBMiddleware(db));

// Initialize passport oauth configuration
configureAuth(db);

// Session middleware
app.use(expressSession({
  secret: config.session.secret,
  resave: false,
  saveUninitialized: false,
}));

// Initialize passport and restore authentication state from session
app.use(passport.initialize());
app.use(passport.session());

// Serve static folder
app.use(express.static('static'));

// Register all API endpoints
routes(app);

app.listen(config.port);
l.info(`Server listening on port ${config.port}`);
