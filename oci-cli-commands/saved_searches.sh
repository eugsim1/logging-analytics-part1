cat<<EOF>save_search.json
{
  "dataConfig": [],
  "definedTags": {"Oracle-Tags": {"ResourceAllocation": "Logging-Analytics"}},
  "description": "view_logs_in_explorer imported",
  "displayName": "view_logs_in_explorer_imported_1",
  "freeformTags":  {"Project":"log_analytics"},
  "isOobSavedSearch": false,
  "metadataVersion": "2.0",
  "nls": {},
  "providerId": "log-analytics",
  "providerName": "Logging Analytics",
  "providerVersion": "2.0",
  "screenImage":  " ",
  "type": "SEARCH_SHOW_IN_DASHBOARD",
  "uiConfig": {
    "queryString": "'Upload Name' = 'logginganalytics-analytics000' | timestats count as logrecords by 'Log Source' | sort -logrecords",
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
              "value": "ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq"
            }
          ]
        },
        {
          "flags": {
            "IncludeDependents": true,
            "ScopeCompartmentId": "ocid1.compartment.oc1..aaaaaaaahd45l6jvxsnw5xvnfybs75aqujhmw4ygqjwnawuiay7wo2xjjbba"
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
  "widgetTemplate": "jet-modules/dashboards/widgets/lxSavedSearchWidget.html",
  "widgetVm": "jet-modules/dashboards/widgets/lxSavedSearchWidget"
}
EOF

oci management-dashboard saved-search create \
--profile DBSEC \
--compartment-id ocid1.compartment.oc1..aaaaaaaahd45l6jvxsnw5xvnfybs75aqujhmw4ygqjwnawuiay7wo2xjjbba \
--from-json file://save_search.json


oci management-dashboard saved-search get \
--profile DBSEC \
--management-saved-search-id "ocid1.managementsavedsearch.oc1..aaaaaaaawyf3o33zdldp4d32rpsnjhjhdvgqjjldajsy34gzoh6nrihmdyma"

oci management-dashboard saved-search get \
--profile DBSEC \
--management-saved-search-id ocid1.managementsavedsearch.oc1..aaaaaaaaj2rfmg26tyfrvz6nwadgsdyybhgqltmjynluqmvd6pxdublrsqbq


oci management-dashboard saved-search get \
--profile DBSEC \
--management-saved-search-id ocid1.managementsavedsearch.oc1..aaaaaaaajkwf4lriqyalutzco54mzlgfdyg54xmgmyc5eh6jpzkkpn7m42jq

oci management-dashboard saved-search list \
--profile DBSEC \
--compartment-id ocid1.compartment.oc1..aaaaaaaahd45l6jvxsnw5xvnfybs75aqujhmw4ygqjwnawuiay7wo2xjjbba \
--all

oci management-dashboard saved-search list \
--profile DBSEC \
--compartment-id ocid1.compartment.oc1..aaaaaaaaold7zxbenwlyogbb7gx3my3gwti3au7aqn5sifgjp6b44x6uf7jq \
--all


oci management-dashboard saved-search update --generate-full-command-json-input 
{
  "compartmentId": "string",
  "definedTags":   "definedTags": {"Oracle-Tags": {"ResourceAllocation": "Logging-Analytics"}},
  "force": true,
  "freeformTags":  {"Project":"log_analytics", "Version" :"0.0.0.0"},
  "ifMatch": "string",
  "isOobSavedSearch": true,
  "managementSavedSearchId": "string",
 
  "providerId": "string",
  "providerName": "string",
  "providerVersion": "string",
 
 
 
}

