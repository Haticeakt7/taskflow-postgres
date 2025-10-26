CREATE OR REPLACE FUNCTION app.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_tasks_updated_at
BEFORE UPDATE ON app.tasks
FOR EACH ROW
EXECUTE FUNCTION app.set_updated_at();

CREATE TABLE app.task_audit (
  audit_id BIGSERIAL PRIMARY KEY,
  task_id BIGINT NOT NULL,
  old_status TEXT,
  new_status TEXT,
  changed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION app.log_status_change()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status_code IS DISTINCT FROM OLD.status_code THEN
    INSERT INTO app.task_audit(task_id, old_status, new_status)
    VALUES (OLD.task_id, OLD.status_code, NEW.status_code);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_tasks_status_audit
AFTER UPDATE ON app.tasks
FOR EACH ROW
EXECUTE FUNCTION app.log_status_change();
