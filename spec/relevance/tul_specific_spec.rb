# frozen_string_literal: true

require "spec_helper"

RSpec.describe "some faceted queries." do
  solr = RSolr.connect(url: ENV["SOLR_URL"])
  let(:docs) { response.dig("response", "docs") || [] }
  let(:ids) { docs.map { |doc| doc.fetch("id") }.compact }

  context "a faceted search for Presser Listening Library " do
    let(:response) { solr.get("search", params: {
      fq: ["{!term f=library_facet}Presser Listening Library"],
      "rows": 50,
    })}

    it "has results with another library before before results only at presser" do
      expect(ids)
        .to include_items(%w[991025170559703811 991012972279703811 991036165169703811])
        .before(["991034751269703811"])
    end
  end
end
