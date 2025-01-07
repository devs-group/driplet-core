import { express, STATUS_CODE } from "../deps.ts";
import { config } from "../config.ts";
import { l } from "../logger.ts";

export async function authMiddleware(
  req: express.Request,
  res: express.Response,
  next: express.NextFunction,
) {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      res.status(STATUS_CODE.Unauthorized).json({
        success: false,
        error: "Unauthorized: No token provided.",
      });
      return;
    }

    const accessToken = authHeader.slice(7); // Remove "Bearer " prefix

    // Validate the access token using Google's tokeninfo endpoint
    const tokenInfoUrl =
      `https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=${accessToken}`;

    const response = await fetch(tokenInfoUrl);
    const tokenInfo = await response.json();

    if (response.ok) {
      // Verify the audience (client ID)
      if (tokenInfo.audience !== config.google.clientID) {
        res.status(STATUS_CODE.Unauthorized).json({
          success: false,
          error: "Invalid token audience.",
        });
        return;
      }

      // Optionally, verify required scopes
      const requiredScopes = [
        "openid",
        "https://www.googleapis.com/auth/userinfo.email",
        "https://www.googleapis.com/auth/userinfo.profile",
      ];
      const tokenScopes = tokenInfo.scope.split(" ");
      const hasAllScopes = requiredScopes.every((scope) =>
        tokenScopes.includes(scope)
      );
      if (!hasAllScopes) {
        res.status(STATUS_CODE.Unauthorized).json({
          success: false,
          error: "Insufficient token scopes.",
        });
        return;
      }

      // Attach token info or user info to the context state for use in handlers
      req.user = {
        user_id: tokenInfo.user_id,
        email: tokenInfo.email,
      };

      // Proceed to the next middleware or route handler
      next();
    } else {
      // Token is invalid or expired
      res.status(STATUS_CODE.Unauthorized).json({
        success: false,
        error: tokenInfo.error_description || "Invalid token.",
      });
      return;
    }
  } catch (error) {
    l.error("Authentication error:", error);
    res.status(STATUS_CODE.InternalServerError).json({
      success: false,
      error: "Internal server error during authentication.",
    });
    return;
  }
}
