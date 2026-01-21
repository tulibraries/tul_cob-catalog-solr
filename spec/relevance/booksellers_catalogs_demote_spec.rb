# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Booksellers catalogs demotion" do
  solr = RSolr.connect(url: ENV["SOLR_URL"])

  let(:docs) do
    [
      {
        id: "BOOST_NORMAL",
        title_t: ["booksellerdemote control"],
        text: ["booksellerdemote"],
        format: ["Book"],
        library_facet: ["MAIN"],
        record_creation_date: ["20250101"],
        record_update_date: ["20250101"],
      },
      {
        id: "BOOST_BOOKSELLER",
        title_t: ["booksellerdemote demoted"],
        text: ["booksellerdemote"],
        format: ["Book"],
        library_facet: ["MAIN"],
        record_creation_date: ["20250101"],
        record_update_date: ["20250101"],
        boost_txt: ["inverse_boost_bookseller"],
      },
    ]
  end

  before do
    solr.add(docs)
    solr.commit
  end

  after do
    solr.delete_by_id(docs.map { |doc| doc[:id] })
    solr.commit
  end

  it "ranks inverse bookseller records lower in search handler" do
    response = solr.get("search", params: { q: "*:*", fq: "id:BOOST_*", rows: 5 })
    ids = response.dig("response", "docs")&.map { |doc| doc["id"] } || []

    expect(ids).to include_items(["BOOST_NORMAL"]).before(["BOOST_BOOKSELLER"])
  end

  it "ranks inverse bookseller records lower in single_quoted_search handler" do
    response = solr.get("single_quoted_search", params: { q: "*:*", fq: "id:BOOST_*", rows: 5 })
    ids = response.dig("response", "docs")&.map { |doc| doc["id"] } || []

    expect(ids).to include_items(["BOOST_NORMAL"]).before(["BOOST_BOOKSELLER"])
  end
end
