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

  def self.get_flags(user_id = nil)
    if user_id.nil?
      res = Flagsmith.client.get("/api/v1/flags/")
      flags = Array(Flag).from_json(res.body)
    else
      res = Flagsmith.client.get("identities/?identifier=#{user_id}")
      puts res.body
    end
  end
  
  def self.feature_enabled?(feature, user_id = nil, default = false)
    normalize = normalize_key(feature)
    flag = get_flags(user_id)[normalize]
    return default if flag.nil?
    flag[:enabled]
  end
  
  def self.get_value(key, user_id = nil, default = nil)
    flag = get_flags(user_id)[normalize_key(key)]
    return default if flag.nil?
    flag[:value]
  end
  
  def self.set_trait(user_id, trait, value)
    raise StandardError, "user_id cannot be nil" if user_id.nil?
  
    res = Flagsmith.client.post("traits/", trait.to_json)
    trait = Flagsmith::Trait.from_json(res.body)
    res.body
  end
  
  def self.get_traits(user_id)
     if user_id.nil?
       return nil
     end
    res = Flagsmith.client.get("identities/?identifier=#{user_id}")
    # traits_to_hash(res.body)
  end
  
  def self.transform_flags(flags)
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
  
  def self.normalize_key(key)
    key.to_s.downcase
  end
  
end


require "./flagsmith/**"
