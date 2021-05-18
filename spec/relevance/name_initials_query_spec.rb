# frozen_string_literal: true
require "spec_helper"

RSpec.describe "name field queries" do
  solr = RSolr.connect(url: ENV["SOLR_URL"])

  context "with non spaced name initials" do
    it "selects initialed names" do
      resp = solr.get("search", params: { q: "t.s. eliot", qf: "${author_qf}", pf: "${author_pf}"})
      count = resp.dig("response", "numFound")
      #docs = resp.dig("response", "docs")

      expect(count).to eq(3)
    end
  end

  context "with spaced named initials" do
    it "it select all eliots but first 3 are the initialed ones" do
      resp = solr.get("search", params: { q: "t. s. eliot", qf: "${author_qf}", pf: "${author_pf}"})
      count = resp.dig("response", "numFound")
      #docs = resp.dig("response", "docs")

      expect(count).to eq(2)
    end
  end
end
