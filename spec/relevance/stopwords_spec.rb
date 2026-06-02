# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Stopword handling" do
  solr = RSolr.connect(url: ENV["SOLR_URL"])

  let(:response) do
    solr.get("search", params: {
      q: query,
      qf: "${title_qf}",
      pf: "${title_pf}",
      rows: 5
    })
  end
  let(:docs) { response.dig("response", "docs") || [] }
  let(:ids) { docs.map { |doc| doc.fetch("id") }.compact }

  context "when a searched stopword differs from the indexed title" do
    let(:query) { "Routledge handbook on epistemic injustice" }

    it "finds the intended title within the first five results" do
      expect(ids)
        .to include_items(%w[991032556509703811])
        .within_the_first(5)
    end
  end

  context "when a title search includes creator and title terms" do
    let(:query) { "Martin game of thrones" }

    it "keeps the actual title within the first five results" do
      expect(ids)
        .to include_items(%w[991003637379703811])
        .within_the_first(5)
    end
  end
end
