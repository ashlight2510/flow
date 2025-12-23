-- ============================================
-- Flow 댓글 작성 RLS 정책 수정 스크립트
-- ============================================
-- 이 스크립트는 Supabase SQL Editor에서 실행하세요.
-- Supabase 대시보드 → SQL Editor → New Query → 이 스크립트 붙여넣기 → Run

-- 참고: posts 테이블의 SELECT 정책은 이미 존재하므로 건드리지 않습니다.
-- comments 테이블의 INSERT 정책만 생성합니다.

-- 1단계: 기존 comments INSERT 정책들 모두 삭제
-- (이미지에서 확인된 기존 정책들)
DROP POLICY IF EXISTS "Anyone can create comments" ON comments;
DROP POLICY IF EXISTS "anon insert comments" ON comments;
DROP POLICY IF EXISTS "insert_comments" ON comments;
DROP POLICY IF EXISTS "Allow anon to insert comments" ON comments;

-- 2단계: comments 테이블 INSERT 정책 생성
-- WITH CHECK에서 posts 테이블을 참조하여 post_id가 존재하는지 확인
-- (posts 테이블의 SELECT 정책이 이미 있으므로 외래 키 검증이 가능합니다)
-- 역할은 public을 사용 (기존 정책들과 동일)
CREATE POLICY "Allow anon to insert comments"
ON comments FOR INSERT
TO public
WITH CHECK (
  EXISTS (
    SELECT 1 FROM posts 
    WHERE posts.id = comments.post_id
  )
);

-- 또는 더 간단하게 (모든 댓글 허용, 보안이 덜 엄격함):
-- DROP POLICY IF EXISTS "Allow anon to insert comments" ON comments;
-- CREATE POLICY "Allow anon to insert comments"
-- ON comments FOR INSERT
-- TO anon
-- WITH CHECK (true);

-- 3단계: 정책 확인
SELECT * FROM pg_policies WHERE tablename = 'comments';

-- ============================================
-- 실행 후 확인사항:
-- 1. comments 테이블에 "Allow anon to insert comments" 정책이 있는지 확인
-- 2. 브라우저에서 댓글 작성이 정상 작동하는지 테스트
-- ============================================

-- ============================================
-- 간단 버전 (위 스크립트가 에러나면 이것만 실행):
-- ============================================
-- DROP POLICY IF EXISTS "Anyone can create comments" ON comments;
-- DROP POLICY IF EXISTS "anon insert comments" ON comments;
-- DROP POLICY IF EXISTS "insert_comments" ON comments;
-- DROP POLICY IF EXISTS "Allow anon to insert comments" ON comments;
-- 
-- CREATE POLICY "Allow anon to insert comments"
-- ON comments FOR INSERT
-- TO public
-- WITH CHECK (true);

