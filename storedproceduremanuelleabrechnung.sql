use testat;
DELIMITER $$
CREATE PROCEDURE PodBill
(
	IN PodBezeichnung VARCHAR(45)
)
BEGIN	
    DECLARE abrechpod INT;
    DECLARE kundId INT;
    DECLARE bruttopreisvar DECIMAL(10,2);
    DECLARE guthabenvar DECIMAL(10,2);
    DECLARE nettopreisvar DECIMAL(10,2);    
    
    SELECT point_of_delivery_id, pod_kunde INTO abrechpod, kundId FROM point_of_delivery WHERE bezeichnung = PodBezeichnung; 
    SELECT Sum(stueckpreis * menge) INTO bruttopreisvar FROM abrechnungsposition WHERE pointofDelivery = abrechpod AND isfakturiert = false; 						
	SELECT guthaben INTO guthabenvar FROM kunde WHERE kunde_id = kundId;
    
    IF guthabenvar < bruttopreisvar AND guthabenvar > 0 THEN
		SET nettopreisvar = bruttopreisvar - guthabenvar;
        UPDATE Kunde
        SET guthaben = 0.0
        WHERE kunde_id = kundId;        
	ELSEIF guthabenvar = 0 THEN
		SET nettopreisvar = bruttopreisvar;
	ELSEIF guthabenvar > bruttopreisvar THEN
		SET nettopreisvar = 0;
        SET guthabenvar = guthabenvar - bruttopreisvar;
        update KUNDE
        SET guthaben = guthabenvar
        WHERE pod_kunde = kundId;
	 END IF; 
	IF bruttopreisvar > 0 THEN
	INSERT INTO abrechnung (abrechnung_pod, bruttopreis,usedguthaben,nettopreis) VALUES ( abrechpod,bruttopreisvar, guthabenvar,nettopreisvar);
    UPDATE abrechnungsposition
    SET isFakturiert = true
    WHERE pointofDelivery = abrechpod;
    END IF;
END$$
DELIMITER ;

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
        IF olderpos > 0 THEN
			SELECT bezeichnung INTO varbez FROM point_of_delivery WHERE point_of_delivery_id = varpodId;
            CALL PodBill(varbez);
		END IF;        
		SELECT SUM(menge * stueckpreis) INTO varsumme FROM abrechnungsposition WHERE pointofDelivery = varpodId AND isfakturiert = false;
        SELECT betragslimit INTO varlimit FROM kunde WHERE kunde_id = (SELECT pod_kunde FROM point_of_delivery WHERE point_of_delivery_id = varpodId);        
        IF varsumme > varlimit THEN
			SELECT bezeichnung INTO varbez FROM point_of_delivery WHERE point_of_delivery_id = varpodId;
            CALL PodBill(varbez);
		END IF; 
		IF DAYOFMONTH(CURDATE()) = 28 AND varsumme > 1000 THEN
			SELECT bezeichnung INTO varbez FROM point_of_delivery WHERE point_of_delivery_id = varpodId;
            CALL PodBill(varbez);
		END IF;			
    END LOOP;
    CLOSE cursor_abraut;
    END$$
DELIMITER ;

CREATE EVENT IF NOT EXISTS autofakt_event  ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP 
	DO
		CALL PodBillEvent();