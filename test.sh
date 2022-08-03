#!/bin/bash

set -x

PASSED=$(jq .policySummary.totalPassedCount blah.json)

echo "| Total rules | Passed | Failed |" >> $GITHUB_STEP_SUMMARY
echo "|-------------|--------|--------|" >> $GITHUB_STEP_SUMMARY
echo "| 33333 | $PASSED | asdfasdf | >> $GITHUB_STEP_SUMMARY
