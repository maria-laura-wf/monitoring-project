#!/bin/bash

while true; do
  wget -q -O- http://localhost:8080 > /dev/null
  sleep 1
done