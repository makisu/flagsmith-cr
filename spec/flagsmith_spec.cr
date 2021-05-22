require "./spec_helper"

describe Flagsmith do
  it "retrieves a chunk with identifier" do
    WebMock.stub(:get, "https://api.editmode.com/chunks/cnk_4e86a1382b66a76f9c57")
      .to_return(status: 200, body: File.read("spec/support/get_flags.json"), headers: {"Content-Type" => "application/json"})

    chunk = Editmode::Chunk.retrieve("cnk_4e86a1382b66a76f9c57")
    chunk.id.should eq("cnk_4e86a1382b66a76f9c57")
  end
end
