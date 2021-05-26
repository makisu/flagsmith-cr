class Flagsmith::Trait
  include JSON::Serializable

  getter id : Int32
  getter trait_key : String
  getter trait_value : String | Int32 | Bool
end
