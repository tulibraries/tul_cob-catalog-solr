# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Title stopword search" do
  solr = RSolr.connect(url: ENV["SOLR_URL"])

  let(:response) do
    solr.get("search", params: {
      q: "Handbook on Autoethnography",
      qf: "${title_qf}",
      pf: "${title_pf}",
      rows: 20
    })
  end

  let(:titles) do
    (response.dig("response", "docs") || []).filter_map do |doc|
      doc["title_statement_display"]&.join(" ")
    end
  end

  it "finds Handbook of autoethnography" do
    expect(titles).to include(a_string_matching(/Handbook of autoethnography/i))
  end
end
