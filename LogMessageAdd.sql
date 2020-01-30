USE testat;
DROP PROCEDURE IF EXISTS LogMessageAdd;

DELIMITER //
CREATE PROCEDURE LogMessageAdd(log_message, log_level, pod_id, device_host_name)
BEGIN
  
  INSERT INTO logmessage (
    timestamp,
    severity,
    message,
    device
  ) VALUES (
    NOW(),
    log_level,
    log_message,
    (SELECT device_id FROM device WHERE device_adresse = (
        SELECT pod_adresse FROM point_of_delivery WHERE point_of_delivery_id = pod_id))
  )
END //
DELIMITER ;