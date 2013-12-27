csvToD83
========

Command line tool zum konvertieren von Leistungsverzeichnissen im CSV-Format zum D83 Dateiformat.

## Struktur der CSV-Datei

Um konvertiert werden zu können muss die CSV-Datei einen bestimmten Aufbau haben. Sie können ihre Tabellen einfach aus z.B. Numbers oder einem anderem Tabellenkalkulationsprogramm im CSV Format exportieren.

### Allgemein

Die Datei muss aus fünf Spalten bestehen.

Ordnungszahl | Text | Menge | Einheit | Art
---          |
...          | ...  | ...   | ...     | ...

Lehrzeilen werden ignoriert.

### LV-Gruppen

Ordnungszahl | Text | Menge | Einheit | Art
---          |
1.           | Bezeichnung der LV-Gruppe |

__Ordnungszahl:__ Muss mit Punkt enden

Menge, Einheit und Art sind lehr.

### Teilleistungen

Ordnungszahl | Text | Menge | Einheit | Art
---          |
1.1          | Kurztext | 2.75 | m2 | BG
             | Langtext
             | weitere Zeile des Langtextes

* __Ordnungszahl:__ Muss mit Zahl enden
* __Text__ in Zeile mit Ordnungszahl: Kurztext, max 70 Stellen
* __Menge:__ Zahl, mit oder ohne Komma
* __Einheit:__ Max 4 Stellen, _Stundenlohnarbeiten_ die in "h" gemessen werden, werden automatisch als solche erkannt. "psch" für Pauschalleistungen.
* __Text__ alle Zeilen bis zum Beginn der nächsten Teilleistung/LV-Gruppe: Langtext der Teilleistung, eine Zeile sollte nicht mehr als 55 Stellen habe.
* __Art:__
	* kein Inhalt: Normalposition
	* BG: Bedarfsposition mit Gesamtbetrag
	* BE: Bedarfsposition ohne Gesamtbetrag






