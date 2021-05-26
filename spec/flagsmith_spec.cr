require "./spec_helper"

describe Flagsmith do
  it "gets flags" do
    WebMock.stub(:get, "https://api.flagsmith.com/api/v1/flags/")
      .to_return(status: 200, body: File.read("spec/support/get_flags.json"), headers: {"Content-Type" => "application/json"})
      
      flags = Flagsmith.get_flags()
      flags.size.should eq(3)
  end

  it "gets traits" do
    WebMock.stub(:get, "https://api.flagsmith.com/api/v1/identities/?identifier=rio")
      .to_return(status: 200, body: File.read("spec/support/get_traits.json"), headers: {"Content-Type" => "application/json"})
      
      traits = Flagsmith.get_traits("rio")
      if traits
        traits["id"].id.should eq(9759231)
      end
  end

  it "set traits" do
    WebMock.stub(:post, "https://api.flagsmith.com/api/v1/traits/")
      .to_return(status: 200, body: File.read("spec/support/set_trait.json"), headers: {"Content-Type" => "application/json"})
      
      traits = Flagsmith.set_trait("nonexistent_user","testtest", 123)
      if traits
        traits["testtest"].id.should eq(10058951)
      end
  end

  it "returns bool for feature_enabled?" do
    WebMock.stub(:get, "https://api.flagsmith.com/api/v1/flags/identities/?identifier=rio")
      .to_return(status: 200, body: File.read("spec/support/get_flags_featured_enabled.json"), headers: {"Content-Type" => "application/json"})
      
      bool = Flagsmith.feature_enabled?("signup_fields", "rio")
      bool.should eq(true)
  end

  it "returns a value for get_value" do
    WebMock.stub(:get, "https://api.flagsmith.com/api/v1/flags/identities/?identifier=rio")
      .to_return(status: 200, body: File.read("spec/support/get_flags_featured_enabled.json"), headers: {"Content-Type" => "application/json"})
      
      value = Flagsmith.get_value("signup_fields", "rio")
      value.should eq (90)
  end

end


