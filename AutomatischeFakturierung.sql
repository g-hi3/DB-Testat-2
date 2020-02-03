DELIMITER $$
CREATE PROCEDURE PodBillEvent()
BEGIN
	DECLARE varbez VARCHAR(45);
    DECLARE varpodId INT;
    DECLARE olderpos INT;
    DECLARE varBezsec VARCHAR(45);
    DECLARE varsumme DECIMAL(10,2);
    DECLARE varlimit DECIMAL(10,2);
	DECLARE done INT DEFAULT FALSE;
    DECLARE cursor_abraut CURSOR FOR SELECT point_of_delivery_id FROM point_of_delivery WHERE point_of_delivery_id IN (SELECT pointofDelivery FROM abrechnungsposition WHERE isfakturiert = false); 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cursor_abraut;
    loop_beg:LOOP
		FETCH NEXT FROM cursor_abraut INTO varpodId;
		IF done THEN
			LEAVE loop_beg;
            END IF;
		SELECT COUNT(*) INTO olderpos FROM abrechnungsposition WHERE  (MONTH(GETDATE()) - MONTH(buchungsdatum)) > 3 AND isfakturiert = false;
        SELECT SUM(menge * stueckpreis) INTO varsumme FROM abrechnungsposition WHERE pointofDelivery = varpodId AND isfakturiert = false;
        SELECT betragslimit INTO varlimit FROM kunde WHERE kunde_id = (SELECT pod_kunde FROM point_of_delivery WHERE point_of_delivery_id = varpodId);
        IF olderpos > 0 OR varsumme > varlimit OR (DAYOFMONTH(CURDATE()) = 28 AND varsumme > 1000) THEN
             CALL PodBill(varpodId);
		END IF;        
    END LOOP;
    CLOSE cursor_abraut;
    END$$
DELIMITER ;

CREATE EVENT IF NOT EXISTS autofakt_event  ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP 
	DO
		CALL PodBillEvent();