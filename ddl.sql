DROP SCHEMA IF EXISTS testat;
CREATE DATABASE IF NOT EXISTS testat
  DEFAULT CHARACTER SET utf8;
USE testat;

CREATE TABLE IF NOT EXISTS kunde
(
  kunde_id INT UNSIGNED AUTO_INCREMENT,
  konto_nr VARCHAR(12) NOT NULL DEFAULT " " ,
  bezeichnung VARCHAR(45) NOT NULL DEFAULT " " ,
  guthaben DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  betragslimit DECIMAL(10,2),
  PRIMARY KEY (kunde_id)
);
CREATE TABLE IF NOT EXISTS adresse
(
  adresse_id INT UNSIGNED AUTO_INCREMENT,
  land VARCHAR(45) NOT NULL DEFAULT " ",
  ort VARCHAR(45) NOT NULL DEFAULT " ",
  zip_code VARCHAR(45) NOT NULL DEFAULT " ",
  strasse VARCHAR(45) NOT NULL DEFAULT " ",
  hausnummer varchar(10) NOT NULL,
  PRIMARY KEY (adresse_id)
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
CREATE TABLE IF NOT EXISTS location(
	location_id INT AUTO_INCREMENT,
    Location_Name VARCHAR(100) NOT NULL,
    PRIMARY KEY (location_id)
);
CREATE TABLE IF NOT EXISTS networkinterface
(
  networkinterface_id INT UNSIGNED AUTO_INCREMENT,
  duplextype VARCHAR(45) NOT NULL DEFAULT " ",
  speed VARCHAR(45) NOT NULL DEFAULT " ",
  pointofdelivery INT UNSIGNED,
  locationid INT NOT NULL,
  PRIMARY KEY (networkinterface_id),
  FOREIGN KEY(pointofdelivery) REFERENCES point_of_delivery(point_of_delivery_id),
  FOREIGN KEY(locationid) REFERENCES location(location_id)
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
CREATE TABLE IF NOT EXISTS devicecategory
(
	categoryId INT auto_increment NOT NULL,
    CategoryName VARCHAR(100) NOT NULL,
    primary key (categoryId)
);
CREATE TABLE IF NOT EXISTS device
(
  device_id INT UNSIGNED AUTO_INCREMENT,
  devicecategory INT NOT NULL,
  hostname VARCHAR(45) NOT NULL DEFAULT " ",
  ip_adresse VARCHAR(45) NOT NULL DEFAULT " ",
  anzahlports int not null DEFAULT 1,
  device_adresse INT UNSIGNED,
  device_netint INT UNSIGNED,
  PRIMARY KEY (device_id),
  FOREIGN KEY (device_adresse) REFERENCES adresse(adresse_id),
  FOREIGN KEY (device_netint) REFERENCES networkinterface(networkinterface_id),
  FOREIGN KEY (devicecategory) REFERENCES devicecategory(categoryId)
);
CREATE TABLE IF NOT EXISTS ports(
	ports_id INT UNSIGNED AUTO_INCREMENT,
    device_Id INT UNSIGNED NOT NULL,
    portNumber INT NOT NULL,
    isUsed BOOL NOT NULL default false,
    port_netint INT UNSIGNED NOT NULL,
    PRIMARY KEY(ports_id),
    FOREIGN KEY (port_netint) REFERENCES networkinterface(networkinterface_id),
    FOREIGN KEY (device_Id) REFERENCES device(device_id)
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
  bruttopreis DECIMAL(10,2) NOT NULL,
  usedguthaben DECIMAL(10,2) NULL,
  nettopreis DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (abrechnung_id),
  FOREIGN KEY (abrechnung_pod) REFERENCES point_of_delivery(point_of_delivery_id)  
);
CREATE TABLE IF NOT EXISTS abrechnungsposition
(
  abrechnungspos_id INT UNSIGNED AUTO_INCREMENT,
  produktbeschreibung VARCHAR(45) NOT NULL DEFAULT " ",
  stueckpreis DECIMAL(10,2) NOT NULL,
  menge INT NOT NULL DEFAULT 0,
  pointofDelivery INT UNSIGNED,
  isfakturiert BOOL DEFAULT false,
  buchungsdatum DATETIME NOT NULL,
  PRIMARY KEY (abrechnungspos_id),
  FOREIGN KEY(pointofDelivery) REFERENCES point_of_delivery(point_of_delivery_id)
);
CREATE TABLE IF NOT EXISTS acknowledged
(
  acknowledged_id int unsigned,
  is_acknowledged bool,
  foreign key (acknowledged_id) references logmessage(logmessage_id),
  primary key (acknowledged_id)
);