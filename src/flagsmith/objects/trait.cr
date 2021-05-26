class Flagsmith::Trait
  include JSON::Serializable

  getter id : Int32
  getter trait_key : String
  getter trait_value : Int32
end
