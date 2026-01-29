# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Stopword Handling" do
  solr = RSolr.connect(url: ENV["SOLR_URL"])

  let(:response) { solr.get("search", params: { q: search_term, rows: 20 }) }
  let(:ids) { (response.dig("response", "docs") || []).map { |doc| doc.fetch("id") }.compact }

  context "\"But is it art\"" do
    let(:search_term) { "But is it art" }

    it "finds the title even though most words are stopwords" do
      expect(ids)
        .to include_items(%w[991033609439703811])
        .within_the_first(10)
    end
  end

  context "\"Handbook on autoethnography\"" do
    let(:search_term) { "Handbook on autoethnography" }

    it "finds the title despite common stopwords" do
      expect(ids)
        .to include_items(%w[991039333886103811])
        .within_the_first(10)
    end
  end
end
