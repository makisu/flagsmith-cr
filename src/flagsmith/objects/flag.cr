class Flagsmith::Flag
  include JSON::Serializable

  getter id : Int32
  getter feature : Flagsmith::FeatureFlag
  getter feature_state_value : String? | Int32?
  getter enabled : Bool
  getter environment : Int32
  getter identity : Int32?
  getter feature_segment : String | Int32?
end
