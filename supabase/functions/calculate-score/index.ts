// Edge Function: calculate-score
// Calculates quiz score, assigns badge, and updates the quiz session
// This is SERVER-AUTHORITATIVE — clients cannot directly write scores
//
// POST /calculate-score
// Body: { session_id: string }
// Response: { percentage: number, badge: string, correct_answers: number, total_questions: number, slogan: string }

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface BadgeInfo {
  key: string;
  name_tr: string;
  emoji: string;
  slogan_tr: string;
}

const BADGE_TIERS: Record<string, BadgeInfo> = {
  stranger: {
    key: "stranger",
    name_tr: "Yabancı",
    emoji: "🤷",
    slogan_tr: "Hiç tanımıyor musun ya? 😅",
  },
  acquaintance: {
    key: "acquaintance",
    name_tr: "Tanıdık",
    emoji: "👋",
    slogan_tr: "Vasat bir arkadaşlık, geliştirmeye açık 😄",
  },
  friend: {
    key: "friend",
    name_tr: "Arkadaş",
    emoji: "😊",
    slogan_tr: "Fena değil, ama daha iyisini yapabilirsin 💪",
  },
  close_friend: {
    key: "close_friend",
    name_tr: "Yakın Dost",
    emoji: "🤝",
    slogan_tr: "Ciddi ciddi tanıyorsun, saygılar 🙌",
  },
  best_friend: {
    key: "best_friend",
    name_tr: "Kanka",
    emoji: "💪",
    slogan_tr: "Neredeyse kankasın, biraz daha stalkla 👀",
  },
  soulmate: {
    key: "soulmate",
    name_tr: "Stalker",
    emoji: "👀",
    slogan_tr: "Resmen stalker, ödülü hakkediyorsun 🕵️",
  },
};

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    if (req.method !== "POST") {
      return new Response(
        JSON.stringify({ error: "Method not allowed" }),
        { status: 405, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const { session_id } = await req.json();

    if (!session_id) {
      return new Response(
        JSON.stringify({ error: "Missing required field: session_id" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Create admin client (bypasses RLS for score calculation)
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    // Fetch session
    const { data: session, error: sessionError } = await supabaseAdmin
      .from("quiz_sessions")
      .select("id, profile_id, total_questions, completed_at")
      .eq("id", session_id)
      .maybeSingle();

    if (sessionError || !session) {
      return new Response(
        JSON.stringify({ error: "Session not found" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    if (session.completed_at) {
      return new Response(
        JSON.stringify({ error: "Session already completed" }),
        { status: 409, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Count correct answers
    const { count: correctCount, error: countError } = await supabaseAdmin
      .from("answers")
      .select("id", { count: "exact", head: true })
      .eq("session_id", session_id)
      .eq("is_correct", true);

    if (countError) {
      console.error("Count error:", countError);
      return new Response(
        JSON.stringify({ error: "Failed to calculate score" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const correctAnswers = correctCount ?? 0;
    const totalQuestions = session.total_questions;
    const percentage = totalQuestions > 0
      ? Math.round((correctAnswers / totalQuestions) * 100)
      : 0;

    // Determine badge
    const badgeKey = getBadgeKey(percentage);
    const badgeInfo = BADGE_TIERS[badgeKey];

    // Update session with score (server-authoritative)
    const { error: updateError } = await supabaseAdmin
      .from("quiz_sessions")
      .update({
        correct_answers: correctAnswers,
        percentage,
        badge: badgeKey,
        completed_at: new Date().toISOString(),
      })
      .eq("id", session_id);

    if (updateError) {
      console.error("Update error:", updateError);
      return new Response(
        JSON.stringify({ error: "Failed to save score" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Get rank (how many people scored higher)
    const { count: betterCount } = await supabaseAdmin
      .from("quiz_sessions")
      .select("id", { count: "exact", head: true })
      .eq("profile_id", session.profile_id)
      .gt("percentage", percentage)
      .not("completed_at", "is", null);

    return new Response(
      JSON.stringify({
        percentage,
        badge: badgeKey,
        badge_name: badgeInfo.name_tr,
        badge_emoji: badgeInfo.emoji,
        slogan: badgeInfo.slogan_tr,
        correct_answers: correctAnswers,
        total_questions: totalQuestions,
        rank_above: betterCount ?? 0,
      }),
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

function getBadgeKey(percentage: number): string {
  if (percentage === 100) return "soulmate";
  if (percentage >= 81) return "best_friend";
  if (percentage >= 61) return "close_friend";
  if (percentage >= 41) return "friend";
  if (percentage >= 21) return "acquaintance";
  return "stranger";
}
