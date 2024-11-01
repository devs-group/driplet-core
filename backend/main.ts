import { config } from "./config.ts";
import { express, expressSession, passport } from "./deps.ts";
import { l } from "./logger.ts";
import { routes } from "./routes.ts";

let app = express();

// Session middleware
app.use(expressSession({
  secret: config.session.secret,
  resave: false,
  saveUninitialized: false,
}));

// Initialize passport and restore authentication state from session
app.use(passport.initialize());
app.use(passport.session());

// Register all API endpoints
app.get("/", function (req: express.Request, res: express.Response) {
  res.send(200);
});

app = routes(app);

app.listen(config.port);
l.info(`Server listening on port ${config.port}`);
