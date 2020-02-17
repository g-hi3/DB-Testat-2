USE testat;

CREATE TABLE acknowledged(
  acknowledged_id int unsigned,
  is_acknowledged bool,
  foreign key (acknowledged_id) references logmessage(logmessage_id),
  primary key (acknowledged_id)
);

CREATE OR REPLACE VIEW v_logentries AS SELECT
    logmessage_id as id,
    (SELECT point_of_delivery_id FROM point_of_delivery WHERE pod_adresse = (
        SELECT device_adresse FROM device WHERE device_id = device)) AS pod,
    (SELECT CONCAT(ort, CONCAT(' ', CONCAT(strasse, CONCAT(' ', hausnummer)))) FROM adresse WHERE adresse_id = (
        SELECT device_adresse FROM device WHERE device_id = device)) AS location,
    (SELECT hostname FROM device WHERE device_id = device) AS hostname,
    (CASE
      WHEN severity = 'ERROR' THEN 10
      WHEN severity = 'WARN' THEN 20
      WHEN severity = 'INFO' THEN 30
      WHEN severity = 'DEBUG' THEN 80
      WHEN severity = 'TRACE' THEN 90
      ELSE 'UNDEF' END) AS severity,
    timestamp,
    message
  FROM logmessage
  LEFT JOIN acknowledged ON logmessage.logmessage_id = acknowledged.acknowledged_id
  WHERE acknowledged.is_acknowledged is null
    or acknowledged.is_acknowledged = false;