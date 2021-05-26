class Flagsmith::FeatureFlag
  include JSON::Serializable

  getter id : Int32
  getter name : String
  getter created_date : Time
  getter initial_value : String?
  getter description : String?
  getter default_enabled : Bool
  getter type : String
end
