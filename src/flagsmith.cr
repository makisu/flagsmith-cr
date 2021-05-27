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
      if res.status_code == 200
        flags = Array(Flag).from_json(res.body)
        flags_to_hash(flags)
      else
        raise Error.from_json(res.body, "error")
      end
    else
      res = Flagsmith.client.get("/api/v1/identities/?identifier=#{user_id}")
      if res.status_code == 200
        flags = Flag::FlagList::Trait.from_json(res.body).flags
        flags_to_hash(flags)
      else
        raise Error.from_json(res.body, "error")
      end
    end
  end

  def self.set_trait(user_id, trait, value, with_flags = false)
    if user_id.nil?
      return nil
    end

    trait = {
      identity:    {identifier: user_id},
      trait_key:   normalize_key(trait),
      trait_value: value,
    }

    res_post = Flagsmith.client.post("/api/v1/traits/", form: trait.to_json)
    if res_post.status_code == 200
      res = Flagsmith.client.get("/api/v1/identities/?identifier=#{user_id}")
      if with_flags == true
        if res.status_code == 200
          flags_with_traits = Flag::FlagList::Trait.from_json(res.body)
          flags_and_traits_to_tuple(flags_with_traits)
        else
          raise Error.from_json(res.body, "error")
        end
      else
        if res.status_code == 200
          traits = Flag::FlagList::Trait.from_json(res.body)
          traits_to_tuple(traits)
        else
          raise Error.from_json(res.body, "error")
        end
      end
    else
      raise Error.from_json(res_post.body, "error")
    end
  end

  def self.get_traits(user_id)
    if user_id.nil?
      return nil
    end
    res = Flagsmith.client.get("/api/v1/identities/?identifier=#{user_id}")
    if res.status_code == 200
      traits = Flag::FlagList::Trait.from_json(res.body).traits
      traits_to_hash(traits)
    else
      raise Error.from_json(res.body, "error")
    end
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
    flag.feature_state_value
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

  def self.flags_and_traits_to_tuple(flags_with_traits)
    result = {flags: {} of String => Flagsmith::Flag, traits: {} of String => Flagsmith::Trait}

    flags_with_traits.flags.each do |flag|
      result[:flags][flag.feature.name] = flag
    end

    flags_with_traits.traits.each do |trait|
      result[:traits][trait.trait_key] = trait
    end
    result
  end

  def self.traits_to_tuple(flags_with_traits)
    result = {flags: {} of String => Flagsmith::Flag, traits: {} of String => Flagsmith::Trait}
    flags_with_traits.traits.each do |trait|
      result[:traits][trait.trait_key] = trait
    end
    result
  end
end

require "./flagsmith/**"
