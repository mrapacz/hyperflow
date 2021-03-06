#!/bin/sh

if [ "$#" -ne 1 ]; then
  echo "restapi_test.sh: creates an instance of the Ping Pong workflow"
  echo "     and sends a signal to it using the HyperFlow REST API."
  echo
  echo "Usage:"
  echo "- first run the HyperFlow server:     node app.js"
  echo "- then run this script:               scripts/restapi_test.sh <port>"
  echo "where <port> is the port number on which the server is running"
  exit
fi


uri="http://localhost:$1/apps"

# 1) POST {host}/apps - creates a workflow instance
# Body: valid workflow description in JSON
# on success returns: 201, Location: {appuri}
# "location" - wf instance URI extracted from the HTTP header 
location=`curl -v -X POST -d @workflows/Montage_143.json $uri --header "Content-Type:application/json" 2>&1 | grep Location | cut -f 3 -d' '`

appuri="http://localhost:$1"$location
echo $appuri

# 2) POST {appuri} - sends a signal to a workflow
# Body: valid signal data (JSON with mandatory "name")
# curl -X POST -d '{ "name": "counter1", "data": [0] }' $appuri --header "Content-Type:application/json"
