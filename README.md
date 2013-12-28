csvToD83
========

Command line tool zum konvertieren von Leistungsverzeichnissen im CSV-Format zum D83 Dateiformat.

Alle gängigen Tabellenkalkulationsprogramme unterstützen das exportieren von Tabellen im CSV-Format, die CSV-Datei muss Semikolon ";" als Trenner verwenden (kann in `CHCSVParser.m` Zeile 31 verändert werden).

## Struktur der CSV-Datei

Um konvertiert werden zu können muss die CSV-Datei einen bestimmten Aufbau haben.

Des weiteren sollten Sie Umlaute und sämmtliche andere Zeichen die nicht [ASCII](http://de.wikipedia.org/wiki/American_Standard_Code_for_Information_Interchange)-Zeichensatz enthalten sind vermeiden, da diese beim Speichern im D83-Format umgewandelt werden müssen.

### Allgemein

Die Datei muss aus fünf Spalten bestehen.

Ordnungszahl | Text | Menge | Einheit | Art
---          | ---  | ---   | ---     | ---
...          | ...  | ...   | ...     | ...

Lehrzeilen werden ignoriert.

### LV-Gruppen

Ordnungszahl | Text | Menge | Einheit | Art
---          | ---  | ---   | ---     | ---
1.           | Bezeichnung der LV-Gruppe |

__Ordnungszahl:__ Muss mit Punkt enden

Menge, Einheit und Art sind lehr.

### Teilleistungen

Ordnungszahl | Text | Menge | Einheit | Art
---          | ---  | ---   | ---     | ---
1.1          | Kurztext | 2.75 | m2   | BG
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
	
## Quellen

Bei der Implementierung des D83-Formats wurde auf die [Regelungen für den Datenaustausch Leistungsverzeichnis](http://www.gaeb.de/download/da1990.pdf) (2., geänderte Auflage) von Juni 1990 zurückgegriffen.






