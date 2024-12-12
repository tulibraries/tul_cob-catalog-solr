# frozen_string_literal: true
require "spec_helper"
require "pry"

RSpec.describe "Facet searches" do
  solr = RSolr.connect(url: ENV["SOLR_URL"])
  let(:per_page) { 10 }

  field = "subject_topic_facet"
  query = "Women — Netherlands — History"

  let(:response_uppercase) { solr.get("search", params: { fq: "#{field}:'#{query.upcase}'", rows: per_page }) }
  let(:response_lowercase) { solr.get("search", params: { fq: "#{field}:'#{query.downcase}'", rows: per_page }) }

  context "facet search results are case insensitive" do
    it "returns the same number of results" do
      binding.pry
      expect(response_uppercase['response']['numFound']).to eq(response_lowercase['response']['numFound'])    
    end
  end
end


