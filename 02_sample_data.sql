INSERT INTO app.users(email,full_name) VALUES
('ada@example.com','Ada Lovelace'),
('grace@example.com','Grace Hopper'),
('linus@example.com','Linus Torvalds');

INSERT INTO app.tasks (title, description, priority, status_code, assignee_id, due_date)
VALUES
('Veritabanı şemasını bitir','DDL ve FK''lar eklenecek',2,'doing',1, now()::date + 2),
('Trigger yaz','updated_at otomatik güncellensin',1,'todo',2, now()::date + 1),
('Full-text arama ekle','title/description üstünde arama',3,'todo',1, now()::date + 7);

INSERT INTO app.comments(task_id,author_id,body) VALUES
(1,2,'FK ve CHECK kontrollerini ekledim'),
(1,1,'Indexleri sonra tutarız'),
(2,3,'Trigger için fonksiyon yazıyorum');
