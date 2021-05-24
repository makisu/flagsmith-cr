require "./src/flagsmith.cr"
require "json"
api_key1 = "BHeQQ3gdHr6WGx5Utc2T52" #Xavi's key
api_key2 = "dsgjq6F9yzKe8M4QjNk5gH" #Rio's Key
api_prod_key = ""
feature = "signup_fields"
Flagsmith.api_key = api_key2
Flagsmith.get_flags()
Flagsmith.get_flags("rio")
Flagsmith.get_traits("rio")
# Flagsmith.set_trait("rio", "identifierzz", 30) >> working but need to comment because it's a post method
Flagsmith.feature_enabled?(feature, "rio")
Flagsmith.get_value(feature, "rio")
