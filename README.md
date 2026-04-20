# PostgreSQL Kursdatenbank mit Docker

Dieses kleine Setup startet eine PostgreSQL-Datenbank in einem Container und legt automatisch vier Tabellen an:

- `mitglied`
- `buchung`
- `kurs`
- `trainer`

Beim ersten Start werden mindestens 5 Trainer, 20 Kurse, 200 Mitglieder und mehrere hundert Buchungen erzeugt. Die Daten sind reine Testdaten zum Ueben von SQL-Befehlen.

## In GitHub Codespaces starten

1. Repository oder Ordner in Codespaces oeffnen.
2. In diesen Projektordner wechseln:

```bash
cd postgres-kursdatenbank
```

3. Container starten:

```bash
docker compose up -d
```

4. Pruefen, ob PostgreSQL laeuft:

```bash
docker compose ps
```

5. Mit der Datenbank verbinden:

```bash
docker compose exec postgres psql -U kursuser -d kursdatenbank
```

## Nuetzliche SQL-Befehle in psql

Alle Tabellen anzeigen:

```sql
\dt
```

Tabellenstruktur anzeigen:

```sql
\d mitglied
\d buchung
\d kurs
\d trainer
```

Datensaetze zaehlen:

```sql
SELECT COUNT(*) FROM trainer;
SELECT COUNT(*) FROM kurs;
SELECT COUNT(*) FROM mitglied;
SELECT COUNT(*) FROM buchung;
```

Beispielabfrage mit JOIN:

```sql
SELECT
  m.m_vorname,
  m.m_nachname,
  k.k_name,
  b.b_datum,
  b.b_status,
  t.t_vorname AS trainer_vorname,
  t.t_nachname AS trainer_nachname
FROM buchung b
JOIN mitglied m ON m.m_id = b.m_id
JOIN kurs k ON k.k_id = b.k_id
JOIN trainer t ON t.t_id = k.t_id
ORDER BY b.b_datum DESC
LIMIT 20;
```

psql verlassen:

```sql
\q
```

## Datenbank komplett neu erzeugen

Wenn du die Tabellen und Testdaten neu erzeugen willst, entferne zuerst das Docker-Volume und starte danach neu:

```bash
docker compose down -v
docker compose up -d
```

## Verbindungsdaten

- Host in Codespaces/Container: `localhost`
- Port: `5432`
- Datenbank: `kursdatenbank`
- Benutzer: `kursuser`
- Passwort: `kurspass`

Connection String:

```text
postgresql://kursuser:kurspass@localhost:5432/kursdatenbank
```
