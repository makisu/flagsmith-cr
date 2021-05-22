class Flagsmith::Trait
  include JSON::Serializable

  getter id : Int32
  getter trait_key : String
  getter trait_value : String
end

  # "traits": [
  #   {
  #     "id": 215352,
  #     "trait_key": "roles",
  #     "trait_value": "[\"admin\",\"staff\"]"
  #   },
  #   {
  #     "id": 215988,
  #     "trait_key": "foo",
  #     "trait_value": "bar"
  #   }
  # ]
