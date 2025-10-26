BEGIN;
  UPDATE app.tasks SET status_code='done' WHERE task_id=1;
  INSERT INTO app.comments(task_id,author_id,body)
  VALUES (1,2,'Tamamlandı olarak işaretlendi');
COMMIT;

BEGIN;
  UPDATE app.tasks SET status_code='done' WHERE task_id=999; -- yok
  INSERT INTO app.comments(task_id,author_id,body)
  VALUES (999,2,'hata');
ROLLBACK;
