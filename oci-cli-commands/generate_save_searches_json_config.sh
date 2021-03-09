export LOGAN_COMPT_OCID=ocid1.compartment.oc1..aaaaaaaahd45l6jvxsnw5xvnfybs75aqujhmw4ygqjwnawuiay7wo2xjjbba
export LOGAN_ROOT_COMP_OCID=ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq
export LOGAN_ROOT_COMP_LABEL="oractdemeasec (root)"
export LOGAN_LOGCROUP_NAME="logginganalytics-analytics000"

echo "3_OCI_API_Gateway_Access_Logs.json"
cat<<EOF>3_OCI_API_Gateway_Access_Logs.json
      {
        "compartment-id": "$LOGAN_COMPT_OCID",
		 "data-config": [],
        "definedTags": {"Oracle-Tags": {"ResourceAllocation": "Logging-Analytics"}},
        "description": "3_OCI_API_Gateway_Access_Logs",
        "display-name": "3_OCI_API_Gateway_Access_Logs",
        "freeformTags":  {"Project":"log_analytics"},
        "is-oob-saved-search": false,
        "metadata-version": "2.0",
        "nls": {},
        "provider-id": "log-analytics",
        "screen-image": " ",
        "type": "WIDGET_SHOW_IN_DASHBOARD",
        "ui-config": {
          "queryString": "'Upload Name' = '$LOGAN_LOGCROUP_NAME' and 'Log Source' = 'OCI API Gateway Access Logs' | timestats count as logrecords by 'Log Source' | sort -logrecords",
          "scopeFilters": {
            "filters": [
              {
                "flags": {
                  "IncludeSubCompartments": true
                },
                "type": "LogGroup",
                "values": [
                  {
                    "label": "$LOGAN_ROOT_COMP_LABEL",
                    "value": "$LOGAN_ROOT_COMP_OCID"
                  }
                ]
              },
              {
                "flags": {
                  "IncludeDependents": true,
                  "ScopeCompartmentId": "$LOGAN_COMPT_OCID"
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

echo "7-OCI_VCN_Flow_Logs_by_Destination_IP_Link_step1.json"
cat<<EOF>7-OCI_VCN_Flow_Logs_by_Destination_IP_Link_step1.json
      {
        "compartment-id": "$LOGAN_COMPT_OCID",
        "data-config": [],
        "definedTags": {"Oracle-Tags": {"ResourceAllocation": "Logging-Analytics"}},
        "description": "7-OCI VCN Flow Logs' by 'Destination IP'-Link step1",
        "display-name": "7-OCI VCN Flow Logs' by 'Destination IP'-Link step1",
        "freeformTags":  {"Project":"log_analytics"},
         "is-oob-saved-search": false,
         "metadata-version": "2.0",
        "nls": {},
        "provider-id": "log-analytics",
        "screen-image": " ",
        "type": "WIDGET_SHOW_IN_DASHBOARD",
        "ui-config": {
          "queryString": "'Log Source' = 'OCI VCN Flow Logs' | eval 'Source Name' = if('Source Port' = 80, HTTP, 'Source Port' = 443, HTTPS, 'Source Port' = 21, FTP, 'Source Port' = 22, SSH, 'Source Port' = 137, NetBIOS, 'Source Port' = 648, RRP, 'Source Port' = 9006, Tomcat, 'Source Port' = 9042, Cassandra, 'Source Port' = 9060, 'Websphere Admin. Console', 'Source Port' = 9100, 'Network  Printer', 'Source Port' = 9200, 'Elastic Search', Other) | eval 'Destination Name' = if('Destination Port' = 80, HTTP, 'Destination Port' = 443, HTTPS, 'Destination Port' = 21, SSH, 'Destination Port' = 22, FTP, 'Destination Port' = 137, NetBIOS, 'Destination Port' = 648, RRP, 'Destination Port' = 9006, Tomcat, 'Destination Port' = 9042, Cassandra, 'Destination Port' = 9060, 'Websphere Admin. Console', 'Destination Port' = 9100, 'Network  Printer', 'Destination Port' = 9200, 'Elastic Search', Other) | timestats count",
          "scopeFilters": {
            "filters": [
              {
                "flags": {
                  "IncludeSubCompartments": true
                },
                "type": "LogGroup",
                "values": [
                  {
                    "label": "$LOGAN_ROOT_COMP_LABEL",
                    "value": "$LOGAN_ROOT_COMP_OCID"
                  }
                ]
              },
              {
                "flags": {
                  "IncludeDependents": true,
                  "ScopeCompartmentId": "$LOGAN_COMPT_OCID"
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

echo "7-OCI_VCN_Flow_Logs_by_Destination_IP_Link_Step2.json"
cat<<EOF>7-OCI_VCN_Flow_Logs_by_Destination_IP_Link_Step2.json
      {
        "compartment-id": "$LOGAN_COMPT_OCID",
        "data-config": [],
        "definedTags": {"Oracle-Tags": {"ResourceAllocation": "Logging-Analytics"}},
        "description": "7-OCI VCN Flow Logs' by 'Destination IP' Link Step2",
        "display-name": "7-OCI VCN Flow Logs' by 'Destination IP' Link Step2",
        "freeformTags":  {"Project":"log_analytics"},
        "is-oob-saved-search": false,
        "metadata-version": "2.0",
        "nls": {},
        "provider-id": "log-analytics",
        "screen-image": " ",
        "type": "WIDGET_SHOW_IN_DASHBOARD",
        "ui-config": {
          "queryString": "'Log Source' = 'OCI VCN Flow Logs' | eval 'Source Name' = if('Source Port' = 80, HTTP, 'Source Port' = 443, HTTPS, 'Source Port' = 21, FTP, 'Source Port' = 22, SSH, 'Source Port' = 137, NetBIOS, 'Source Port' = 648, RRP, 'Source Port' = 9006, Tomcat, 'Source Port' = 9042, Cassandra, 'Source Port' = 9060, 'Websphere Admin. Console', 'Source Port' = 9100, 'Network  Printer', 'Source Port' = 9200, 'Elastic Search', Other) | eval 'Destination Name' = if('Destination Port' = 80, HTTP, 'Destination Port' = 443, HTTPS, 'Destination Port' = 21, SSH, 'Destination Port' = 22, FTP, 'Destination Port' = 137, NetBIOS, 'Destination Port' = 648, RRP, 'Destination Port' = 9006, Tomcat, 'Destination Port' = 9042, Cassandra, 'Destination Port' = 9060, 'Websphere Admin. Console', 'Destination Port' = 9100, 'Network  Printer', 'Destination Port' = 9200, 'Elastic Search', Other) | eval Source = 'Source IP' || ':' || 'Source Port' | eval Destination = 'Destination IP' || ':' || 'Destination Port' | timestats count",
          "scopeFilters": {
            "filters": [
              {
                "flags": {
                  "IncludeSubCompartments": true
                },
                "type": "LogGroup",
                "values": [
                  {
                    "label": "$LOGAN_ROOT_COMP_LABEL",
                    "value": "$LOGAN_ROOT_COMP_OCID"
                  }
                ]
              },
              {
                "flags": {
                  "IncludeDependents": true,
                  "ScopeCompartmentId": "$LOGAN_COMPT_OCID"
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

echo "7-OCI_VCN_Flow_Logs_by_Destination_IP.json"
cat<<EOF>7-OCI_VCN_Flow_Logs_by_Destination_IP.json
     {
        "compartment-id": "$LOGAN_COMPT_OCID",
        "data-config": [],
        "definedTags": {"Oracle-Tags": {"ResourceAllocation": "Logging-Analytics"}},
        "description": "7-OCI VCN Flow Logs  by 'Destination IP'",
        "display-name": "7-OCI VCN Flow Logs'  by 'Destination IP'",
        "freeformTags":  {"Project":"log_analytics"},
        "is-oob-saved-search": false,
        "lifecycle-state": "ACTIVE",
        "metadata-version": "2.0",
        "nls": {},
        "provider-id": "log-analytics",
        "screen-image": " ",
       "type": "WIDGET_SHOW_IN_DASHBOARD",
        "ui-config": {
          "queryString": "'Log Source' = 'OCI VCN Flow Logs' | stats count('Destination IP') by 'Destination IP'",
          "scopeFilters": {
            "filters": [
              {
                "flags": {
                  "IncludeSubCompartments": true
                },
                "type": "LogGroup",
                "values": [
                  {
                    "label": "$LOGAN_ROOT_COMP_LABEL",
                    "value": "$LOGAN_ROOT_COMP_OCID"
                  }
                ]
              },
              {
                "flags": {
                  "IncludeDependents": true,
                  "ScopeCompartmentId": "$LOGAN_COMPT_OCID"
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
          "visualizationType": "treemap"
        },
        "widget-template": "jet-modules/dashboards/widgets/lxSavedSearchWidget.html",
        "widget-vm": "jet-modules/dashboards/widgets/lxSavedSearchWidget"
      }
EOF

echo "5-OCI_VCN_Flow_Logs_by_Source_IP.json"
cat<<EOF>5-OCI_VCN_Flow_Logs_by_Source_IP.json
      {
        "compartment-id": "$LOGAN_COMPT_OCID",
         "data-config": [],
        "definedTags": {"Oracle-Tags": {"ResourceAllocation": "Logging-Analytics"}},
        "description": "5-OCI VCN Flow Logs by Source IP",
        "display-name": "5-OCI VCN Flow Logs by Source IP",
        "freeformTags":  {"Project":"log_analytics"},
        "is-oob-saved-search": false,
        "lifecycle-state": "ACTIVE",
        "metadata-version": "2.0",
        "nls": {},
        "provider-id": "log-analytics",
        "screen-image": " ",
        "time-created": "2021-01-29T12:25:34.215000+00:00",
        "time-updated": "2021-01-29T12:25:34.215000+00:00",
        "type": "WIDGET_SHOW_IN_DASHBOARD",
        "ui-config": {
          "queryString": "'Upload Name' = '$LOGAN_LOGCROUP_NAME' and 'Log Source' = 'OCI VCN Flow Logs' | timestats count as logrecords by 'Source IP'",
          "scopeFilters": {
            "filters": [
              {
                "flags": {
                  "IncludeSubCompartments": true
                },
                "type": "LogGroup",
                "values": [
                  {
                    "label": "$LOGAN_ROOT_COMP_LABEL",
                    "value": "$LOGAN_ROOT_COMP_OCID"
                  }
                ]
              },
              {
                "flags": {
                  "IncludeDependents": true,
                  "ScopeCompartmentId": "$LOGAN_COMPT_OCID"
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

echo "4-OCI_API_Gateway_Execution_Logs.json"
cat<<EOF>4-OCI_API_Gateway_Execution_Logs.json
	  {
        "compartment-id": "$LOGAN_COMPT_OCID",
        "data-config": [],
        "definedTags": {"Oracle-Tags": {"ResourceAllocation": "Logging-Analytics"}},
        "description": "4-OCI API Gateway Execution Logs",
        "display-name": "4-OCI API Gateway Execution Logs",
        "freeformTags":  {"Project":"log_analytics"},
        "is-oob-saved-search": false,
        "lifecycle-state": "ACTIVE",
        "metadata-version": "2.0",
        "nls": {},
        "provider-id": "log-analytics",
        "screen-image": " ",
        "time-created": "2021-01-29T12:23:59.233000+00:00",
        "time-updated": "2021-01-29T12:23:59.233000+00:00",
        "type": "WIDGET_SHOW_IN_DASHBOARD",
        "ui-config": {
          "queryString": "'Upload Name' = '$LOGAN_LOGCROUP_NAME' and 'Log Source' = 'OCI API Gateway Execution Logs' | timestats count as logrecords by 'Log Source' | sort -logrecords",
          "scopeFilters": {
            "filters": [
              {
                "flags": {
                  "IncludeSubCompartments": true
                },
                "type": "LogGroup",
                "values": [
                  {
                    "label": "$LOGAN_ROOT_COMP_LABEL",
                    "value": "$LOGAN_ROOT_COMP_OCID"
                  }
                ]
              },
              {
                "flags": {
                  "IncludeDependents": true,
                  "ScopeCompartmentId": "$LOGAN_COMPT_OCID"
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

echo "3-VIEW_OCI_GATEWAY_ACCESS_LOGS.json"
cat<<EOF>3-VIEW_OCI_GATEWAY_ACCESS_LOGS.json
      {
        "compartment-id": "$LOGAN_COMPT_OCID",

        "data-config": [],
        "definedTags": {"Oracle-Tags": {"ResourceAllocation": "Logging-Analytics"}},
        "description": "3-VIEW_OCI_GATEWAY_ACCESS_LOGS",
        "display-name": "3-VIEW_OCI_GATEWAY_ACCESS_LOGS",
        "freeformTags":  {"Project":"log_analytics"},
        "is-oob-saved-search": false,
        "lifecycle-state": "ACTIVE",
        "metadata-version": "2.0",
        "nls": {},
        "provider-id": "log-analytics",
        "screen-image": " ",
        "type": "WIDGET_SHOW_IN_DASHBOARD",
        "ui-config": {
          "queryString": "'Upload Name' = '$LOGAN_LOGCROUP_NAME' and 'Log Source' = 'OCI API Gateway Access Logs' | timestats count as logrecords by 'Log Source' | sort -logrecords",
          "scopeFilters": {
            "filters": [
              {
                "flags": {
                  "IncludeSubCompartments": true
                },
                "type": "LogGroup",
                "values": [
                  {
                    "label": "$LOGAN_ROOT_COMP_LABEL",
                    "value": "$LOGAN_ROOT_COMP_OCID"
                  }
                ]
              },
              {
                "flags": {
                  "IncludeDependents": true,
                  "ScopeCompartmentId": "$LOGAN_COMPT_OCID"
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

echo "2-VIEW_LOGS_IN_EXPLORER_CLUSTER.json"
cat<<EOF>2-VIEW_LOGS_IN_EXPLORER_CLUSTER.json
      {
        "compartment-id": "$LOGAN_COMPT_OCID",
        "data-config": [],
        "definedTags": {"Oracle-Tags": {"ResourceAllocation": "Logging-Analytics"}},
        "description": "2-VIEW_LOGS_IN_EXPLORER_CLUSTER",
        "display-name": "2-VIEW_LOGS_IN_EXPLORER_CLUSTER",
        "freeformTags":  {"Project":"log_analytics"},
        "is-oob-saved-search": false,
        "lifecycle-state": "ACTIVE",
        "metadata-version": "2.0",
        "nls": {},
        "provider-id": "log-analytics",
        "screen-image": " ",
        "type": "WIDGET_SHOW_IN_DASHBOARD",
        "ui-config": {
          "queryString": "'Upload Name' = '$LOGAN_LOGCROUP_NAME' | cluster",
          "scopeFilters": {
            "filters": [
              {
                "flags": {
                  "IncludeSubCompartments": true
                },
                "type": "LogGroup",
                "values": [
                  {
                    "label": "$LOGAN_ROOT_COMP_LABEL",
                    "value": "$LOGAN_ROOT_COMP_OCID"
                  }
                ]
              },
              {
                "flags": {
                  "IncludeDependents": true,
                  "ScopeCompartmentId": "$LOGAN_COMPT_OCID"
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
          "visualizationType": "cluster"
        },
        "widget-template": "jet-modules/dashboards/widgets/lxSavedSearchWidget.html",
        "widget-vm": "jet-modules/dashboards/widgets/lxSavedSearchWidget"
      }
EOF

echo "1-OCI_VCN_Flow_Logs.json"
cat<<EOF>1-OCI_VCN_Flow_Logs.json
      {
        "compartment-id": "$LOGAN_COMPT_OCID",
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
        "time-created": "2021-01-29T12:10:37.578000+00:00",
        "time-updated": "2021-01-29T12:10:37.578000+00:00",
        "type": "WIDGET_SHOW_IN_DASHBOARD",
        "ui-config": {
          "queryString": "'Upload Name' = '$LOGAN_LOGCROUP_NAME' and 'Log Source' = 'OCI VCN Flow Logs' | timestats count as logrecords by 'Log Source' | sort -logrecords",
          "scopeFilters": {
            "filters": [
              {
                "flags": {
                  "IncludeSubCompartments": true
                },
                "type": "LogGroup",
                "values": [
                  {
                    "label": "$LOGAN_ROOT_COMP_LABEL",
                    "value": "$LOGAN_ROOT_COMP_OCID"
                  }
                ]
              },
              {
                "flags": {
                  "IncludeDependents": true,
                  "ScopeCompartmentId": "$LOGAN_ROOT_COMP_OCID"
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

echo "VNC_LOGS_FLOWS.json"
cat<<EOF>VNC_LOGS_FLOWS.json
      {
        "compartment-id": "$LOGAN_COMPT_OCID",
        "data-config": [],
        "definedTags": {"Oracle-Tags": {"ResourceAllocation": "Logging-Analytics"}},
        "description": "VNC_LOGS_FLOWS",
        "display-name": "VNC_LOGS_FLOWS",
        "freeformTags":  {"Project":"log_analytics"},
        "is-oob-saved-search": false,
        "lifecycle-state": "ACTIVE",
        "metadata-version": "2.0",
        "nls": {},
        "provider-id": "log-analytics",
        "screen-image": " ",
        "type": "WIDGET_SHOW_IN_DASHBOARD",
        "ui-config": {
          "queryString": "'Upload Name' = '$LOGAN_LOGCROUP_NAME' and 'Log Source' = 'OCI VCN Flow Logs' | timestats count as logrecords by 'Log Source' | sort -logrecords",
          "scopeFilters": {
            "filters": [
              {
                "flags": {
                  "IncludeSubCompartments": true
                },
                "type": "LogGroup",
                "values": [
                  {
                    "label": "$LOGAN_ROOT_COMP_LABEL",
                    "value": "$LOGAN_ROOT_COMP_OCID"
                  }
                ]
              },
              {
                "flags": {
                  "IncludeDependents": true,
                  "ScopeCompartmentId": "$LOGAN_ROOT_COMP_OCID"
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

echo "VIEW_LOGS_IN_EXPLORER.json"
cat<<EOF>VIEW_LOGS_IN_EXPLORER.json
   {
        "compartment-id": "$LOGAN_COMPT_OCID",
        "data-config": [],
        "definedTags": {"Oracle-Tags": {"ResourceAllocation": "Logging-Analytics"}},
        "description": "VIEW LOGS",
        "display-name": "VIEW_LOGS_IN_EXPLORER",
        "freeformTags":  {"Project":"log_analytics"},
        "is-oob-saved-search": false,
        "lifecycle-state": "ACTIVE",
        "metadata-version": "2.0",
        "nls": {},
        "provider-id": "log-analytics",
        "screen-image": " ",
        "type": "WIDGET_SHOW_IN_DASHBOARD",
        "ui-config": {
          "queryString": "'Upload Name' = '$LOGAN_LOGCROUP_NAME' | timestats count as logrecords by 'Log Source' | sort -logrecords",
          "scopeFilters": {
            "filters": [
              {
                "flags": {
                  "IncludeSubCompartments": true
                },
                "type": "LogGroup",
                "values": [
                  {
                    "label": "$LOGAN_ROOT_COMP_LABEL",
                    "value": "$LOGAN_ROOT_COMP_OCID"
                  }
                ]
              },
              {
                "flags": {
                  "IncludeDependents": true,
                  "ScopeCompartmentId": "$LOGAN_COMPT_OCID"
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
