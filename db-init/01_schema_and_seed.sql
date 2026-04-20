DROP TABLE IF EXISTS buchung;
DROP TABLE IF EXISTS kurs;
DROP TABLE IF EXISTS trainer;
DROP TABLE IF EXISTS mitglied;

CREATE TABLE mitglied (
  m_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  m_vorname varchar(50) NOT NULL,
  m_nachname varchar(50) NOT NULL,
  m_email varchar(120) NOT NULL UNIQUE,
  m_geburtsdatum date NOT NULL,
  m_eintrittsdatum date NOT NULL,
  m_tarif varchar(30) NOT NULL CHECK (m_tarif IN ('Basic', 'Standard', 'Premium', 'Student', 'Senior'))
);

CREATE TABLE trainer (
  t_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  t_vorname varchar(50) NOT NULL,
  t_nachname varchar(50) NOT NULL,
  t_spezialgebiet varchar(80) NOT NULL,
  t_stundensatz numeric(8,2) NOT NULL CHECK (t_stundensatz > 0)
);

CREATE TABLE kurs (
  k_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  t_id integer NOT NULL REFERENCES trainer(t_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  k_name varchar(80) NOT NULL,
  k_startzeit timestamp NOT NULL,
  k_endzeit timestamp NOT NULL,
  k_maxteilnehmer integer NOT NULL CHECK (k_maxteilnehmer > 0),
  k_preis numeric(8,2) NOT NULL CHECK (k_preis >= 0),
  CHECK (k_endzeit > k_startzeit)
);

CREATE TABLE buchung (
  b_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  m_id integer NOT NULL REFERENCES mitglied(m_id) ON UPDATE CASCADE ON DELETE CASCADE,
  k_id integer NOT NULL REFERENCES kurs(k_id) ON UPDATE CASCADE ON DELETE CASCADE,
  b_datum date NOT NULL,
  b_status varchar(30) NOT NULL CHECK (b_status IN ('gebucht', 'bezahlt', 'storniert', 'warteliste', 'teilgenommen'))
);

CREATE INDEX idx_buchung_m_id ON buchung(m_id);
CREATE INDEX idx_buchung_k_id ON buchung(k_id);
CREATE INDEX idx_kurs_t_id ON kurs(t_id);

SELECT setseed(0.42);

INSERT INTO trainer (t_vorname, t_nachname, t_spezialgebiet, t_stundensatz)
VALUES
  ('Anna', 'Schneider', 'Yoga', 52.00),
  ('Markus', 'Weber', 'Krafttraining', 58.50),
  ('Laura', 'Fischer', 'Pilates', 49.00),
  ('Jonas', 'Becker', 'Ausdauer', 55.00),
  ('Miriam', 'Hoffmann', 'Tanz und Koordination', 47.50);

INSERT INTO kurs (t_id, k_name, k_startzeit, k_endzeit, k_maxteilnehmer, k_preis)
VALUES
  (1, 'Yoga Basics', '2026-05-04 09:00', '2026-05-04 10:00', 18, 12.00),
  (1, 'Power Yoga', '2026-05-05 18:00', '2026-05-05 19:15', 16, 15.00),
  (1, 'Meditation und Stretching', '2026-05-06 20:00', '2026-05-06 21:00', 20, 10.00),
  (1, 'Rückenfit Yoga', '2026-05-07 08:30', '2026-05-07 09:30', 18, 12.00),
  (2, 'Kraftzirkel', '2026-05-04 17:00', '2026-05-04 18:00', 14, 16.00),
  (2, 'Functional Training', '2026-05-05 19:30', '2026-05-05 20:30', 16, 17.00),
  (2, 'Langhantel Technik', '2026-05-06 18:00', '2026-05-06 19:00', 12, 18.00),
  (2, 'Core Power', '2026-05-08 12:00', '2026-05-08 12:45', 18, 11.00),
  (3, 'Pilates Einsteiger', '2026-05-04 10:30', '2026-05-04 11:30', 18, 13.00),
  (3, 'Pilates Flow', '2026-05-05 08:30', '2026-05-05 09:30', 18, 14.00),
  (3, 'Mobility Training', '2026-05-06 16:30', '2026-05-06 17:30', 20, 12.00),
  (3, 'Faszien Workout', '2026-05-08 17:30', '2026-05-08 18:30', 16, 13.50),
  (4, 'Indoor Cycling', '2026-05-04 19:00', '2026-05-04 20:00', 22, 14.00),
  (4, 'Lauftechnik', '2026-05-05 07:30', '2026-05-05 08:30', 15, 9.00),
  (4, 'HIIT Express', '2026-05-06 12:15', '2026-05-06 12:45', 20, 10.00),
  (4, 'Cardio Mix', '2026-05-07 18:30', '2026-05-07 19:30', 22, 13.00),
  (5, 'Zumba', '2026-05-04 20:15', '2026-05-04 21:15', 24, 12.00),
  (5, 'Dance Fitness', '2026-05-05 17:30', '2026-05-05 18:30', 24, 12.50),
  (5, 'Balance und Koordination', '2026-05-07 10:00', '2026-05-07 11:00', 18, 11.00),
  (5, 'Step Aerobic', '2026-05-08 19:00', '2026-05-08 20:00', 20, 13.00);

WITH
  vornamen AS (
    SELECT ARRAY[
      'Max','Sophie','Leon','Emma','Paul','Mia','Finn','Lina','Ben','Lea',
      'Tim','Marie','Noah','Clara','Elias','Hanna','Luis','Julia','Felix','Sarah'
    ] AS namen
  ),
  nachnamen AS (
    SELECT ARRAY[
      'Mueller','Schmidt','Schneider','Fischer','Weber','Meyer','Wagner','Becker','Hoffmann','Schulz',
      'Koch','Bauer','Richter','Klein','Wolf','Neumann','Schwarz','Zimmermann','Braun','Krueger'
    ] AS namen
  ),
  tarife AS (
    SELECT ARRAY['Basic','Standard','Premium','Student','Senior'] AS werte
  )
INSERT INTO mitglied (
  m_vorname,
  m_nachname,
  m_email,
  m_geburtsdatum,
  m_eintrittsdatum,
  m_tarif
)
SELECT
  v.namen[1 + floor(random() * array_length(v.namen, 1))::int],
  n.namen[1 + floor(random() * array_length(n.namen, 1))::int],
  'mitglied' || gs || '@example.test',
  date '1955-01-01' + floor(random() * 17898)::int,
  date '2020-01-01' + floor(random() * 2300)::int,
  t.werte[1 + floor(random() * array_length(t.werte, 1))::int]
FROM generate_series(1, 200) AS gs
CROSS JOIN vornamen v
CROSS JOIN nachnamen n
CROSS JOIN tarife t;

WITH
  statuses AS (
    SELECT ARRAY['gebucht','bezahlt','storniert','warteliste','teilgenommen'] AS werte
  ),
  zufaellige_paare AS (
    SELECT m.m_id, k.k_id
    FROM generate_series(1, 200) AS m(m_id)
    CROSS JOIN generate_series(1, 20) AS k(k_id)
    ORDER BY random()
    LIMIT 500
  )
INSERT INTO buchung (m_id, k_id, b_datum, b_status)
SELECT
  p.m_id,
  p.k_id,
  date '2026-04-01' + floor(random() * 50)::int,
  s.werte[1 + floor(random() * array_length(s.werte, 1))::int]
FROM zufaellige_paare p
CROSS JOIN statuses s;
