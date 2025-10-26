CREATE INDEX idx_tasks_status          ON app.tasks(status_code);
CREATE INDEX idx_tasks_assignee_due    ON app.tasks(assignee_id, due_date);
CREATE INDEX idx_tasks_open_only       ON app.tasks(task_id)
WHERE status_code IN ('todo','doing');

ALTER TABLE app.tasks
  ADD COLUMN search_tsv tsvector GENERATED ALWAYS AS (
    setweight(to_tsvector('simple', coalesce(title,'')), 'A') ||
    setweight(to_tsvector('simple', coalesce(description,'')), 'B')
  ) STORED;

CREATE INDEX idx_tasks_search ON app.tasks USING GIN (search_tsv);
