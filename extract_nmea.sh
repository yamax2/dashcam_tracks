#!/bin/bash

grep -aoE $'\$G[A-Z]+RMC[A-Z\.,*0-9]+\n' samples/trendvision.data
