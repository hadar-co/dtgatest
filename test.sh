#!/bin/bash

set +x

PASSED=$(jq .policySummary.totalPassedCount blah.json)

echo "Passed: $PASSED" >> $GITHUB_STEP_SUMMARY
