-- ============================================================================
-- Migration: Create core tables for Enler
-- Version: 20260603000001
-- Description: Creates profiles, questions, quiz_sessions, answers tables
--              with RLS policies, indexes, constraints, and triggers.
-- ============================================================================

-- ============================================================================
-- 1. TABLES
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1.1 profiles
-- ---------------------------------------------------------------------------
CREATE TABLE public.profiles (
    id              uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         uuid        NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
    username        text        NOT NULL UNIQUE,
    display_name    text        NOT NULL,
    avatar_emoji    text        NOT NULL DEFAULT '😊',
    avatar_url      text,
    question_count  integer     NOT NULL DEFAULT 0,
    total_plays     integer     NOT NULL DEFAULT 0,
    share_count     integer     NOT NULL DEFAULT 0,
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.profiles IS 'User profiles - one per authenticated user';
COMMENT ON COLUMN public.profiles.username IS 'URL-safe username, used in quiz links (enlerapp.com/username)';
COMMENT ON COLUMN public.profiles.avatar_emoji IS 'Emoji avatar (3 emoji combination)';
COMMENT ON COLUMN public.profiles.question_count IS 'Auto-updated via trigger, denormalized for performance';
COMMENT ON COLUMN public.profiles.total_plays IS 'Auto-updated via trigger, denormalized for performance';

-- ---------------------------------------------------------------------------
-- 1.2 questions
-- ---------------------------------------------------------------------------
CREATE TABLE public.questions (
    id              uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id      uuid        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    category        text        NOT NULL,
    question_text   text        NOT NULL,
    correct_answer  text        NOT NULL,
    wrong_answers   text[]      NOT NULL,
    order_index     integer     NOT NULL DEFAULT 0,
    is_ai_generated boolean     NOT NULL DEFAULT true,
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.questions IS 'Quiz questions created by profile owners, max 10 per profile';
COMMENT ON COLUMN public.questions.wrong_answers IS 'Array of exactly 3 wrong answers (AI-generated or manual)';

-- ---------------------------------------------------------------------------
-- 1.3 quiz_sessions
-- ---------------------------------------------------------------------------
CREATE TABLE public.quiz_sessions (
    id              uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id      uuid        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    player_name     text        NOT NULL,
    player_id       uuid        REFERENCES auth.users(id) ON DELETE SET NULL,
    is_anonymous    boolean     NOT NULL DEFAULT true,
    total_questions integer     NOT NULL,
    correct_answers integer     NOT NULL DEFAULT 0,
    percentage      integer     NOT NULL DEFAULT 0,
    badge           text,
    started_at      timestamptz NOT NULL DEFAULT now(),
    completed_at    timestamptz,
    created_at      timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.quiz_sessions IS 'Each quiz attempt by a friend';
COMMENT ON COLUMN public.quiz_sessions.badge IS 'Badge key assigned on completion (stranger, acquaintance, friend, close_friend, best_friend, soulmate)';

-- ---------------------------------------------------------------------------
-- 1.4 answers
-- ---------------------------------------------------------------------------
CREATE TABLE public.answers (
    id              uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id      uuid        NOT NULL REFERENCES public.quiz_sessions(id) ON DELETE CASCADE,
    question_id     uuid        NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
    selected_answer text        NOT NULL,
    is_correct      boolean     NOT NULL,
    answered_at     timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.answers IS 'Individual answers within a quiz session, immutable once submitted';


-- ============================================================================
-- 2. CHECK CONSTRAINTS
-- ============================================================================

-- profiles
ALTER TABLE public.profiles
    ADD CONSTRAINT chk_profiles_username
    CHECK (username ~ '^[a-z0-9_.]{3,20}$');

ALTER TABLE public.profiles
    ADD CONSTRAINT chk_profiles_display_name
    CHECK (char_length(trim(display_name)) BETWEEN 1 AND 30);

ALTER TABLE public.profiles
    ADD CONSTRAINT chk_profiles_avatar_emoji
    CHECK (char_length(avatar_emoji) BETWEEN 1 AND 10);

ALTER TABLE public.profiles
    ADD CONSTRAINT chk_profiles_question_count_positive
    CHECK (question_count >= 0);

ALTER TABLE public.profiles
    ADD CONSTRAINT chk_profiles_total_plays_positive
    CHECK (total_plays >= 0);

ALTER TABLE public.profiles
    ADD CONSTRAINT chk_profiles_share_count_positive
    CHECK (share_count >= 0);

-- questions
ALTER TABLE public.questions
    ADD CONSTRAINT chk_questions_category
    CHECK (category IN (
        'favorite_color', 'favorite_food', 'favorite_movie',
        'favorite_music', 'favorite_hobby', 'favorite_place',
        'favorite_book', 'favorite_animal', 'favorite_sport',
        'favorite_season', 'personality', 'dream',
        'memory', 'preference', 'custom'
    ));

ALTER TABLE public.questions
    ADD CONSTRAINT chk_questions_question_text
    CHECK (char_length(trim(question_text)) BETWEEN 1 AND 200);

ALTER TABLE public.questions
    ADD CONSTRAINT chk_questions_correct_answer
    CHECK (char_length(trim(correct_answer)) BETWEEN 1 AND 100);

ALTER TABLE public.questions
    ADD CONSTRAINT chk_questions_wrong_answers_count
    CHECK (array_length(wrong_answers, 1) = 3);

ALTER TABLE public.questions
    ADD CONSTRAINT chk_questions_order_index
    CHECK (order_index BETWEEN 0 AND 9);

-- quiz_sessions
ALTER TABLE public.quiz_sessions
    ADD CONSTRAINT chk_quiz_sessions_player_name
    CHECK (char_length(trim(player_name)) BETWEEN 1 AND 30);

ALTER TABLE public.quiz_sessions
    ADD CONSTRAINT chk_quiz_sessions_total_questions
    CHECK (total_questions BETWEEN 1 AND 10);

ALTER TABLE public.quiz_sessions
    ADD CONSTRAINT chk_quiz_sessions_correct_answers
    CHECK (correct_answers BETWEEN 0 AND total_questions);

ALTER TABLE public.quiz_sessions
    ADD CONSTRAINT chk_quiz_sessions_percentage
    CHECK (percentage BETWEEN 0 AND 100);

ALTER TABLE public.quiz_sessions
    ADD CONSTRAINT chk_quiz_sessions_badge
    CHECK (badge IS NULL OR badge IN (
        'stranger', 'acquaintance', 'friend',
        'close_friend', 'best_friend', 'soulmate'
    ));

ALTER TABLE public.quiz_sessions
    ADD CONSTRAINT chk_quiz_sessions_completed_after_started
    CHECK (completed_at IS NULL OR completed_at >= started_at);

-- answers
ALTER TABLE public.answers
    ADD CONSTRAINT chk_answers_selected_answer
    CHECK (char_length(trim(selected_answer)) BETWEEN 1 AND 100);

ALTER TABLE public.answers
    ADD CONSTRAINT uq_answers_session_question
    UNIQUE (session_id, question_id);


-- ============================================================================
-- 3. INDEXES
-- ============================================================================

-- questions: fetch for a profile, ordered
CREATE INDEX idx_questions_profile_id_order
    ON public.questions (profile_id, order_index);

-- quiz_sessions: leaderboard (completed sessions, highest score first)
CREATE INDEX idx_quiz_sessions_profile_leaderboard
    ON public.quiz_sessions (profile_id, percentage DESC, completed_at DESC)
    WHERE completed_at IS NOT NULL;

-- quiz_sessions: player lookup
CREATE INDEX idx_quiz_sessions_player_id
    ON public.quiz_sessions (player_id)
    WHERE player_id IS NOT NULL;

-- quiz_sessions: profile stats
CREATE INDEX idx_quiz_sessions_profile_completed
    ON public.quiz_sessions (profile_id)
    WHERE completed_at IS NOT NULL;

-- answers: fetch all answers in a session
CREATE INDEX idx_answers_session_id
    ON public.answers (session_id);

-- answers: question analytics
CREATE INDEX idx_answers_question_correct
    ON public.answers (question_id, is_correct);


-- ============================================================================
-- 4. FUNCTIONS & TRIGGERS
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 4.1 Auto-update updated_at timestamp
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.fn_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_set_updated_at();

CREATE TRIGGER trg_questions_updated_at
    BEFORE UPDATE ON public.questions
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_set_updated_at();

-- ---------------------------------------------------------------------------
-- 4.2 Auto-update profiles.question_count
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.fn_update_question_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.profiles
        SET question_count = (
            SELECT count(*) FROM public.questions WHERE profile_id = NEW.profile_id
        ),
        updated_at = now()
        WHERE id = NEW.profile_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.profiles
        SET question_count = (
            SELECT count(*) FROM public.questions WHERE profile_id = OLD.profile_id
        ),
        updated_at = now()
        WHERE id = OLD.profile_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_update_question_count
    AFTER INSERT OR DELETE ON public.questions
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_update_question_count();

-- ---------------------------------------------------------------------------
-- 4.3 Auto-update profiles.total_plays
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.fn_update_total_plays()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.completed_at IS NOT NULL AND (OLD.completed_at IS NULL OR TG_OP = 'INSERT') THEN
        UPDATE public.profiles
        SET total_plays = (
            SELECT count(*) FROM public.quiz_sessions
            WHERE profile_id = NEW.profile_id AND completed_at IS NOT NULL
        ),
        updated_at = now()
        WHERE id = NEW.profile_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_update_total_plays
    AFTER INSERT OR UPDATE OF completed_at ON public.quiz_sessions
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_update_total_plays();

-- ---------------------------------------------------------------------------
-- 4.4 Enforce max 10 questions per profile
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.fn_enforce_max_questions()
RETURNS TRIGGER AS $$
DECLARE
    current_count integer;
BEGIN
    SELECT count(*) INTO current_count
    FROM public.questions
    WHERE profile_id = NEW.profile_id;

    IF current_count >= 10 THEN
        RAISE EXCEPTION 'Maximum 10 questions per profile allowed'
            USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_enforce_max_questions
    BEFORE INSERT ON public.questions
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_enforce_max_questions();

-- ---------------------------------------------------------------------------
-- 4.5 Auto-assign badge based on percentage
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.fn_assign_badge()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.completed_at IS NOT NULL AND NEW.badge IS NULL THEN
        NEW.badge = CASE
            WHEN NEW.percentage = 100 THEN 'soulmate'
            WHEN NEW.percentage >= 81  THEN 'best_friend'
            WHEN NEW.percentage >= 61  THEN 'close_friend'
            WHEN NEW.percentage >= 41  THEN 'friend'
            WHEN NEW.percentage >= 21  THEN 'acquaintance'
            ELSE 'stranger'
        END;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_assign_badge
    BEFORE INSERT OR UPDATE OF completed_at, percentage ON public.quiz_sessions
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_assign_badge();


-- ============================================================================
-- 5. ROW LEVEL SECURITY
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 5.1 profiles RLS
-- ---------------------------------------------------------------------------
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Profiles are viewable by everyone"
    ON public.profiles FOR SELECT
    USING (true);

CREATE POLICY "Users can create their own profile"
    ON public.profiles FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own profile"
    ON public.profiles FOR DELETE
    USING (auth.uid() = user_id);

-- ---------------------------------------------------------------------------
-- 5.2 questions RLS
-- ---------------------------------------------------------------------------
ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Questions are viewable by everyone"
    ON public.questions FOR SELECT
    USING (true);

CREATE POLICY "Profile owners can create questions"
    ON public.questions FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = profile_id
            AND profiles.user_id = auth.uid()
        )
    );

CREATE POLICY "Profile owners can update questions"
    ON public.questions FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = profile_id
            AND profiles.user_id = auth.uid()
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = profile_id
            AND profiles.user_id = auth.uid()
        )
    );

CREATE POLICY "Profile owners can delete questions"
    ON public.questions FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = profile_id
            AND profiles.user_id = auth.uid()
        )
    );

-- ---------------------------------------------------------------------------
-- 5.3 quiz_sessions RLS
-- ---------------------------------------------------------------------------
ALTER TABLE public.quiz_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Sessions viewable by profile owner and quiz taker"
    ON public.quiz_sessions FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = profile_id
            AND profiles.user_id = auth.uid()
        )
        OR player_id = auth.uid()
        OR (is_anonymous = true AND completed_at IS NOT NULL)
    );

CREATE POLICY "Anyone can create a quiz session"
    ON public.quiz_sessions FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Quiz takers can update their session"
    ON public.quiz_sessions FOR UPDATE
    USING (
        player_id = auth.uid()
        OR (is_anonymous = true AND player_id IS NULL)
    )
    WITH CHECK (
        player_id = auth.uid()
        OR (is_anonymous = true AND player_id IS NULL)
    );

-- ---------------------------------------------------------------------------
-- 5.4 answers RLS
-- ---------------------------------------------------------------------------
ALTER TABLE public.answers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Answers viewable by profile owner and session owner"
    ON public.answers FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.quiz_sessions qs
            JOIN public.profiles p ON p.id = qs.profile_id
            WHERE qs.id = session_id
            AND (
                p.user_id = auth.uid()
                OR qs.player_id = auth.uid()
                OR (qs.is_anonymous = true AND qs.completed_at IS NOT NULL)
            )
        )
    );

CREATE POLICY "Anyone can submit answers"
    ON public.answers FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.quiz_sessions
            WHERE quiz_sessions.id = session_id
            AND completed_at IS NULL
        )
    );


-- ============================================================================
-- 6. ENABLE REALTIME (for leaderboard)
-- ============================================================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.quiz_sessions;
