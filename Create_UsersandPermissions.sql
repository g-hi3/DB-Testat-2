use testat;
DROP USER IF EXISTS 'Geschaeftsfueher'@'localhost';
DROP USER IF EXISTS 'Abteilungsleiter'@'localhost';
DROP USER IF EXISTS 'Sachbearbeiter'@'localhost';
DROP USER IF EXISTS 'Logger'@'localhost';
DROP USER IF EXISTS 'Monitoring'@'localhost';

# Erstellung DB User
CREATE USER IF NOT EXISTS 'Geschaeftsfueher'@'localhost' IDENTIFIED BY 'secret';
CREATE USER IF NOT EXISTS 'Abteilungsleiter'@'localhost' IDENTIFIED BY 'secret';
CREATE USER IF NOT EXISTS 'Sachbearbeiter'@'localhost' IDENTIFIED BY 'secret';
CREATE USER IF NOT EXISTS 'Logger'@'localhost' IDENTIFIED BY 'secret';
CREATE USER IF NOT EXISTS 'Monitoring'@'localhost' IDENTIFIED BY 'secret';

# Berechtigungen

# Geschäftsführer
GRANT ALL PRIVILEGES ON testat.* TO 'Geschaeftsfueher'@'localhost';
# Abteilungsleiter
GRANT INSERT, SELECT, UPDATE ON testat.* TO 'Abteilungsleiter'@'localhost';
#Sachbearbeiter
GRANT INSERT, SELECT, UPDATE ON testat.abrechnung TO 'Sachbearbeiter'@'localhost';
GRANT INSERT, SELECT, UPDATE ON testat.abrechnungsposition TO 'Sachbearbeiter'@'localhost';
GRANT INSERT, SELECT, UPDATE ON testat.adresse TO 'Sachbearbeiter'@'localhost';
GRANT INSERT, SELECT, UPDATE ON testat.credentials TO 'Sachbearbeiter'@'localhost';
GRANT INSERT, SELECT, UPDATE ON testat.device TO 'Sachbearbeiter'@'localhost';
GRANT INSERT, SELECT, UPDATE ON testat.devicecategory TO 'Sachbearbeiter'@'localhost';
GRANT INSERT, SELECT, UPDATE ON testat.kontaktperson TO 'Sachbearbeiter'@'localhost';
GRANT INSERT, SELECT, UPDATE ON testat.kunde TO 'Sachbearbeiter'@'localhost';
GRANT INSERT, SELECT, UPDATE ON testat.location TO 'Sachbearbeiter'@'localhost';
GRANT INSERT, SELECT, UPDATE ON testat.networkinterface TO 'Sachbearbeiter'@'localhost';
GRANT INSERT, SELECT, UPDATE ON testat.ports TO 'Sachbearbeiter'@'localhost';
# Logger
GRANT INSERT On testat.logmessage TO 'Logger'@'localhost';
GRANT INSERT On testat.acknowledged TO 'Logger'@'localhost';
# Monitor
GRANT SELECT ON testat.logmessage TO 'Monitoring'@'localhost';
GRANT UPDATE ON testat.acknowledged TO 'Monitoring'@'localhost';
 
