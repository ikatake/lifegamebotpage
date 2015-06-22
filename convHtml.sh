#!/bin/bash
pandoc -t html5 -o index.html -f markdown -s -c lgb.css index.md
