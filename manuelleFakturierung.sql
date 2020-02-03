use testat;
DELIMITER $$
CREATE PROCEDURE PodBill
(
	IN PodId INT
)
BEGIN	
    DECLARE abrechpod INT;
    DECLARE kundId INT;
    DECLARE bruttopreisvar DECIMAL(10,2);
    DECLARE guthabenvar DECIMAL(10,2);
    DECLARE nettopreisvar DECIMAL(10,2);    
    
    SELECT  pod_kunde INTO  kundId FROM point_of_delivery WHERE point_of_delivery_id = PodId; 
    SELECT Sum(stueckpreis * menge) INTO bruttopreisvar FROM abrechnungsposition WHERE pointofDelivery = PodId AND isfakturiert = false; 						
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
	INSERT INTO abrechnung (abrechnung_pod, bruttopreis,usedguthaben,nettopreis) VALUES ( PodId,bruttopreisvar, guthabenvar,nettopreisvar);
    UPDATE abrechnungsposition
    SET isFakturiert = true
    WHERE pointofDelivery = PodId;
    END IF;
END$$
DELIMITER ;