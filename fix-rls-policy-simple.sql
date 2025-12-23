-- ============================================
-- Flow 댓글 작성 RLS 정책 - 간단 버전
-- ============================================
-- posts 테이블 정책은 이미 있으므로 comments만 수정합니다.

-- 기존 INSERT 정책들 모두 삭제
DROP POLICY IF EXISTS "Anyone can create comments" ON comments;
DROP POLICY IF EXISTS "anon insert comments" ON comments;
DROP POLICY IF EXISTS "insert_comments" ON comments;
DROP POLICY IF EXISTS "Allow anon to insert comments" ON comments;

-- comments 테이블 INSERT 정책 생성 (public 역할 사용)
-- WITH CHECK에서 posts 테이블을 참조하여 post_id가 존재하는지 확인
CREATE POLICY "Allow anon to insert comments"
ON comments FOR INSERT
TO public
WITH CHECK (
  EXISTS (
    SELECT 1 FROM posts 
    WHERE posts.id = comments.post_id
  )
);

-- 정책 확인
SELECT * FROM pg_policies WHERE tablename = 'comments';

