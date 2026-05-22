# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Stopword handling" do
  solr = RSolr.connect(url: ENV["SOLR_URL"])

  let(:response) do
    solr.get("search", params: {
      q: "Routledge handbook on epistemic injustice",
      qf: "${title_qf}",
      pf: "${title_pf}",
      rows: 5
    })
  end
  let(:ids) { (response.dig("response", "docs") || []).map { |doc| doc.fetch("id") }.compact }

  it "finds a title when the searched preposition differs from the indexed preposition" do
    expect(ids)
      .to include_items(%w[991032556509703811])
      .within_the_first(5)
  end
end
