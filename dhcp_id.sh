#!/bin/bash

ipconfig getpacket en0 | awk '/server_identifier/ {print $3}'


