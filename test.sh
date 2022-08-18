#!/bin/bash

set -x

PASSED_YAML=$(jq .evaluationSummary.passedYamlValidationCount lastPolicyCheck.json)
PASSED_K8S=$(jq .evaluationSummary.k8sValidation lastPolicyCheck.json | awk -F[\"/] '{print $2}' )
PASSED_POLICY=$(jq .evaluationSummary.passedPolicyValidationCount lastPolicyCheck.json)
POLICY_NAME=$(jq .policySummary.policyName lastPolicyCheck.json | awk -F[\"\"] '{print $2}')
TOTAL_RULES=$(jq .policySummary.totalRulesInPolicy lastPolicyCheck.json)
CONFIGS_COUNT=$(jq .evaluationSummary.configsCount lastPolicyCheck.json)
PASSED=$(jq .policySummary.totalPassedCount lastPolicyCheck.json)
FAILED=$(jq .policySummary.totalRulesFailed lastPolicyCheck.json)
SKIPPED=$(jq .policySummary.totalSkippedRules lastPolicyCheck.json)

echo "<img src=\"https://raw.githubusercontent.com/datreeio/datree/main/images/datree_logo_color.svg\" width=\"350\"/>&nbsp;" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "☸️ Want guardrails on your cluster as well? Try out our [admission webhook!](https://github.com/datreeio/admission-webhook-datree#datree-admission-webhook) ☸️&nbsp;  " >> $GITHUB_STEP_SUMMARY
echo "## Datree policy check summary" >> $GITHUB_STEP_SUMMARY
echo "**Policy name:** $POLICY_NAME" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "**Passed YAML validation:** $PASSED_YAML/$CONFIGS_COUNT" >> $GITHUB_STEP_SUMMARY
echo "**Passed Kubernetes schema validation:** $PASSED_K8S/$CONFIGS_COUNT" >> $GITHUB_STEP_SUMMARY
echo "**Passed policy check :** $PASSED_POLICY/$CONFIGS_COUNT" >> $GITHUB_STEP_SUMMARY

echo "| Enabled rules in policy $POLICY_NAME | $TOTAL_RULES |" >> $GITHUB_STEP_SUMMARY
echo "|-|-|" >> $GITHUB_STEP_SUMMARY
echo "| **Configs tested against policy** | <div align="center">**$CONFIGS_COUNT**</div> |" >> $GITHUB_STEP_SUMMARY
echo "| **Total rules evaluated** | <div align="center">**$(($TOTAL_RULES*$CONFIGS_COUNT))**</div> |" >> $GITHUB_STEP_SUMMARY
echo "| **Total rules skipped** | <div align="center">**$SKIPPED**</div> |" >> $GITHUB_STEP_SUMMARY
echo "| **Total rules failed** ⛔ | <div align="center">**$FAILED**</div> |" >> $GITHUB_STEP_SUMMARY
echo "| **Total rules passed** ✅ | <div align="center">**$PASSED**</div> |" >> $GITHUB_STEP_SUMMARY
echo "| **See all rules in policy** | <div align="center">**[https://app.datree.io](https://app.datree.io)**</div> |" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY

if [[ $FAILED > 0 ]]; then
   echo "**Failed rules:**  " >> $GITHUB_STEP_SUMMARY
   echo "" >> $GITHUB_STEP_SUMMARY
fi

INDEX=0
while [[ $INDEX -lt $FAILED ]]
do
   VIOLATED_RULE_ID=$(jq ".policyValidationResults[0] | .ruleResults[$INDEX] | .identifier" lastPolicyCheck.json)
   VIOLATED_RULE_NAME=$(jq ".policyValidationResults[0] | .ruleResults[$INDEX] | .name" lastPolicyCheck.json)
   VIOLATED_RULE_OCCURRENCES=$(jq ".policyValidationResults[0] | .ruleResults[$INDEX] | .occurrencesDetails[] | .occurrences" lastPolicyCheck.json)
   VIOLATED_RULE_METADATA_NAME=$(jq ".policyValidationResults[0] | .ruleResults[$INDEX] | .occurrencesDetails[] | .metadataName" lastPolicyCheck.json)
   VIOLATED_RULE_KIND=$(jq ".policyValidationResults[0] | .ruleResults[$INDEX] | .occurrencesDetails[] | .kind" lastPolicyCheck.json)
   VIOLATED_RULE_FAIL_MESSAGE=$(jq ".policyValidationResults[0] | .ruleResults[$INDEX] | .messageOnFailure" lastPolicyCheck.json)
   
   echo "❌ **$VIOLATED_RULE_NAME [$VIOLATED_RULE_OCCURRENCES occurrence/s]**" >> $GITHUB_STEP_SUMMARY
   echo "metadata.name: $VIOLATED_RULE_METADATA_NAME (kind: $VIOLATED_RULE_KIND)" >> $GITHUB_STEP_SUMMARY
   echo "💡 $VIOLATED_RULE_FAIL_MESSAGE" >> $GITHUB_STEP_SUMMARY
   echo "" >> $GITHUB_STEP_SUMMARY
   
   ((INDEX = INDEX + 1))
done

