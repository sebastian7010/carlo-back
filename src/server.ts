import express, { type Request, type Response, type NextFunction } from "express";
import cors from "cors";
import "dotenv/config";
import cookieParser from "cookie-parser";
import { PrismaClient } from "@prisma/client";

import authRoutes from "./routes/auth";
import { registerConversationsRoute } from "./routes/conversations";
import discoverSaintRouter from "./routes/discover-saint";
import { registerAiChatRoute } from "./routes/ai-chat";
import { registerAiTranslateRoute } from "./routes/ai-translate";

// -------------------------
// ADMIN KEY (mínimo para escrituras)
// -------------------------
export function requireAdminKey(req: Request, res: Response, next: NextFunction) {
  const expected = process.env.ADMIN_KEY;

  // Si no está configurada, NO bloquea (modo dev)
  if (!expected) return next();

  const provided = req.header("x-admin-key");
  if (provided && provided === expected) return next();

  return res.status(401).json({ error: "UNAUTHORIZED" });
}

const app = express();
const prisma = new PrismaClient();

app.use(cookieParser());

// CORS
const FRONTEND_ORIGIN = process.env.FRONTEND_ORIGIN || "http://localhost:3000";
app.use(
  cors({
    origin: FRONTEND_ORIGIN,
    credentials: true,
  })
);

// JSON
app.use(express.json({ limit: "1mb" }));

// Routes
app.use("/auth", authRoutes);

// AI
registerAiChatRoute(app);
registerAiTranslateRoute(app);

// Conversations
registerConversationsRoute(app);

// Discover Saint (montado en 2 paths por compatibilidad)
app.use("/discover-saint", discoverSaintRouter);
app.use("/descubrir-saint", discoverSaintRouter);

// Health / root
app.get("/health", (_req: Request, res: Response) => res.json({ ok: true }));
app.get("/", (_req: Request, res: Response) => {
  res.send("Acutis API OK ✅ Usa /health, /saints, /saints/:id/miracles, /discover-saint");
});

// Graceful shutdown
process.on("SIGINT", async () => {
  try {
    await prisma.$disconnect();
  } finally {
    process.exit(0);
  }
});

const PORT = Number(process.env.PORT) || 3001;
app.listen(PORT, "0.0.0.0", () => {
  console.log(`✅ Backend Acutis corriendo en puerto ${PORT}`);
});
