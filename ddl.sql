CREATE DATABASE IF NOT EXISTS testat
  DEFAULT CHARACTER SET utf8;

USE testat;

CREATE TABLE IF NOT EXISTS kunde
(
  kunde_id INT UNSIGNED AUTO_INCREMENT,
  konto_nr VARCHAR(12) NOT NULL DEFAULT " " ,
  bezeichnung VARCHAR(45) NOT NULL DEFAULT " " ,
  PRIMARY KEY (kunde_id)
);

CREATE TABLE IF NOT EXISTS adresse
(
  adresse_id INT UNSIGNED AUTO_INCREMENT,
  land VARCHAR(45) NOT NULL DEFAULT " ",
  ort VARCHAR(45) NOT NULL DEFAULT " ",
  zip_code VARCHAR(45) NOT NULL DEFAULT " ",
  strasse VARCHAR(45) NOT NULL DEFAULT " ",
  hausnummer INT NOT NULL DEFAULT 0,
  PRIMARY KEY (adresse_id)
);

CREATE TABLE IF NOT EXISTS networkinterface
(
  networkinterface_id INT UNSIGNED AUTO_INCREMENT,
  duplextype VARCHAR(45) NOT NULL DEFAULT " ",
  speed VARCHAR(45) NOT NULL DEFAULT " ",
  PRIMARY KEY (networkinterface_id)
);

CREATE TABLE IF NOT EXISTS point_of_delivery
(
  point_of_delivery_id INT UNSIGNED AUTO_INCREMENT,
  bezeichnung VARCHAR(45) NOT NULL DEFAULT " ",
  pod_kunde INT UNSIGNED,
  pod_adresse INT UNSIGNED,
  PRIMARY KEY (point_of_delivery_id),
  FOREIGN KEY (pod_kunde) REFERENCES kunde(kunde_id),
  FOREIGN KEY (pod_adresse) REFERENCES adresse(adresse_id)
);

CREATE TABLE IF NOT EXISTS kontaktperson
(
  kontaktperson_id INT UNSIGNED AUTO_INCREMENT,
  Kundenname  VARCHAR(45) NOT NULL DEFAULT " ",
  priorität TINYINT NOT NULL DEFAULT 0,
  pointofdelivery INT UNSIGNED,
  PRIMARY KEY (kontaktperson_id),
  FOREIGN KEY (pointofdelivery) REFERENCES point_of_delivery(point_of_delivery_id)
);

CREATE TABLE IF NOT EXISTS device
(
  device_id INT UNSIGNED AUTO_INCREMENT,
  hostname VARCHAR(45) NOT NULL DEFAULT " ",
  ip_adresse VARCHAR(45) NOT NULL DEFAULT " ",
  device_adresse INT UNSIGNED,
  device_netint INT UNSIGNED,
  PRIMARY KEY (device_id),
  FOREIGN KEY (device_adresse) REFERENCES adresse(adresse_id),
  FOREIGN KEY (device_netint) REFERENCES networkinterface(networkinterface_id)
);

CREATE TABLE IF NOT EXISTS logmessage
(
  logmessage_id INT UNSIGNED AUTO_INCREMENT,
  timestamp TIMESTAMP,
  severity VARCHAR(45) NOT NULL DEFAULT " ",
  message VARCHAR(45) NOT NULL DEFAULT " ",
  Device INT UNSIGNED,
  PRIMARY KEY (logmessage_id),
  FOREIGN KEY (Device) REFERENCES device(device_id)
);

CREATE TABLE IF NOT EXISTS credentials
(
  credentials_id INT UNSIGNED AUTO_INCREMENT,
  benutzername VARCHAR(45) NOT NULL DEFAULT " ",
  passwort VARCHAR(45) NOT NULL DEFAULT " ",
  snmp_community VARCHAR(45),
  Device INT UNSIGNED,
  PRIMARY KEY (credentials_id),
  FOREIGN KEY (Device) REFERENCES device(device_id)
);

CREATE TABLE IF NOT EXISTS abrechnung
(
  abrechnung_id INT UNSIGNED AUTO_INCREMENT,
  abrechnung_pod INT UNSIGNED,
  abrechnung_adresse INT UNSIGNED,
  abrechnung_netint INT UNSIGNED,
  PRIMARY KEY (abrechnung_id),
  FOREIGN KEY (abrechnung_pod) REFERENCES point_of_delivery(point_of_delivery_id),
  FOREIGN KEY (abrechnung_adresse) REFERENCES adresse(adresse_id),
  FOREIGN KEY (abrechnung_netint) REFERENCES networkinterface(networkinterface_id)
);

CREATE TABLE IF NOT EXISTS abrechnungsposition
(
  abrechnungspos_id INT UNSIGNED AUTO_INCREMENT,
  produktbeschreibung VARCHAR(45) NOT NULL DEFAULT " ",
  stueckpreis DECIMAL NOT NULL,
  menge INT NOT NULL DEFAULT 0,
  abrechnung INT UNSIGNED,
  PRIMARY KEY (abrechnungspos_id),
  FOREIGN KEY (abrechnung) REFERENCES abrechnung(abrechnung_id)
);

