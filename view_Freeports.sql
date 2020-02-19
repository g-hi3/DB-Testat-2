USE testat;
CREATE OR REPLACE VIEW v_FreePorts
AS SELECT loc.Location_Name, dev.hostname, por.portNumber, net.speed, net.duplextype FROM testat.device as dev
INNER JOIN testat.ports as por ON dev.device_id = por.device_Id AND por.IsUsed = false
INNER JOIN testat.networkinterface as net ON net.networkinterface_id = por.port_netint
INNER JOIN  testat.location as loc ON loc.location_id = net.locationid;




