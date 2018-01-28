#!/bin/sh

grep -aoE $'(\$G[A-Z]+RMC[A-Z\.,*0-9]+)\r\n' d6pro.data
