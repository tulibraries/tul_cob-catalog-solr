# frozen_string_literal: true

require "spec_helper"

RSpec.describe "name field queries" do
  solr = RSolr.connect(url: ENV["SOLR_URL"])

  let(:expected_ids) { [
    "991037310799703811",
    "991002633159703811",
    "991020180379703811",
  ] }

  context "with non spaced name initials" do
    it "selects initialed names" do
      resp = solr.get("search", params: { q: "t.s. eliot", qf: "${author_qf}", pf: "${author_pf}" })
      count = resp.dig("response", "numFound")
      ids = resp.dig("response", "docs").map { |d| d["id"] }

      expect(ids).to include_items(expected_ids)
    end
  end

  context "with spaced named initials" do
    it "it select all eliots but first 3 are the initialed ones" do
      resp = solr.get("search", params: { q: "t. s. eliot", qf: "${author_qf}", pf: "${author_pf}" })
      count = resp.dig("response", "numFound")
      ids = resp.dig("response", "docs").map { |d| d["id"] }

      expect(ids).to include_items(expected_ids)
    end
  end
end
