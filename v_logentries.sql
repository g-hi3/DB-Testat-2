USE testat;

CREATE OR REPLACE VIEW v_logentries(
  id INT,
  pod VARCHAR(45),
  location VARCHAR(101),
  hostname VARCHAR(45),
  severity INT,
  timestamp TIMESTAMP,
  message VARCHAR(45)
) AS SELECT
    logmessage_id,
    (SELECT point_of_delivery_id FROM point_of_delivery WHERE pod_adresse = (
        SELECT device_adresse FROM device WHERE device_id = device)),
    (SELECT CONCAT(ort, CONCAT(' ', CONCAT(strasse, CONCAT(' ', hausnummer)))) FROM adresse WHERE adresse_id = (
        SELECT device_adresse FROM device WHERE device_id = device)),
    (SELECT hostname FROM device WHERE device_id = device),
    (CASE
      WHEN severity = 'ERROR' THEN 10
      WHEN severity = 'WARN' THEN 20
      WHEN severity = 'INFO' THEN 30
      WHEN severity = 'DEBUG' THEN 80
      WHEN severity = TRACE THEN 90),
    timestamp,
    message
  FROM logmessage;