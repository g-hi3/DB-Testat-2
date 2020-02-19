USE testat;

CREATE OR REPLACE VIEW  v_UsagePerLocation 
AS SELECT DISTINCT loc.Location_Name, cat.CategoryName,dev.hostname, dev.ip_adresse, dev.anzahlports AS MaxPorts, (SELECT count(*) FROM ports WHERE IsUsed = true AND device_id = dev.device_id) AS UsedPorts, (SELECT COUNT(*) FROM ports WHERE IsUsed = true AND device_id = dev.device_id) / dev.anzahlports * 100 AS Auslastung 
FROM testat.location AS loc 
INNER JOIN testat.networkinterface as net ON loc.location_id = net.locationid
INNER JOIN testat.ports as por ON net.networkinterface_id = por.port_netint
INNER JOIN testat.device as dev ON por.device_Id = dev.device_id
INNER JOIN testat.devicecategory as cat ON dev.devicecategory = cat.categoryId;

CREATE OR REPLACE VIEW v_UsagePerPod
AS
SELECT DISTINCT pod.bezeichnung,cat.CategoryName ,dev.hostname, dev.ip_adresse, dev.anzahlports AS MaxPorts, (SELECT count(*) FROM ports WHERE IsUsed = true AND device_id = dev.device_id) AS UsedPorts, (SELECT COUNT(*) FROM ports WHERE IsUsed = true AND device_id = dev.device_id) / dev.anzahlports * 100 AS Auslastung  
FROM testat.networkinterface as net
INNER JOIN testat.point_of_delivery as pod ON pod.point_of_delivery_id = net.pointofdelivery
INNER JOIN testat.ports AS por ON por.port_netint = net.networkinterface_id
INNER JOIN testat.device AS dev ON dev.device_id = por.device_Id
INNER JOIN testat.devicecategory as cat ON dev.devicecategory = cat.categoryId;

