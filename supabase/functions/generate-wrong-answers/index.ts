// Edge Function: generate-wrong-answers
// Generates 3 plausible wrong answers for a quiz question using Gemini API
//
// POST /generate-wrong-answers
// Body: { category: string, correct_answer: string, question_text: string, language: string }
// Response: { wrong_answers: string[] }

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface RequestBody {
  category: string;
  correct_answer: string;
  question_text: string;
  language?: string;
}

interface GeminiResponse {
  candidates: Array<{
    content: {
      parts: Array<{
        text: string;
      }>;
    };
  }>;
}

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Validate request
    if (req.method !== "POST") {
      return new Response(
        JSON.stringify({ error: "Method not allowed" }),
        { status: 405, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const body: RequestBody = await req.json();
    const { category, correct_answer, question_text, language = "tr" } = body;

    // Input validation
    if (!category || !correct_answer || !question_text) {
      return new Response(
        JSON.stringify({ error: "Missing required fields: category, correct_answer, question_text" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    if (correct_answer.length > 100 || question_text.length > 200) {
      return new Response(
        JSON.stringify({ error: "Input too long" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Build Gemini prompt
    const prompt = buildPrompt(category, correct_answer, question_text, language);

    // Call Gemini API
    const geminiApiKey = Deno.env.get("GEMINI_API_KEY");
    if (!geminiApiKey) {
      console.error("GEMINI_API_KEY not set");
      return new Response(
        JSON.stringify({ error: "AI service not configured" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const geminiResponse = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${geminiApiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          generationConfig: {
            temperature: 0.8,
            maxOutputTokens: 256,
            responseMimeType: "application/json",
          },
        }),
      }
    );

    if (!geminiResponse.ok) {
      console.error("Gemini API error:", await geminiResponse.text());
      // Fallback: generate basic wrong answers
      const fallback = generateFallbackAnswers(correct_answer, category);
      return new Response(
        JSON.stringify({ wrong_answers: fallback, source: "fallback" }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const geminiData: GeminiResponse = await geminiResponse.json();
    const responseText = geminiData.candidates?.[0]?.content?.parts?.[0]?.text;

    if (!responseText) {
      const fallback = generateFallbackAnswers(correct_answer, category);
      return new Response(
        JSON.stringify({ wrong_answers: fallback, source: "fallback" }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Parse Gemini response
    const parsed = JSON.parse(responseText);
    const wrongAnswers: string[] = parsed.wrong_answers || parsed.answers || [];

    // Validate: exactly 3, none matching correct answer
    const filtered = wrongAnswers
      .filter((a: string) => a.toLowerCase().trim() !== correct_answer.toLowerCase().trim())
      .slice(0, 3);

    if (filtered.length < 3) {
      const fallback = generateFallbackAnswers(correct_answer, category);
      const combined = [...filtered, ...fallback].slice(0, 3);
      return new Response(
        JSON.stringify({ wrong_answers: combined, source: "mixed" }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    return new Response(
      JSON.stringify({ wrong_answers: filtered, source: "gemini" }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error) {
    console.error("Error:", error);
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});


function buildPrompt(
  category: string,
  correctAnswer: string,
  questionText: string,
  language: string
): string {
  const langInstructions = language === "tr"
    ? "Türkçe olarak yanıtla. Yanıtlar doğal ve inandırıcı Türkçe olmalı."
    : "Respond in English. Answers should be natural and believable.";

  return `You are a quiz assistant for a social app called "Enler".

${langInstructions}

Given a quiz question and the correct answer, generate exactly 3 plausible but WRONG alternative answers.

Rules:
- The wrong answers must be DIFFERENT from the correct answer
- The wrong answers must be in the same category/type as the correct answer
- The wrong answers must be plausible (someone might actually choose them)
- Keep each answer concise (max 50 characters)
- Do NOT include the correct answer in the wrong answers
- Make the wrong answers diverse (don't pick very similar options)

Question category: ${category}
Question: ${questionText}
Correct answer: ${correctAnswer}

Respond in this exact JSON format:
{"wrong_answers": ["answer1", "answer2", "answer3"]}`;
}


function generateFallbackAnswers(correctAnswer: string, category: string): string[] {
  // Simple fallback when AI is unavailable
  const fallbacks: Record<string, string[][]> = {
    favorite_food: [
      ["Pizza", "Lahmacun", "Döner", "Mantı", "İskender", "Karnıyarık"],
      ["Sushi", "Burger", "Makarna", "Kebap", "Pide", "Köfte"],
    ],
    favorite_movie: [
      ["Inception", "The Matrix", "Interstellar", "Fight Club", "Titanic"],
      ["Hababam Sınıfı", "G.O.R.A.", "Recep İvedik", "Vizontele", "Babam ve Oğlum"],
    ],
    favorite_music: [
      ["Pop", "Rock", "Rap", "Jazz", "Klasik", "R&B", "Arabesk"],
      ["Tarkan", "Sezen Aksu", "Barış Manço", "MFÖ", "Teoman"],
    ],
    favorite_color: [
      ["Mavi", "Kırmızı", "Yeşil", "Mor", "Siyah", "Beyaz", "Turuncu", "Sarı"],
    ],
    default: [
      ["Seçenek A", "Seçenek B", "Seçenek C", "Seçenek D", "Seçenek E"],
    ],
  };

  const categoryFallbacks = fallbacks[category] || fallbacks.default;
  const pool = categoryFallbacks.flat().filter(
    (a) => a.toLowerCase() !== correctAnswer.toLowerCase()
  );

  // Shuffle and pick 3
  const shuffled = pool.sort(() => Math.random() - 0.5);
  return shuffled.slice(0, 3);
}
