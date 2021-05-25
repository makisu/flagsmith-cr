require "./src/flagsmith.cr"
require "json"
api_key1 = "BHeQQ3gdHr6WGx5Utc2T52" #Xavi's key
api_key2 = "dsgjq6F9yzKe8M4QjNk5gH" #Rio's Key
api_key3 = "d4Rq3GadEuYipMZQGyVMaq" #Rio's Key
api_prod_key = ""
feature = "signup_fields"
Flagsmith.api_key = api_key2
puts Flagsmith.get_flags()
puts Flagsmith.get_flags("rio")
puts Flagsmith.get_traits("rio")
# Flagsmith.set_trait("rio", "identifierzz", 30) >> working but need to comment because it's a post method
puts Flagsmith.feature_enabled?(feature, "rio")
puts Flagsmith.get_value(feature, "rio")
