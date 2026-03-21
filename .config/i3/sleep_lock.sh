#!/usr/bin/env bash
# Bloquea primero y espera a que el proceso termine antes de suspender
betterlockscreen -l blur &
sleep 0.5
systemctl suspend
