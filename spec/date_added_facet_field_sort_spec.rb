# frozen_string_literal: true
require "spec_helper"

RSpec.describe "sorting by date_added_facet field"do
  solr = RSolr.connect(url: ENV["SOLR_URL"])

  it "sorting asc reverses values when sorting desc" do

     # Set of ids of records that have multiple values in their date_added_facet field.
     ids = [
       "991031620059703811",
       "991036955068203811",
     ]

     resp_desc = solr.get("search", params: { fq: "id:" + ids.join(" "), sort: "date_added_facet desc" })
     resp_asc = solr.get("search", params: { fq: "id:" + ids.join(" "), sort: "date_added_facet asc" })

     ids_desc = resp_desc.dig("response", "docs").map { |d| d["id"] } 
     ids_asc = resp_asc.dig("response", "docs").map { |d| d["id"] } 

     expect(ids_desc).to include_items(ids)
     expect(ids_asc).to include_items(ids)

     expect(ids_desc).to eq(ids_asc.reverse)
  end

end
