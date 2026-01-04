import { Router } from "express"
import { PrismaClient } from "@prisma/client"

const prisma = new PrismaClient()
const router = Router()

router.post("/discover-saint", async (req, res) => {
  try {
    const about = String(req.body?.about || "")
    const qualities = Array.isArray(req.body?.qualities) ? req.body.qualities.map(String) : []
    const growthAreas = Array.isArray(req.body?.growthAreas) ? req.body.growthAreas.map(String) : []

    const terms = [
      ...qualities,
      ...growthAreas,
      ...about
        .toLowerCase()
        .replace(/[^a-záéíóúñü0-9\s]/gi, " ")
        .split(/\s+/)
        .filter(Boolean),
    ]
      .map((t) => t.toLowerCase())
      .filter((t) => t.length >= 3)

    const saints = await prisma.saint.findMany({
      select: { id: true, slug: true, name: true, biography: true, patronage: true, country: true, title: true },
      take: 200,
    })

    const matches = saints
      .map((s) => {
        const hay = [
          s.name,
          s.country || "",
          s.title || "",
          (s.biography || ""),
          ...(Array.isArray(s.patronage) ? s.patronage : []),
        ].join(" ").toLowerCase()

        let score = 0
        for (const t of terms) if (hay.includes(t)) score += 1
        return { id: s.id, slug: s.slug, name: s.name, score }
      })
      .sort((a, b) => b.score - a.score)
      .slice(0, 5)

    const summary =
      matches.length
        ? "Elegimos estos santos por afinidad con tus cualidades y áreas de crecimiento. Lee su historia y elige el que más resuene contigo hoy."
        : "No encontramos coincidencias claras. Intenta escribir más sobre ti o seleccionar algunas cualidades y áreas de crecimiento."

    res.json({ summary, matches })
  } catch {
    res.status(500).json({ error: "discover-saint failed" })
  }
})

export default router
