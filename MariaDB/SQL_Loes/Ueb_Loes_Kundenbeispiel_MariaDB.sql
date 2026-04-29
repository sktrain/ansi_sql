CREATE DATABASE Kunden;

USE Kunden;

CREATE TABLE kunde (
	kundennummer CHAR(4) PRIMARY KEY,	
	kundenname	VARCHAR(30) NOT NULL,
	-- regulärer Ausdruck: Nummer besteht aus genau vier Ziffern
	CONSTRAINT knummer_check CHECK (kundennummer REGEXP '^[[:digit:]]{4}$'),
	-- regulärer Ausdruck: Name besteht nur aus (mindestens 2) Buchstaben, der erste groß, Rest klein
	CONSTRAINT kname_check CHECK (kundenname REGEXP '^[[:upper:]][[:lower:]]{1,}$')
);


CREATE TABLE bank (
	bankleitzahl INTEGER UNSIGNED PRIMARY KEY,
	bankname VARCHAR(30) NOT NULL,  -- ohne weitere Constraints
	bankort VARCHAR(50),		-- Nullable
	CONSTRAINT blz_check CHECK (bankleitzahl BETWEEN 10000000 AND 99999999)
);


CREATE TABLE bankverbindung (
	id_nr BIGINT AUTO_INCREMENT PRIMARY KEY,
	kundennummer CHAR(4),
	bankleitzahl INTEGER UNSIGNED,
	kontonummer	INTEGER UNSIGNED,
	CONSTRAINT fk_kunde FOREIGN KEY (kundennummer) REFERENCES kunde(kundennummer)
			ON DELETE CASCADE,
	CONSTRAINT fk_bank FOREIGN KEY (bankleitzahl) REFERENCES bank(bankleitzahl)
);
	


INSERT INTO kunde
	VALUES	('0019', 'Huber'),
				('0022', 'Maier'),
				('0033', 'Kaiser'),
				('0037', 'Rein'),
				('5555', 'Karrer');
				
				
INSERT INTO bank
	VALUES	(64240071, 'Commerzbank', 'Rottweil'),
				(66069617, 'Raiffeissenbank', 'Schwenningen'),
				(69470039, 'BW-Bank', 'Villingen'),
				(69470040, 'Deutsche Bank', 'Villingen-Schwenningen');

				
INSERT INTO bank
	VALUES	(64450288, 'Magic Bank', 'Magic Ort');

				
INSERT INTO bankverbindung(kundennummer, bankleitzahl, kontonummer)
	VALUES	('0019', 64240071, 3418505),
				('0019', 64450288, 5655742),
				('0022', 66069617, 85664785),
				('0033', 69470039, 657885547),
				('0037', 64450288, 5688714),
				('5555', 69470039, 100345);
				
		
