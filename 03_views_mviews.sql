CREATE OR REPLACE VIEW app.v_task_summary AS
SELECT
  t.task_id,
  t.title,
  t.priority,
  t.status_code,
  t.due_date,
  u.full_name AS assignee,
  COALESCE((SELECT COUNT(*) FROM app.comments c WHERE c.task_id=t.task_id),0) AS comment_count
FROM app.tasks t
LEFT JOIN app.users u ON u.user_id=t.assignee_id;

CREATE MATERIALIZED VIEW app.mv_open_tasks_per_user AS
SELECT u.user_id, u.full_name, COUNT(*) AS cnt
FROM app.tasks t
JOIN app.users u ON u.user_id=t.assignee_id
WHERE t.status_code IN ('todo','doing')
GROUP BY u.user_id,u.full_name;
