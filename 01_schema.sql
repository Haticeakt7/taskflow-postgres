DROP SCHEMA IF EXISTS app CASCADE;
CREATE SCHEMA app;

CREATE TABLE app.users (
  user_id BIGSERIAL PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  full_name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE app.statuses (
  status_code TEXT PRIMARY KEY,
  label TEXT NOT NULL
);

INSERT INTO app.statuses(status_code,label) VALUES
('todo','To Do'),('doing','In Progress'),('done','Done'),('archived','Archived');

CREATE TABLE app.tasks (
  task_id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL CHECK (length(title) BETWEEN 3 AND 140),
  description TEXT,
  priority INT NOT NULL DEFAULT 3 CHECK (priority BETWEEN 1 AND 5),
  status_code TEXT NOT NULL REFERENCES app.statuses(status_code),
  assignee_id BIGINT REFERENCES app.users(user_id) ON DELETE SET NULL,
  due_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE app.comments (
  comment_id BIGSERIAL PRIMARY KEY,
  task_id BIGINT NOT NULL REFERENCES app.tasks(task_id) ON DELETE CASCADE,
  author_id BIGINT NOT NULL REFERENCES app.users(user_id) ON DELETE CASCADE,
  body TEXT NOT NULL CHECK (length(body) > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
