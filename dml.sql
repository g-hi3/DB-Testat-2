use testat;

INSERT INTO kunde
(konto_nr, bezeichnung, guthaben, betragslimit)
VALUES
("01-12345-1", "Treuhand AG", 100.00,900.00 );

INSERT INTO adresse
(land, ort, zip_code, strasse, hausnummer)
VALUES
("Schweiz", "Gossau", "9200", "Hauptstrasse", 5);


INSERT INTO point_of_delivery
(bezeichnung, pod_kunde, pod_adresse)
VALUES
("Muster Treuhand AG", 1 , 1);
INSERT INTO location
(Location_name)
VALUES
('AtHome'),('AtWork');
INSERT INTO networkinterface
(duplextype, speed, pointofdelivery, locationid)
VALUES
("Full-Duplex",  "1000", 1,1),("Half-Duplex", "100",1,2);

INSERT INTO kontaktperson
(kundenname, priorität, pointofdelivery)
VALUES
("Max Muster", 5, 1);
INSERT INTO devicecategory
(CategoryName)
VALUES
('Switch'),('PC');
INSERT INTO device
(hostname, ip_adresse, device_adresse, anzahlports,devicecategory)
VALUES
("www.example.com", "123.123.123.123", 1,24,1);

INSERT INTO ports
(portNumber,device_Id, port_netint,isUsed)
VALUES
(1,1,1,true),(2,1,1,false);

INSERT INTO logmessage
(`timestamp`, severity, message, device )
VALUES
(current_timestamp(), "Info", "Device is Connected", 1);

INSERT INTO credentials
(benutzername, passwort, snmp_community, device)
VALUES
("MusterUser", "MusterPassword", "public", 1);


INSERT INTO abrechnungsposition
(produktbeschreibung, stueckpreis, menge, pointofDelivery, isfakturiert, buchungsdatum )
VALUES
("Netzwerkinstallation XY", 15.00, 3, 1,false,'03.03.2020'), ("Modem", 490.00, 1, 1,false,'03.03.2020');

