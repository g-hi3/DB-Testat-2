use testat;

INSERT INTO kunde
(konto_nr, bezeichnung)
VALUES
("01-12345-1", "Treuhand AG" );

INSERT INTO adresse
(land, ort, zip_code, strasse, hausnummer)
VALUES
("Schweiz", "Gossau", "9200", "Hauptstrasse", 5);

INSERT INTO networkinterface
(duplextype, speed)
VALUES
("Full-Duplex",  "1000");

INSERT INTO networkinterface
(duplextype, speed)
VALUES
("Half-Duplex",  "100");

INSERT INTO point_of_delivery
(bezeichnung, pod_kunde, pod_adresse)
VALUES
("Muster Treuhand AG", 1 , 1);

INSERT INTO kontaktperson
(kundenname, priorität, pointofdelivery)
VALUES
("Max Muster", 5, 1);

INSERT INTO device
(hostname, ip_adresse, device_adresse, device_netint)
VALUES
("www.example.com", "123.123.123.123", 1, 1);

INSERT INTO logmessage
(`timestamp`, severity, message, device )
VALUES
(current_timestamp(), "Info", "Device is Connected", 1);

INSERT INTO credentials
(benutzername, passwort, snmp_community, device)
VALUES
("MusterUser", "MusterPassword", "public", 1);

INSERT INTO abrechnung
(abrechnung_pod, abrechnung_adresse, abrechnung_netint)
VALUES
(1, 1, 2);

INSERT INTO abrechnungsposition
(produktbeschreibung, stueckpreis, menge, abrechnung)
VALUES
("Netzwerkinstallation XY", 1, 1, 1);


