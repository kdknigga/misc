#!/bin/bash

NUMBER_OF_LOOPS=5
NUMBER_OF_DAYS=14
SLEEP_TIME=75

DATE_FORMAT="+%Y-%m-%d"
for i in $(seq 1 ${NUMBER_OF_LOOPS})
do
	echo "Loop: ${i}"
	DATES="$(date "${DATE_FORMAT}")"
	
	for i in $(seq 1 $((NUMBER_OF_DAYS-1)))
	do
		DATES="${DATES} $(date -d "+${i} days" "${DATE_FORMAT}")"
	done

	for DATE in ${DATES}
	do
		while read AIRPORT
		do
			date
			curl -X POST -F "airport=${AIRPORT}" -F "date=${DATE}" http://loggingnight.org/lookup
			echo
			sleep ${SLEEP_TIME}
		done < <(curl http://loggingnight.org/static/sitemap.txt | grep -v date | awk 'BEGIN{ FS="=" }{ print $NF }')
	done
done
