#!/bin/bash

tr -d "\n\r" < samples/trendvision.data |  grep -aoE $'\$BEGIN\$G[A-Z]+RMC[A-Z\.,*0-9]+;\$TIME:[-0-9]+\$END'