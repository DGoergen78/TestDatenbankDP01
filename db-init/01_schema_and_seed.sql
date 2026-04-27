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

-- Trainer
-- Wichtig: Trainer 6 hat absichtlich keinen Kurs
INSERT INTO trainer (t_vorname, t_nachname, t_spezialgebiet, t_stundensatz)
VALUES
  ('Anna', 'Schneider', 'Yoga', 52.00),
  ('Markus', 'Weber', 'Krafttraining', 58.50),
  ('Laura', 'Fischer', 'Pilates', 49.00),
  ('Jonas', 'Becker', 'Ausdauer', 55.00),
  ('Miriam', 'Hoffmann', 'Tanz und Koordination', 47.50),
  ('Thomas', 'Lehmann', 'Reha-Sport', 60.00);

-- Kurse
-- Wichtig: Einige Kurse werden später nicht gebucht
INSERT INTO kurs (t_id, k_name, k_startzeit, k_endzeit, k_maxteilnehmer, k_preis)
VALUES
  (1, 'Yoga Basics', '2026-05-04 09:00', '2026-05-04 10:00', 18, 12.00),
  (1, 'Power Yoga', '2026-05-05 18:00', '2026-05-05 19:15', 16, 15.00),
  (2, 'Kraftzirkel', '2026-05-04 17:00', '2026-05-04 18:00', 14, 16.00),
  (2, 'Functional Training', '2026-05-05 19:30', '2026-05-05 20:30', 16, 17.00),
  (3, 'Pilates Einsteiger', '2026-05-04 10:30', '2026-05-04 11:30', 18, 13.00),
  (3, 'Pilates Flow', '2026-05-05 08:30', '2026-05-05 09:30', 18, 14.00),
  (4, 'Indoor Cycling', '2026-05-04 19:00', '2026-05-04 20:00', 22, 14.00),
  (4, 'HIIT Express', '2026-05-06 12:15', '2026-05-06 12:45', 20, 10.00),
  (5, 'Zumba', '2026-05-04 20:15', '2026-05-04 21:15', 24, 12.00),
  (5, 'Dance Fitness', '2026-05-05 17:30', '2026-05-05 18:30', 24, 12.50),

  -- absichtlich ungebuchte Kurse
  (1, 'Meditation und Stretching', '2026-05-06 20:00', '2026-05-06 21:00', 20, 10.00),
  (3, 'Mobility Training', '2026-05-06 16:30', '2026-05-06 17:30', 20, 12.00),
  (5, 'Balance und Koordination', '2026-05-07 10:00', '2026-05-07 11:00', 18, 11.00);

-- Mitglieder
-- Wichtig: Mitglieder 9 bis 12 haben absichtlich keine Buchung
INSERT INTO mitglied (
  m_vorname,
  m_nachname,
  m_email,
  m_geburtsdatum,
  m_eintrittsdatum,
  m_tarif
)
VALUES
  ('Max', 'Mueller', 'max.mueller@example.test', '1998-04-12', '2023-01-10', 'Basic'),
  ('Sophie', 'Schmidt', 'sophie.schmidt@example.test', '2001-08-03', '2022-11-15', 'Student'),
  ('Leon', 'Schneider', 'leon.schneider@example.test', '1995-02-20', '2021-06-01', 'Premium'),
  ('Emma', 'Fischer', 'emma.fischer@example.test', '1988-12-01', '2020-03-20', 'Standard'),
  ('Paul', 'Weber', 'paul.weber@example.test', '1975-07-09', '2024-02-05', 'Senior'),
  ('Mia', 'Meyer', 'mia.meyer@example.test', '1999-09-17', '2023-09-01', 'Basic'),
  ('Finn', 'Wagner', 'finn.wagner@example.test', '1992-05-30', '2021-10-10', 'Standard'),
  ('Lina', 'Becker', 'lina.becker@example.test', '2003-01-25', '2024-01-01', 'Student'),

  -- absichtlich ohne Buchung
  ('Ben', 'Hoffmann', 'ben.hoffmann@example.test', '1990-06-18', '2025-01-01', 'Basic'),
  ('Lea', 'Schulz', 'lea.schulz@example.test', '1985-11-11', '2024-07-01', 'Premium'),
  ('Tim', 'Koch', 'tim.koch@example.test', '1970-03-04', '2022-05-12', 'Senior'),
  ('Marie', 'Bauer', 'marie.bauer@example.test', '2002-10-21', '2023-04-15', 'Student');

-- Buchungen
-- Es werden nur einige Mitglieder und nur einige Kurse gebucht
INSERT INTO buchung (m_id, k_id, b_datum, b_status)
VALUES
  (1, 1, '2026-04-20', 'bezahlt'),
  (1, 3, '2026-04-21', 'gebucht'),
  (2, 1, '2026-04-22', 'teilgenommen'),
  (2, 5, '2026-04-23', 'bezahlt'),
  (3, 2, '2026-04-22', 'gebucht'),
  (4, 4, '2026-04-24', 'storniert'),
  (5, 7, '2026-04-25', 'warteliste'),
  (6, 8, '2026-04-25', 'gebucht'),
  (7, 9, '2026-04-26', 'bezahlt'),
  (8, 10, '2026-04-26', 'teilgenommen');
