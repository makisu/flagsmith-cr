def get_flags(user_id = nil)
  if user_id.nil?
    res = Flagsmith.client.get("flags/")
    flags =  Flag::FlagList.from_json(res.body)

  else
    res = Flagsmith.client.get("identities/?identifier=#{user_id}")
  end
end

def feature_enabled?(feature, user_id = nil, default = false)
  flag = get_flags(user_id)[normalize_key(feature)]
  return default if flag.nil?

  flag[:enabled]
end

def get_value(key, user_id = nil, default = nil)
  flag = get_flags(user_id)[normalize_key(key)]
  return default if flag.nil?

  flag[:value]
end

def set_trait(user_id, trait, value)
  raise StandardError, "user_id cannot be nil" if user_id.nil?
  res = Flagsmith.client.post("traits/", trait.to_json)
  trait = Flagsmith::Trait.from_json(res.body)
  res.body
end

def get_traits(user_id)
   if user_id.nil?
     return nil
   end
  res = Flagsmith.client.get("identities/?identifier=#{user_id}")
  # traits_to_hash(res.body)
end

def transform_flags(flags)
  flags.map do |flag|
    {
         name:    flag["feature"]["name"],
      enabled:    flag["enabled"],
        value:    flag["feature_state_value"],
      segment:    flag["feature_segment"]
    }
  end
end

# def flags_to_hash(flags)
#   result = {} of NamedTuple(key: Symbol, flag: Hash(String))
#   flags.each do |flag|
#     key = normalize_key(flag.delete(:name))
#     result[key] = flag
#   end
#   result
# end

# def traits_to_hash(user_flags)
#   # result = {}
#   user_flags["traits"].each do |t|
#     key = normalize_key(t["trait_key"])
#     result[key] = t["trait_value"]
#   end
#   result
# end

def normalize_key(key)
  key.to_s.downcase
end
