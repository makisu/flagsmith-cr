require "json"
require "http/client"


class Flagsmith
  VERSION = "0.1.0"

  class Unset
  end


  @@api_key : String?

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_key
    @@api_key
  end

  BASE_URL = URI.parse("https://api.flagsmith.com")

  def self.client : HTTP::Client
    return @@client.not_nil! unless @@client.nil?

    self.reset_client

    @@client.not_nil!
  end

  def self.reset_client
    @@client = HTTP::Client.new(BASE_URL)

    @@client.not_nil!.before_request do |request|
      request.headers["Accept"] = "application/json"
      request.headers["Content-Type"] = "application/json"
      request.headers["X-Environment-Key"] = @@api_key.not_nil!
      # request.response :json
    end
  end

  def self.get_flags(user_id = nil) : Hash(String, Flagsmith::Flag)
    if user_id.nil?
      res = Flagsmith.client.get("/api/v1/flags/")
      flags = Array(Flag).from_json(res.body)
      flags_to_hash(flags)
    else
      res = Flagsmith.client.get("/api/v1/flags/identities/?identifier=#{user_id}")
      flags = Array(Flag).from_json(res.body)
      flags_to_hash(flags)
    end
  end

  def self.set_trait(user_id, trait, value)
    if user_id.nil?
      return nil
    end

    trait = {
        identity:    { identifier: user_id },
      trait_key:    normalize_key(trait),
    trait_value:    value
    }
    res = Flagsmith.client.post("/api/v1/traits/", form: trait.to_json)
  end
  
  def self.get_traits(user_id)
     if user_id.nil?
       return nil
     end
    res = Flagsmith.client.get("/api/v1/identities/?identifier=#{user_id}")

    traits = Flag::FlagList::Trait.from_json(res.body).traits
    # puts traits
    traits_to_hash(traits)
  end
  
  
  def self.feature_enabled?(feature, user_id = nil, default = false)
    feature_name = normalize_key(feature)
    flag = get_flags(user_id)[feature_name]
    return default if flag.nil?
    flag.enabled
  end
  
  def self.get_value(key, user_id = nil, default = nil)
    key_name = normalize_key(key)
    flag = get_flags(user_id)[key_name]
    return default if flag.nil?
    puts flag.feature_state_value
  end
  
  def self.normalize_key(key)
    key.to_s.downcase
  end

  def self.flags_to_hash(flags)
    result = {} of String => Flagsmith::Flag
    flags.each do |flag|
      result[flag.feature.name] = flag
    end
    result
  end

  def self.traits_to_hash(traits)
    result = {} of String => Flagsmith::Trait
    traits.each do |trait|
      result[trait.trait_key] = trait
    end
    result
  end

  # def traits_to_hash(user_flags)
  #   result = {}
  #   user_flags['traits']&.each do |t|
  #     key = normalize_key(t['trait_key'])
  #     result[key] = t['trait_value']
  #   end
  #   result
  # end
end

# not needed
  # def self.transform_flags(flags)
  #   flags.map do |flag|
  #     {
  #          name:    flag["feature"]["name"],
  #       enabled:    flag["enabled"],
  #         value:    flag["feature_state_value"],
  #       segment:    flag["feature_segment"]
  #     }
  #   end
  # end
  
require "./flagsmith/**"
