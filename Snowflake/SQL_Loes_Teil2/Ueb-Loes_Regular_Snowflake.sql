-- Übungen zu regulären Ausdrücken

/* -------------- Vorab ----------------
Snowflake-Besonderheit bei REGEXP_LIKE: 
Die Funktion verankert implizit ein Muster an beiden Enden 
(d. h. '' wird automatisch zu '^$' und 'ABC' automatisch zu '^ABC$'). 
Um beispielsweise eine beliebige Zeichenfolge, die mit ABC beginnt, 
abzugleichen, wäre das Muster 'ABC.*' erforderlich.
*/

/* Aufgabe 1  Erstellen Sie eine Abfrage, um alle Mitarbeiter zu suchen, 
deren Vorname mit "Ne" oder "Na" beginnt. Zeigen Sie die Namen an.*/
 
SELECT first_name, last_name
  FROM employees
  WHERE REGEXP_LIKE (first_name, '^N(e|a).*');
  

  
/* Aufgabe 2 Zeigen Sie alle Mitarbeiter an, bei denen die Telefonnummer 
genau 3 Punkte (.) enthält. */
  
SELECT last_name, phone_number
  FROM employees
  WHERE REGEXP_LIKE (phone_number, '^.*\..*\..*\..*$');  

  
  
/* Aufgabe 3 Zeigen Sie alle Mitarbeiter an, bei denen die Telefonnummer 
eine 2-stellige Ziffernfolge enthält, die von Nichtziffern umrahmt wird. */

SELECT last_name, phone_number
  FROM employees
  WHERE REGEXP_LIKE (phone_number,'.*[^0-9][0-9][0-9][^0-9].*');
  
-- oder alternativ

SELECT last_name, phone_number
  FROM employees
  WHERE REGEXP_LIKE (phone_number,'.*\\D\\d{2}\\D.*');


-- oder alternativ

SELECT last_name, phone_number
  FROM employees
  WHERE REGEXP_LIKE (phone_number,'.*[^0-9][0-9]{2}[^0-9].*');




/* Aufgabe 4 Erstellen Sie eine Abfrage, die bei der Anzeige der Strassen 
(Spalte STREET_ADDRESS) aus der Tabelle LOCATIONS das Kürzel 'St' durch 
'Street' ersetzt. Achten Sie darauf, dass keine Zeilen betroffen sind, die 
'Street' bereits enthalten, wobei Sie sich darauf stützen können, dass das 
Kürzel 'St' stets am Ende steht. */

SELECT regexp_replace(street_address, 'St$', 'Street')
  FROM locations
  WHERE regexp_like(street_address, '.*St');




-- wird bei Snowflake nicht unterstützt, 
-- da Rückverweise nur bei der REGEXP_REPLACE unterstützt werden!!

/* Aufgabe 5  Suchen Sie bei den Vornamen der Mitarbeiter nach Palindromen der 
Länge 4 (Palindrome sind Zeichenketten, die vorwärts und rückwärts gelesen 
gleich sind, z.B. 'otto'. (sportliche Aufgabe)  */

INSERT INTO HR.employees VALUES 
        ( 99
        , 'otto'
        , 'Karrer'
        , 'ISCIARRA'
        , '515.124.4369'
        , TO_DATE('30-09-2005', 'dd-MM-yyyy')
        , 'FI_ACCOUNT'
        , 7700
        , NULL
        , 108
        , 100
        );

SELECT * FROM employees WHERE last_name = 'Karrer';

SELECT last_name, first_name
  FROM employees
  WHERE REGEXP_LIKE (first_name,'^(.)(.)\2\1$');