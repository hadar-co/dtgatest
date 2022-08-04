#!/bin/bash

set -x

POLICY_NAME=$(jq .policySummary.policyName blah.json)
TOTAL_RULES=$(jq .policySummary.totalRulesInPolicy blah.json)
PASSED=$(jq .policySummary.totalPassedCount blah.json)
FAILED=$(jq .policySummary.totalRulesFailed blah.json)

echo "![image](https://raw.githubusercontent.com/datreeio/datree/main/images/datree-logo.svg)" >> $GITHUB_STEP_SUMMARY
echo "## Datree policy check results" >> $GITHUB_STEP_SUMMARY
echo "**Policy name:** $POLICY_NAME" >> $GITHUB_STEP_SUMMARY
echo "| Total rules | Passed | Failed |" >> $GITHUB_STEP_SUMMARY
echo "|-------------|--------|--------|" >> $GITHUB_STEP_SUMMARY
echo "| $TOTAL_RULES | $PASSED | $FAILED |" >> $GITHUB_STEP_SUMMARY
