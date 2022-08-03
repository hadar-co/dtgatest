#!/bin/bash

set -x

PASSED=$(jq .policySummary.totalPassedCount blah.json)
FAILED=$(jq .policySummary.totalFailedCount blah.json)

echo "Datree policy check results:  " >> $GITHUB_STEP_SUMMARY
echo "| Total rules | Passed | Failed |" >> $GITHUB_STEP_SUMMARY
echo "|-------------|--------|--------|" >> $GITHUB_STEP_SUMMARY
echo "| 33333 | $PASSED | $FAILED |" >> $GITHUB_STEP_SUMMARY
