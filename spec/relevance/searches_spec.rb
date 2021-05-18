# frozen_string_literal: true
require "spec_helper"

RSpec.describe "Searches" do
  solr = RSolr.connect(url: ENV["SOLR_URL"])

  let(:search_term) { search_terms.values.join(" ") }
  let(:per_page) { 1 }

  let(:response) { solr.get("search", params: { q: search_term, rows: per_page }) }
  let(:docs) { response.dig("response", "docs") || [] }

  context "search for Google" do
    let(:search_term) { "Google" }

    it "returns a document with Google in it's title" do
      title = docs.first["title_statement_display"].join
      expect(title).to eq("Google / Virginia Scott.")
    end
  end

  context "search an ID" do
    let(:search_term)  { "991032411489703811" }

    it "returns a document with that id" do
      id = docs.first["id"]
      expect(id).to eq("991032411489703811")
    end
  end


  context "search creator" do
    let(:search_term) { "Scott, Virginia A." }

    it "returns a document for that creator" do
      title = docs.first["title_statement_display"].join
      # First result will be the one that has "Virginia Scott" in title and in
      # creator fields (work_access_point field combines title and author).
      expect(title).to eq("Google / Virginia Scott.")
    end
  end

  context "search imprint" do
    let(:search_term) { "Westport, Conn. : Greenwood Press, 2008."
     }

    it "returns a document for that imprint" do
      title = docs.first["title_statement_display"].join
      expect(title).to eq("Google / Virginia Scott.")
    end
  end

  context "search series title" do
    let(:search_term) { "SupersonicBionicRobotVoodooPower" }

    it "returns a document with that series title" do
      title = docs.first["title_statement_display"].join
      expect(title).to eq("Google / Virginia Scott.")
    end
  end

  context "search content" do
    let(:search_term) { "OctagonOxygenAluminumIntoxicants" }

    it "returns a document with that specific content" do
      title = docs.first["title_statement_display"].join
      expect(title).to eq("Google / Virginia Scott.")
    end
  end

  context "search subject" do
    let(:search_term) { "ParamedicsFedExYourLegsWithEggs" }

    it "returns a document with that specific subject" do
      title = docs.first["title_statement_display"].join
      expect(title).to eq("Google / Virginia Scott.")
    end
  end

  context "search isbn" do
    let(:search_term) { "9780313351273" }

    it "returns a document with that specific isbn" do
      title = docs.first["title_statement_display"].join
      expect(title).to eq("Google / Virginia Scott.")
    end
  end

  context "search lccn" do
    let(:search_term) { "2008030541" }

    it "returns a document with that specific lccn" do
      title = docs.first["title_statement_display"].join
      expect(title).to eq("Google / Virginia Scott.")
    end
  end

  context "search term as colon" do
    let(:search_term) { "Religious liberty :the positive dimension : an address" }

    it "returns a document with that specific lccn" do
      title = docs.first["title_statement_display"].join
      expect(title).to eq("Religious liberty : the positive dimension : an address / by Franklin H. Littell at Doane College on April 26, 1966.")
    end
    end

  describe "searching with a creator name and title" do
    context "Martin Game Of Thrones" do
      let(:search_term) { "Martin Game of Thrones" }

      it "should return the book written by him and not a book about him" do
        title = docs.first["title_statement_display"].join
        expect(title).to eq("A game of thrones / George R.R. Martin.")
      end
    end
  end
end
