class Flagsmith::Flag
  include JSON::Serializable

  getter id : Int32
  getter feature : Flagsmith::FeatureFlag
  getter feature_state_value : String?
  getter enabled : Bool
  getter environment : Int32
  getter identity : String?
  getter feature_segment : String?
end

# "feature": {
#   "id": 2093,
#   "name": "feature_one",
#   "created_date": "2020-01-09T01:15:22.103956Z",
#   "initial_value": null,
#   "description": "feature one",
#   "default_enabled": false,
#   "type": "FLAG",
#   "project": 927
# },
# "feature_state_value": null,
# "enabled": false,
# "environment": 2310,
# "identity": null,
# "feature_segment": null
# },
