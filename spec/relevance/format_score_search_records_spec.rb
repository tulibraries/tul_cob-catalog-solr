# frozen_string_literal: true
require "spec_helper"
require "pry"

RSpec.describe "Searches with format set to 'Score' "do
  solr = RSolr.connect(url: ENV["SOLR_URL"])

  let(:per_page) { 20 }
  let(:response) { solr.get("search", params: { q: search_term, fq: "format:Score", rows: per_page }) }
  let(:records) do (response.dig("response", "docs") || []).map { |doc|
    { id: doc.fetch("id"), title: doc.fetch("title_statement_display").first } }
  end

  context "A composer and a score by that composer" do
    let(:search_term) { "Schumann lieder" }

    it "should return scores by that composer before returns anything else" do
      primary_records = [
        { id: "991030121769703811", title: "Samtliche Lieder fur singstimme und Klavier. Band 1. = Complete songs for voice and piano [Vol. 1] / Clara Schumann ; edited by Joachim Draheim, Brigitte Hoft." },
      ]

      secondary_records = [
        { id: "991037733379403811", title: "Two Schumann duets / English words by Laurence H. Davies ; [music by] Schumann." },
        { id: "991034563689703811", title: "Einsame Lieder : für Singstimme und Klavier : (1942/43) / Jürg Baur." },
        { id: "991014573789703811", title: "The Lieder anthology / edited by Virginia Saya and Richard Walters." },
        { id: "991014573849703811", title: "The Lieder anthology / edited by Virginia Saya and Richard Walters." },
        { id: "991034188249703811", title: "Transcriptions of famous Lieder / [Franz Liszt] ; compiled and edited by Teresa Escandón." },
      ]

      expect(records).to include_items(primary_records)
        .before(secondary_records)
    end


  end
end
