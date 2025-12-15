# frozen_string_literal: true

require "spec_helper"

# This spec relies on the contents of spec/fixtures/presser_v2.xml.
# That file contains 5 records each with the exact same field values except for HLDb and id.
RSpec.describe "Describe library boosting config" do
  solr = RSolr.connect(url: ENV["SOLR_URL"])
  let(:docs) { response.dig("response", "docs") || [] }

  context "a title search for items at PRESSER or MAIN " do
    let(:response) { solr.get("search", params: { q: "title:PRESSER Spec Title" }) }

    it "returns a doc located in MAIN as the first result" do
      expect(docs.first["id"]).to match(/^MAIN/)
    end

    it "returns a doc located in MAIN as the second result" do
      expect(docs[1]["id"]).to match(/^MAIN/)
    end

    it "returns a doc located in PRESSER as the last result" do
      expect(docs.last["id"]).to match(/^PRESSER/)
    end
  end
end
