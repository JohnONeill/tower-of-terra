#!/bin/sh

ssh -o "StrictHostKeyChecking no" ubuntu@$1 exit
while test $? -gt 0
do
  sleep 5
  echo "Trying again..."
  ssh -o "StrictHostKeyChecking no" ubuntu@$1 exit
done
