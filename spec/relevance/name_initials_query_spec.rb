# frozen_string_literal: true
require "spec_helper"

RSpec.describe "name field queries" do
  solr = RSolr.connect(url: ENV["SOLR_URL"])

  context "with named initials" do
    it "should not matter if spaces are between name initials" do
      resp1 = solr.get("search", params: { q: "t.s. eliot", qf: "${author_qf}", pf: "${author_pf}"})
      resp2 = solr.get("search", params: { q: "t. s. eliot", qf: "${author_qf}", pf: "${author_pf}"})

      count1 = resp1.dig("response", "numFound")
      count2 = resp2.dig("response", "numFound")

      expect(count1).to eq(count2)
    end
  end
end
