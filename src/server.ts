import express, { Request, Response } from "express";
import cors from "cors";
import { prisma } from "./lib/prisma";
import "dotenv/config";

import { registerAiChatRoute } from "./routes/ai-chat";
import { registerAiTranslateRoute } from "./routes/ai-translate";
// -------------------------
// ADMIN KEY (mínimo para escrituras)
// -------------------------
function requireAdminKey(req: Request, res: Response, next: any) {
  const expected = process.env.ADMIN_KEY;

  // Si no está configurada, NO bloquea (modo dev)
  if (!expected) return next();

  const provided = req.header("x-admin-key");
  if (provided && provided === expected) return next();

  return res.status(401).json({ error: "UNAUTHORIZED" });
}

const app = express();

// CORS (front en 3000)
app.use(
  cors({
    origin: "http://localhost:3000",
    credentials: true,
  })
);

// JSON
app.use(express.json({ limit: "1mb" }));


// AI Chat
registerAiChatRoute(app)

registerAiTranslateRoute(app);const PORT = Number(process.env.PORT || 3001);

// Health
app.get("/health", (_req: Request, res: Response) => {
  return res.json({ ok: true });
});

// Root
app.get("/", (_req: Request, res: Response) => {
  res.send("Acutis API OK ✅  Usa /health, /saints, /saints/:id/miracles");
});

// -------------------------
// SAINTS
// -------------------------

app.get("/saints", async (_req: Request, res: Response) => {
  try {
    const saints = await prisma.saint.findMany({
      orderBy: { createdAt: "desc" },
    });
    return res.json(saints);
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: "error listando santos" });
  }
});

app.get("/saints/:slug", async (req: Request, res: Response) => {
  try {
    const saint = await prisma.saint.findUnique({
      where: { slug: req.params.slug },
      include: {
        miracles: { orderBy: { createdAt: "desc" } },
      },
    });

    if (!saint) return res.status(404).json({ error: "SAINT_NOT_FOUND" });
    return res.json(saint);
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: "error trayendo santo" });
  }
});

app.post("/saints", async (req: Request, res: Response) => {
    const {
    slug,
    name,
    country,
    title,
    feastDay,
    imageUrl,
    biography,
  } = req.body ?? {};


  if (!slug || !name) {
    return res.status(400).json({ error: "slug y name son requeridos" });
  }
  const continentRaw = req.body?.continent;
  const latRaw = req.body?.lat;
  const lngRaw = req.body?.lng;

  // Para CREATE: si no viene o viene vacío -> null
  const continentVal =
    typeof continentRaw === "string" && continentRaw.trim()
      ? continentRaw.trim()
      : null;

  const latIsSet = latRaw !== undefined;
  const lngIsSet = lngRaw !== undefined;

  const latVal = !latIsSet ? null : (latRaw === null || latRaw === "" ? null : Number(latRaw));
  const lngVal = !lngIsSet ? null : (lngRaw === null || lngRaw === "" ? null : Number(lngRaw));

  // Seguridad: si mandan basura, no guardes NaN/Infinity
  const safeLat = latVal !== null && Number.isFinite(latVal) ? latVal : null;
  const safeLng = lngVal !== null && Number.isFinite(lngVal) ? lngVal : null;

  if (latIsSet || lngIsSet) {
    if (latIsSet !== lngIsSet) {
      return res.status(400).json({ error: "Debes enviar lat y lng juntos" });
    }
    if ((safeLat === null) !== (safeLng === null)) {
      return res.status(400).json({ error: "lat y lng deben ser ambos null o ambos números" });
    }
    if (safeLat !== null && (safeLat < -90 || safeLat > 90)) {
      return res.status(400).json({ error: "lat fuera de rango (-90 a 90)" });
    }
    if (safeLng !== null && (safeLng < -180 || safeLng > 180)) {
      return res.status(400).json({ error: "lng fuera de rango (-180 a 180)" });
    }
  }


  try {
    const saint = await prisma.saint.create({
      data: {
        slug: String(slug).trim(),
        name: String(name).trim(),
        country: country ? String(country).trim() : null,
        title: title ? String(title).trim() : null,
        feastDay: feastDay ? String(feastDay).trim() : null,
        imageUrl: imageUrl ? String(imageUrl).trim() : null,
        biography: biography ? String(biography).trim() : null,
                continent: continentVal,
        lat: safeLat,
        lng: safeLng,

      } as any,
    });

    return res.status(201).json(saint);
  } catch (e: any) {
    console.error(e);
    if (e?.code === "P2002") return res.status(409).json({ error: "slug ya existe" });
    return res.status(500).json({ error: "error creando santo" });
  }
});


app.patch("/saints/:id", async (req: Request, res: Response) => {
  const { id } = req.params;
  const { slug, name, country, title, feastDay, imageUrl, biography } = req.body ?? {};

  // === coords + continent (PATCH) ===
  const continentRaw = (req.body ?? {}).continent
  const latRaw = (req.body ?? {}).lat
  const lngRaw = (req.body ?? {}).lng

  const continent =
    continentRaw === undefined
      ? undefined
      : (typeof continentRaw === "string" && continentRaw.trim()
          ? continentRaw.trim()
          : null)

  const lat =
    latRaw === undefined
      ? undefined
      : (latRaw === null || latRaw === "" ? null : Number(latRaw))

  const lng =
    lngRaw === undefined
      ? undefined
      : (lngRaw === null || lngRaw === "" ? null : Number(lngRaw))

  // Validaciones (solo si intentan setear lat/lng)
  const latIsSet = lat !== undefined;
  const lngIsSet = lng !== undefined;

  if (latIsSet || lngIsSet) {
    if ((lat !== null && lat !== undefined && Number.isNaN(lat)) || (lng !== null && lng !== undefined && Number.isNaN(lng))) {
      return res.status(400).json({ error: "lat y lng deben ser números" });
    }
    // si uno viene en el body y el otro no, o si uno queda null y el otro no
    if (latIsSet !== lngIsSet) {
      return res.status(400).json({ error: "En PATCH, lat y lng deben enviarse juntos" });
    }
    if ((lat === null) !== (lng === null)) {
      return res.status(400).json({ error: "lat y lng deben ser ambos null o ambos números" });
    }
    if (lat !== undefined && lat !== null && (lat < -90 || lat > 90)) {
      return res.status(400).json({ error: "lat fuera de rango (-90 a 90)" });
    }
    if (lng !== undefined && lng !== null && (lng < -180 || lng > 180)) {
      return res.status(400).json({ error: "lng fuera de rango (-180 a 180)" });
    }
  }
  try {
    const updated = await prisma.saint.update({
      where: { id },
      data: {
        ...(slug !== undefined ? { slug: slug ? String(slug).trim() : "" } : {}),
        ...(name !== undefined ? { name: name ? String(name).trim() : "" } : {}),
        ...(country !== undefined ? { country: country ? String(country).trim() : null } : {}),
        ...(continent !== undefined ? { continent } : {}),
        ...(lat !== undefined ? { lat } : {}),
        ...(lng !== undefined ? { lng } : {}),
        ...(title !== undefined ? { title: title ? String(title).trim() : null } : {}),
        ...(feastDay !== undefined ? { feastDay: feastDay ? String(feastDay).trim() : null } : {}),
        ...(imageUrl !== undefined ? { imageUrl: imageUrl ? String(imageUrl).trim() : null } : {}),
        ...(biography !== undefined ? { biography: biography ? String(biography).trim() : null } : {}),
      } as any,
    });

    return res.json(updated);
  } catch (e: any) {
    console.error(e);
    if (e?.code === "P2025") return res.status(404).json({ error: "SAINT_NOT_FOUND" });
    if (e?.code === "P2002") return res.status(409).json({ error: "slug ya existe" });
    return res.status(500).json({ error: "error editando santo" });
  }
});

app.delete("/saints/:id", async (req: Request, res: Response) => {
  const { id } = req.params;

  try {
    await prisma.saint.delete({ where: { id } });
    return res.status(204).send("");
  } catch (e: any) {
    console.error(e);
    if (e?.code === "P2025") return res.status(404).json({ error: "SAINT_NOT_FOUND" });
    return res.status(500).json({ error: "error eliminando santo" });
  }
});

// -------------------------
// MIRACLES
// -------------------------


// ===============================
// ✅ MIRACLES (GLOBAL)
// GET /miracles
// ===============================
app.get("/miracles", async (req: Request, res: Response) => {
  try {
    const miracles = await prisma.miracle.findMany({
      orderBy: [{ approved: "desc" }, { createdAt: "desc" }],
      include: {
        saint: { select: { id: true, name: true, slug: true } },
      },
    });

    // normaliza por si el front quiere usarlo directo
    return res.json(
      miracles.map((m) => ({
        id: m.id,
        saintId: m.saintId,
        title: m.title,
        type: m.type,
        date: m.date,
        location: m.location,
        witnesses: m.witnesses,
        approved: m.approved,
        details: m.details,
        createdAt: m.createdAt,
        updatedAt: m.updatedAt,
        saint: m.saint,
      }))
    );
  } catch (e) {
    console.error("❌ Error /miracles", e);
    return res.status(500).json({ error: "error listando milagros" });
  }
});

app.get("/saints/:id/miracles", async (req: Request, res: Response) => {
  const { id } = req.params;

  try {
    const saint = await prisma.saint.findUnique({ where: { id } });
    if (!saint) return res.status(404).json({ error: "SAINT_NOT_FOUND" });

    const miracles = await prisma.miracle.findMany({
      where: { saintId: id },
      orderBy: { createdAt: "desc" },
    });

    return res.json(miracles);
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: "error listando milagros" });
  }
});

app.post("/saints/:id/miracles", async (req: Request, res: Response) => {
  const { id } = req.params;

  const { title, details, description, type, date, location, witnesses, approved } = req.body ?? {};

  if (!title || typeof title !== "string") {
    return res.status(400).json({ error: "title es obligatorio (string)" });
  }

  const detailsValue = details ?? description;

  const bad =
    (detailsValue !== undefined && detailsValue !== null && typeof detailsValue !== "string") ||
    (type !== undefined && type !== null && typeof type !== "string") ||
    (date !== undefined && date !== null && typeof date !== "string") ||
    (location !== undefined && location !== null && typeof location !== "string") ||
    (witnesses !== undefined && witnesses !== null && typeof witnesses !== "string") ||
    (approved !== undefined && typeof approved !== "boolean");

  if (bad) {
    return res.status(400).json({ error: "payload inválido" });
  }

  try {
    const saint = await prisma.saint.findUnique({ where: { id } });
    if (!saint) return res.status(404).json({ error: "SAINT_NOT_FOUND" });

    const miracle = await prisma.miracle.create({
      data: {
        saintId: id,
        title: title.trim(),
        details: detailsValue ? String(detailsValue).trim() : null,
        type: type ? String(type).trim() : null,
        date: date ? String(date).trim() : null,
        location: location ? String(location).trim() : null,
        witnesses: witnesses ? String(witnesses).trim() : null,
        ...(approved !== undefined ? { approved } : {}),
      } as any,
    });

    return res.status(201).json(miracle);
  } catch (e: any) {
    console.error(e);
    return res.status(500).json({ error: "error creando milagro" });
  }
});

app.patch("/miracles/:id", async (req: Request, res: Response) => {
  const { id } = req.params;

  const { title, details, description, type, date, location, witnesses, approved } = req.body ?? {};
  const detailsValue = details ?? description;

  const bad =
    (title !== undefined && typeof title !== "string") ||
    (detailsValue !== undefined && detailsValue !== null && typeof detailsValue !== "string") ||
    (type !== undefined && type !== null && typeof type !== "string") ||
    (date !== undefined && date !== null && typeof date !== "string") ||
    (location !== undefined && location !== null && typeof location !== "string") ||
    (witnesses !== undefined && witnesses !== null && typeof witnesses !== "string") ||
    (approved !== undefined && typeof approved !== "boolean");

  if (bad) {
    return res.status(400).json({ error: "payload inválido" });
  }

  try {
    const updated = await prisma.miracle.update({
      where: { id },
      data: {
        ...(title !== undefined ? { title: title ? String(title).trim() : "" } : {}),
        ...(detailsValue !== undefined
          ? { details: detailsValue ? String(detailsValue).trim() : null }
          : {}),
        ...(type !== undefined ? { type: type ? String(type).trim() : null } : {}),
        ...(date !== undefined ? { date: date ? String(date).trim() : null } : {}),
        ...(location !== undefined ? { location: location ? String(location).trim() : null } : {}),
        ...(witnesses !== undefined ? { witnesses: witnesses ? String(witnesses).trim() : null } : {}),
        ...(approved !== undefined ? { approved } : {}),
      } as any,
    });

    return res.json(updated);
  } catch (e: any) {
    console.error(e);
    if (e?.code === "P2025") return res.status(404).json({ error: "MIRACLE_NOT_FOUND" });
    return res.status(500).json({ error: "error editando milagro" });
  }
});

app.delete("/miracles/:id", async (req: Request, res: Response) => {
  const { id } = req.params;

  try {
    await prisma.miracle.delete({ where: { id } });
    return res.status(204).send("");
  } catch (e: any) {
    console.error(e);
    if (e?.code === "P2025") return res.status(404).json({ error: "MIRACLE_NOT_FOUND" });
    return res.status(500).json({ error: "error eliminando milagro" });
  }
});


// =========================
// PRAYERS
// =========================

// GET /prayers -> todas
app.get("/prayers", async (req: Request, res: Response) => {
  try {
    const prayers = await prisma.prayer.findMany({
      orderBy: { createdAt: "desc" },
    });
    return res.json(prayers);
  } catch (e) {
    console.error("GET /prayers error:", e);
    return res.status(500).json({ error: "PRAYERS_LIST_FAILED" });
  }
});

// GET /prayers/approved -> solo aprobadas (público)
app.get("/prayers/approved", async (req: Request, res: Response) => {
  try {
    const prayers = await prisma.prayer.findMany({
      where: { approved: true },
      orderBy: { createdAt: "desc" },
    });
    return res.json(prayers);
  } catch (e) {
    console.error("GET /prayers/approved error:", e);
    return res.status(500).json({ error: "PRAYERS_APPROVED_LIST_FAILED" });
  }
});

// POST /prayers -> crear
app.post("/prayers", requireAdminKey, async (req: Request, res: Response) => {
  try {
    const { title, content, category, approved, saintName, occasion } = req.body ?? {};

    if (!title || String(title).trim() === "") {
      return res.status(400).json({ error: "TITLE_REQUIRED" });
    }
    if (!content || String(content).trim() === "") {
      return res.status(400).json({ error: "CONTENT_REQUIRED" });
    }

    const prayer = await prisma.prayer.create({
      data: {
        title: String(title).trim(),
        content: String(content).trim(),
        category: category == null ? null : String(category).trim(),
        approved: Boolean(approved),
        saintName: saintName == null ? null : String(saintName).trim(),
        occasion: occasion == null ? null : String(occasion).trim(),
      } as any,
    });

    return res.status(201).json(prayer);
  } catch (e) {
    console.error("POST /prayers error:", e);
    return res.status(500).json({ error: "PRAYER_CREATE_FAILED" });
  }
});

// PATCH /prayers/:id -> editar parcial
app.patch("/prayers/:id", requireAdminKey, async (req: Request, res: Response) => {
  try {
    const id = String(req.params.id || "");
    const { title, content, category, approved, saintName, occasion } = req.body ?? {};

    const exists = await prisma.prayer.findUnique({ where: { id } });
    if (!exists) return res.status(404).json({ error: "PRAYER_NOT_FOUND" });

    const data: any = {};
    if (title !== undefined) data.title = String(title).trim();
    if (content !== undefined) data.content = String(content).trim();
    if (category !== undefined) data.category = category === null ? null : String(category).trim();
    if (approved !== undefined) data.approved = Boolean(approved);
    if (saintName !== undefined) data.saintName = saintName === null ? null : String(saintName).trim();
    if (occasion !== undefined) data.occasion = occasion === null ? null : String(occasion).trim();

    const prayer = await prisma.prayer.update({ where: { id }, data });
    return res.json(prayer);
  } catch (e) {
    console.error("PATCH /prayers/:id error:", e);
    return res.status(500).json({ error: "PRAYER_UPDATE_FAILED" });
  }
});

// DELETE /prayers/:id -> borrar
app.delete("/prayers/:id", requireAdminKey, async (req: Request, res: Response) => {
  try {
    const id = String(req.params.id || "");

    const exists = await prisma.prayer.findUnique({ where: { id } });
    if (!exists) return res.status(404).json({ error: "PRAYER_NOT_FOUND" });

    await prisma.prayer.delete({ where: { id } });
    return res.status(204).send();
  } catch (e) {
    console.error("DELETE /prayers/:id error:", e);
    return res.status(500).json({ error: "PRAYER_DELETE_FAILED" });
  }
});


app.listen(PORT, () => {
  console.log(`✅ Backend Acutis corriendo en http://localhost:${PORT}`);
});
