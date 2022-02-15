ONOS_PASSWORD=karaf
ONOS_USER=karaf
ONOS_IP=127.0.0.1
ONOS_PORT=8181

curl -X POST -u ${ONOS_USER}:${ONOS_PASSWORD} -H "Content-Type: application/json" -d @forward-switch1-host1.json http://${ONOS_IP}:${ONOS_PORT}/onos/v1/flowobjectives/device:switch1/forward?appId=org.onosproject.rest
curl -X POST -u ${ONOS_USER}:${ONOS_PASSWORD} -H "Content-Type: application/json" -d @forward-switch1-host2.json http://${ONOS_IP}:${ONOS_PORT}/onos/v1/flowobjectives/device:switch1/forward?appId=org.onosproject.rest
curl -X POST -u ${ONOS_USER}:${ONOS_PASSWORD} -H "Content-Type: application/json" -d @next-switch1-host1.json http://${ONOS_IP}:${ONOS_PORT}/onos/v1/flowobjectives/device:switch1/next?appId=org.onosproject.rest
curl -X POST -u ${ONOS_USER}:${ONOS_PASSWORD} -H "Content-Type: application/json" -d @next-switch1-host2.json http://${ONOS_IP}:${ONOS_PORT}/onos/v1/flowobjectives/device:switch1/next?appId=org.onosproject.rest
curl -X POST -u ${ONOS_USER}:${ONOS_PASSWORD} -H "Content-Type: application/json" -d @forward-switch2-host1.json http://${ONOS_IP}:${ONOS_PORT}/onos/v1/flowobjectives/device:switch2/forward?appId=org.onosproject.rest
curl -X POST -u ${ONOS_USER}:${ONOS_PASSWORD} -H "Content-Type: application/json" -d @forward-switch2-host2.json http://${ONOS_IP}:${ONOS_PORT}/onos/v1/flowobjectives/device:switch2/forward?appId=org.onosproject.rest
curl -X POST -u ${ONOS_USER}:${ONOS_PASSWORD} -H "Content-Type: application/json" -d @next-switch2-host1.json http://${ONOS_IP}:${ONOS_PORT}/onos/v1/flowobjectives/device:switch2/next?appId=org.onosproject.rest
curl -X POST -u ${ONOS_USER}:${ONOS_PASSWORD} -H "Content-Type: application/json" -d @next-switch2-host2.json http://${ONOS_IP}:${ONOS_PORT}/onos/v1/flowobjectives/device:switch2/next?appId=org.onosproject.rest
