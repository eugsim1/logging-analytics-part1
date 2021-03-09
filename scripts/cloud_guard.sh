### cloud guard
## summary of Activity type problems identified
oci cloud-guard activity-problem-aggregation request-summarized-activity-problems \
--profile  DBSEC \
--access-level  ACCESSIBLE \
--compartment-id ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq \
--compartment-id-in-subtree true \
--include-unknown-locations true  | jq -r '.data.items[] | "\(.count)   \(."political-location".city)  \(."political-location".country) " '


oci cloud-guard problem list \
--profile  DBSEC \
--access-level  ACCESSIBLE \
--all \
--compartment-id ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq \
--compartment-id-in-subtree true | jq -r ' .data.items[] | " \(."compartment-id") \(.id) \(."region")  \(."labels")  \(."lifecycle-detail") \(."resource-name") \(."resource-type")   \(."risk-level") " '


oci cloud-guard problem list \
--profile  DBSEC \
--access-level  ACCESSIBLE \
--all \
--compartment-id ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq \
--compartment-id-in-subtree true | jq -r ' .data.items[] | "\(.id) "' > gloud_guard_problem_id.txt
wc -l   gloud_guard_problem_id.txt

while IFS= read -r line; do
oci cloud-guard problem get \
--profile  DBSEC \
--problem-id $line
done < gloud_guard_problem_id.txt