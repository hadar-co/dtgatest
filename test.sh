#!/bin/bash

set -x

PASSED_YAML=$(jq .evaluationSummary.passedYamlValidationCount blah.json)
PASSED_K8S=$(jq .evaluationSummary.k8sValidation blah.json)
PASSED_POLICY=$(jq .evaluationSummary.passedPolicyValidationCount blah.json)
POLICY_NAME=$(jq .policySummary.policyName blah.json)
TOTAL_RULES=$(jq .policySummary.totalRulesInPolicy blah.json)
CONFIGS_COUNT=$(jq .evaluationSummary.configsCount blah.json)
PASSED=$(jq .policySummary.totalPassedCount blah.json)
FAILED=$(jq .policySummary.totalRulesFailed blah.json)
SKIPPED=$(jq .policySummary.totalSkippedRules blah.json)

echo "<img src=\"https://raw.githubusercontent.com/datreeio/datree/main/images/datree-logo.svg\" width=\"180\"/>&nbsp;" >> $GITHUB_STEP_SUMMARY
echo "🌟 Want protection on your cluster as well? Try out our [admission webhook!](https://github.com/datreeio/admission-webhook-datree#datree-admission-webhook) 🌟" >> $GITHUB_STEP_SUMMARY
echo "## Datree policy check summary" >> $GITHUB_STEP_SUMMARY
echo "**Policy name:** $POLICY_NAME" >> $GITHUB_STEP_SUMMARY
echo "**Passed YAML validation:** $PASSED_YAML" >> $GITHUB_STEP_SUMMARY
echo "**Passed Kubernetes schema validation:** $PASSED_K8S" >> $GITHUB_STEP_SUMMARY
echo "**Passed policy check :** $PASSED_POLICY" >> $GITHUB_STEP_SUMMARY

echo "| Enabled rules in policy | $TOTAL_RULES |" >> $GITHUB_STEP_SUMMARY
echo "|-------------|--------|" >> $GITHUB_STEP_SUMMARY
echo "| Configs tested against policy | $CONFIGS_COUNT |" >> $GITHUB_STEP_SUMMARY
