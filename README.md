**TaskFlow – PostgreSQL + Docker Öğrenme Projesi**

**Amaç:**  

PostgreSQL'in temellerini (şema, constraint, trigger, view, mview, index, full-text search, transaction) gerçek bir örnek proje üzerinden öğrenmek.

**1. Başlangıç**

Docker PostgreSQL Container Çalıştırma

docker run --name pg16 \\

&nbsp; -e POSTGRES\_USER=dev \\

&nbsp; -e POSTGRES\_PASSWORD=devpass \\

&nbsp; -e POSTGRES\_DB=taskflow \\

&nbsp; -p 5432:5432 \\

&nbsp; -d postgres:16

PostgreSQL’e bağlan

docker exec -it pg16 psql -U dev -d taskflow

**2. Veritabanı Şeması**

Şema: app



Tablo			Amaç



users			Kullanıcı bilgileri

statuses		Görev durum sözlüğü

tasks			Görevler (öncelik, tarih, kullanıcı, durum)

comments		Görevlere yapılan yorumlar

task\_audit		Durum değişim logları



**3. Örnek SQL Komutları**

Şema ve tabloların oluşturulması

01\_schema.sql

CREATE SCHEMA app;

CREATE TABLE app.users (...);

CREATE TABLE app.statuses (...);

CREATE TABLE app.tasks (...);

CREATE TABLE app.comments (...);

Örnek veri ekleme

02\_sample\_data.sql

INSERT INTO app.users(email,full\_name) VALUES

('ada@example.com','Ada Lovelace'),

('grace@example.com','Grace Hopper');

**4. Görünümler (Views)**

4.1 v\_task\_summary

Görev + kullanıcı + yorum sayısı özet görünümü

Her sorguda canlı veri çeker.

CREATE OR REPLACE VIEW app.v\_task\_summary AS ...

4.2 mv\_open\_tasks\_per\_user

Kullanıcı başına açık görev sayısını önceden hesaplar.

CREATE MATERIALIZED VIEW app.mv\_open\_tasks\_per\_user AS ...

REFRESH MATERIALIZED VIEW app.mv\_open\_tasks\_per\_user;

**5. Trigger ve Fonksiyonlar**

trg\_tasks\_updated\_at

Güncelleme sonrası updated\_at kolonunu otomatik günceller.

trg\_tasks\_status\_audit

Görev durumu değiştiğinde task\_audit tablosuna kayıt ekler.

**6. Full-Text Search (FTS)**

ALTER TABLE app.tasks

ADD COLUMN search\_tsv tsvector GENERATED ALWAYS AS (

&nbsp; setweight(to\_tsvector('simple', coalesce(title,'')), 'A') ||

&nbsp; setweight(to\_tsvector('simple', coalesce(description,'')), 'B')

) STORED;

CREATE INDEX idx\_tasks\_search ON app.tasks USING GIN(search\_tsv);

Arama örneği:

SELECT task\_id, title

FROM app.tasks

WHERE search\_tsv @@ plainto\_tsquery('simple', 'trigger arama');

**7. Transaction Örneği**

BEGIN;

&nbsp; UPDATE app.tasks SET status\_code='done' WHERE task\_id=1;

&nbsp; INSERT INTO app.comments(task\_id,author\_id,body)

&nbsp; VALUES (1,2,'Tamamlandı olarak işaretlendi');

COMMIT;

**8. Dosya Yapısı**

taskflow-postgres

&nbsp;┣  01\_schema.sql

&nbsp;┣  02\_sample\_data.sql

&nbsp;┣  03\_views\_mviews.sql

&nbsp;┣  04\_triggers.sql

&nbsp;┣  05\_indexes\_fts.sql

&nbsp;┣  06\_transactions.sql

&nbsp;┗  README.md

**9. Öğrenilen Kavramlar**

CHECK, DEFAULT, FOREIGN KEY, ON DELETE

VIEW vs MATERIALIZED VIEW

TRIGGER, PL/pgSQL fonksiyonları

GIN, BTREE index türleri

Transaction yapısı (BEGIN, COMMIT, ROLLBACK)

**10. Docker Komutları**

Komut	Açıklama

docker ps	Çalışan container’lar

docker logs pg16	Log’ları gör

docker exec -it pg16 bash	Container içine gir

docker stop pg16 / docker start pg16	Durdur / başlat

docker rm -f pg16	Tamamen sil

**11. Geliştirici**

Hazırlayan: Hatice Nur Aktoğan

