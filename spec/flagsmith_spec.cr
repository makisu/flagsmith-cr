require "./spec_helper"

describe Flagsmith do
  it "gets flags" do
    WebMock.stub(:get, "https://api.flagsmith.com/api/v1/flags/")
      .to_return(status: 200, body: File.read("spec/support/get_flags.json"), headers: {"Content-Type" => "application/json"})
      
      flags = Flagsmith.get_flags()
      flags["feature_one"].id.should eq(8590)
      flags["feature_one"].feature_state_value.should eq(nil)
      flags["feature_one"].feature.name.should eq("feature_one")
  end

  it "gets flags with specific user" do
    WebMock.stub(:get, "https://api.flagsmith.com/api/v1/identities/?identifier=maria")
      .to_return(status: 200, body: File.read("spec/support/get_flags_with_user.json"), headers: {"Content-Type" => "application/json"})
      
      flags = Flagsmith.get_flags("maria")
      flags["signup_fields"].id.should eq(48289)
      flags["signup_fields"].feature_state_value.should eq("name")
      flags["signup_fields"].feature.name.should eq("signup_fields")
  end

  it "gets traits" do
    WebMock.stub(:get, "https://api.flagsmith.com/api/v1/identities/?identifier=maria")
      .to_return(status: 200, body: File.read("spec/support/get_traits.json"), headers: {"Content-Type" => "application/json"})
      
      traits = Flagsmith.get_traits("maria")
      if traits
       traits["font"].id.should eq(10089618)
       traits["font"].trait_key.should eq("font")
       traits["font"].trait_value.should eq("arial")
      end
  end

  it "set traits (with_flags is false)" do
    WebMock.stub(:post, "https://api.flagsmith.com/api/v1/traits/")
      .to_return(status: 200, body: File.read("spec/support/set_traits.json"), headers: {"Content-Type" => "application/json"})
    WebMock.stub(:get, "https://api.flagsmith.com/api/v1/identities/?identifier=john")
    .to_return(status: 200, body: File.read("spec/support/set_traits_false.json"), headers: {"Content-Type" => "application/json"})
      
      traits = Flagsmith.set_trait("john","height", "tall", false)
      if traits
        traits[:traits]["height"].id.should eq (10117563)
        traits[:traits]["height"].trait_key.should eq("height")
        traits[:traits]["height"].trait_value.should eq("tall")
      end
  end

  it "set traits (with_flags is true)" do
    WebMock.stub(:post, "https://api.flagsmith.com/api/v1/traits/")
      .to_return(status: 200, body: File.read("spec/support/set_traits_true.json"), headers: {"Content-Type" => "application/json"})
    WebMock.stub(:get, "https://api.flagsmith.com/api/v1/identities/?identifier=john")
    .to_return(status: 200, body: File.read("spec/support/set_traits_true.json"), headers: {"Content-Type" => "application/json"})
      
      flags_with_traits = Flagsmith.set_trait("john","font", "arial", true)
      if flags_with_traits
          flags_with_traits[:flags]["signup_fields"].id.should eq(48289)
          flags_with_traits[:flags]["signup_fields"].feature.name.should eq("signup_fields")
          flags_with_traits[:flags]["signup_fields"].feature_state_value.should eq("password")

          flags_with_traits[:traits]["color"].id.should eq (10104526)
          flags_with_traits[:traits]["color"].trait_key.should eq("color")
          flags_with_traits[:traits]["color"].trait_value.should eq("red")
      end
  end

  it "returns bool for feature_enabled?" do
    WebMock.stub(:get, "https://api.flagsmith.com/api/v1/identities/?identifier=rio")
      .to_return(status: 200, body: File.read("spec/support/get_flags_featured_enabled.json"), headers: {"Content-Type" => "application/json"})
      
      bool = Flagsmith.feature_enabled?("signup_fields", "rio")
      bool.should eq(true)
  end

  it "returns a value for get_value" do
    WebMock.stub(:get, "https://api.flagsmith.com/api/v1/identities/?identifier=maria")
      .to_return(status: 200, body: File.read("spec/support/get_flags_featured_enabled.json"), headers: {"Content-Type" => "application/json"})
      
      value = Flagsmith.get_value("signup_fields", "maria")
      value.should eq ("name")
  end

end


