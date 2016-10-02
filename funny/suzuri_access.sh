#!/bin/bash
curl -n -X GET -H "Authorization: Bearer 3df61022350585b2e5a2890ef9cdd2201ef5897c50f655cd618fe90b8bac3c76" https://suzuri.jp/api/v1/activities \
-G \
 -d limit=30
#curl -n -X GET -H "Authorization: Bearer 3df61022350585b2e5a2890ef9cdd2201ef5897c50f655cd618fe90b8bac3c76" https://suzuri.jp/api/v1/items
#-H "Authorization: Bearer 3df61022350585b2e5a2890ef9cdd2201ef5897c50f655cd618fe90b8bac3c76"\
#curl -n -X GET https://suzuri.jp/api/v1/schema

