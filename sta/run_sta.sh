#!/bin/bash
echo "Running STA"
./sta/clean.sh 
sta sta/sta.tcl
echo "STA Completed"
