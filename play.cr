require "./src/flagsmith.cr"
require "json"
api_key1 = "BHeQQ3gdHr6WGx5Utc2T52" #Xavi's key
api_key2 = "dsgjq6F9yzKe8M4QjNk5gH" #Rio's Key
api_key3 = "d4Rq3GadEuYipMZQGyVMaq" #Rio's Key
api_prod_key = ""
feature = "signup_fields"
Flagsmith.api_key = api_key2
# puts Flagsmith.get_flags()
# puts Flagsmith.get_flags("rio")
# test = Flagsmith.get_traits("maria")
# if test
#   puts test["font"].id
#   puts test["font"].trait_key
#   puts test["font"].trait_value
# end
test = Flagsmith.set_trait("maria", "font", "arial", true) 
if test
    puts test[:flags]["signup_fields"].id
    puts test[:flags]["signup_fields"].feature_state_value

    puts test[:traits]["font"].id
    puts test[:traits]["font"].trait_key
    puts test[:traits]["font"].trait_value
end



# puts Flagsmith.feature_enabled?(feature, "rio")
# puts Flagsmith.get_value(feature, "xavi")
