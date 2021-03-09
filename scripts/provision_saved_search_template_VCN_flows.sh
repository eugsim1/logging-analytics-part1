####
### Example about how ot pre provision a logan compartement with a saved search
####

export COMPARTEMENT_OCID=$1
export ROOT_COMPARTMENT_OCID=$2
export UPLOAD_CONTAINER=$3

cat<<EOF>save_search.json
      {
        "compartment-id": "$COMPARTEMENT_OCID",
        "data-config": [],
        "definedTags": {"Oracle-Tags": {"ResourceAllocation": "Logging-Analytics"}},
        "description": "1-OCI VCN Flow Logs",
        "display-name": "1-OCI VCN Flow Logs",
        "freeformTags":  {"Project":"log_analytics"},
        "is-oob-saved-search": false,
        "lifecycle-state": "ACTIVE",
        "metadata-version": "2.0",
        "nls": {},
        "provider-id": "log-analytics",
        "screen-image": " ",
        "type": "WIDGET_SHOW_IN_DASHBOARD",
        "ui-config": {
          "queryString": "'Upload Name' = '$UPLOAD_CONTAINER' and 'Log Source' = 'OCI VCN Flow Logs' | timestats count as logrecords by 'Log Source' | sort -logrecords",
          "scopeFilters": {
            "filters": [
              {
                "flags": {
                  "IncludeSubCompartments": true
                },
                "type": "LogGroup",
                "values": [
                  {
                    "label": "oractdemeasec (root)",
                    "value": "$ROOT_COMPARTMENT_OCID"
                  }
                ]
              },
              {
                "flags": {
                  "IncludeDependents": true,
                  "ScopeCompartmentId": "$ROOT_COMPARTMENT_OCID"
                },
                "type": "Entity",
                "values": []
              }
            ],
            "isGlobal": false
          },
          "showTitle": true,
          "timeSelection": {
            "endTimeUtc": "2020-11-22T02:00:51.000Z",
            "startTimeUtc": "2020-09-21T05:55:31.000Z",
            "timePeriod": "cust"
          },
          "visualizationOptions": {
            "showLogScale": false
          },
          "visualizationType": "records_histogram"
        },
        "widget-template": "jet-modules/dashboards/widgets/lxSavedSearchWidget.html",
        "widget-vm": "jet-modules/dashboards/widgets/lxSavedSearchWidget"
      }
EOF

oci management-dashboard saved-search create \
--profile DBSEC \
--compartment-id $COMPARTEMENT_OCID \
--provider-name LoggingAnalytics \
--provider-version 2 \
--from-json file://save_search.json
