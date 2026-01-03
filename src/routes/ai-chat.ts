import type { Express, Request, Response } from "express";
import OpenAI from "openai";

async function withBackoff<T>(fn: () => Promise<T>, max = 5) {
  let delay = 500;
  for (let i = 0; i < max; i++) {
    try {
      return await fn();
    } catch (e: any) {
      if (e?.status !== 429) throw e;
      const jitter = Math.floor(Math.random() * 200);
      await new Promise((r) => setTimeout(r, delay + jitter));
      delay *= 2;
    }
  }
  return await fn();
}

export function registerAiChatRoute(app: Express) {
  const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
  const model = process.env.OPENAI_MODEL || "gpt-4o-mini";

  app.post("/ai/chat", async (req: Request, res: Response) => {
    try {
      const message = String(req.body?.message || "").trim();
      const lang = String(req.body?.lang || "es").trim();
      if (!message) return res.status(400).json({ error: "MESSAGE_REQUIRED" });

      const system = lang.startsWith("en")
        ? "You are a Catholic assistant. Answer with a short, warm, respectful response. If asked for a prayer, provide one. Add a short disclaimer: this is general guidance and does not replace a priest or spiritual director."
        : "Eres un asistente católico. Responde de forma breve, cálida y respetuosa. Si te piden una oración, dásela. Agrega un descargo corto: es orientación general y no reemplaza a un sacerdote o director espiritual.";

      const result = await withBackoff(async () => {
        return await client.chat.completions.create({
          model,
          messages: [
            { role: "system", content: system },
            { role: "user", content: message },
          ],
          temperature: 0.7,
          max_tokens: 350,
        });
      });

      const answer = result.choices?.[0]?.message?.content?.trim() || "";
      return res.json({ answer });
    } catch (e: any) {
      const status = e?.status === 429 ? 429 : 500;
      return res.status(status).json({ error: "AI_CHAT_FAILED", detail: e?.message || "unknown" });
    }
  });
}
