# frozen_string_literal: true
require 'spec_helper'

RSpec.describe "Key Word Relevance" do
  solr = RSolr.connect(url: ENV["SOLR_URL"])

  let(:response) { solr.get("search", params: { q: search_term, rows: 100 }) }
  let(:ids) { (response.dig("response", "docs") || []).map { |doc| doc.fetch("id") }.compact }

  describe "a search for" do

    context "epistemic injustice" do
      let(:search_term) { "epistemic injustice" }

      it "has expected results before a less relevant result" do
        expect(ids)
          .to include_items(%w[991024847639703811 991024847639703811 991033452769703811])
          .before(["991036813237303811"])
      end
    end
    context "Cabinet of Caligari" do
      let(:search_term) { "Cabinet of Caligari" }
      xit "has expected results before a less relevant result" do
        pending("results with just term Caligari not in title do not boost enough")
        expect(ids)
          .to include_items(%w[991020778949703811 991001777289703811 991027229969703811 991001812089703811 991036804904003811])
          .before(["991029142769703811"])
      end
    end

    context "Clarice Lispector" do
      let(:search_term) { "Clarice Lispector" }

      it "returns items about the author before books by the author" do
        expect(ids)
          .to include_items(%w[991036730479303811 991033955589703811 991036853181403811])
          .within_the_first(11)
      end
    end

    context "Basquiat" do
      let(:search_term) { "Basquiat" }

      it "returns relevant documents about Basquiat" do
        expect(ids)
          .to include_items(%w[991032082719703811 991013618249703811 991004084189703811 991002158879703811 991009887669703811])
          .within_the_first(10)
      end
    end


    context "crypto-jews" do
      let(:search_term) { "crypto-jews" }
      it "with hyphen has results about crypto-Jews and crypto-judaism above results about cryptography" do
        expect(ids)
          .to include_items(
            %w[991036813411403811 991036730245703811 991036421349703811 991032963459703811
              991025064439703811 991033710779703811 991036732155603811])
      end

      let(:search_term) { "crypto jews" }
      it "without hyphen has results about crypto-Jews and crypto-judaism above results about cryptography" do
        expect(ids)
          .to include_items(
            %w[991036813411403811 991036730245703811 991036421349703811 991032963459703811
              991025064439703811 991033710779703811 991036732155603811])
      end
    end

    context "Bioinformatics" do
      let(:search_term) { "Bioinformatics" }

      xit "returns more recent results before older results" do
        pending("Journal Pub Dates are the start of the run, which penalizes many journals")
        expect(ids)
          .to include_items(
            %w[991036719384303811 991036792223603811 991036798582803811 991036700239703811])
          .within_the_first(20)
      end
    end

    context "Denmark Vesey" do
      let(:search_term) { "Denmark Vesey" }
      it "returns a mix of primary and secondary sources" do
        expect(ids)
          .to include_items(
            %w[991006931909703811 991029916219703811 991024765709703811 991003742459703811]
          )
          .within_the_first(15)
      end
    end

    context "Contingent labor" do
      let(:search_term) { "Contingent labor" }
      it "returns recent results as more relevant" do
        # TODO:
        # * Check why items is  not found within first 10 results anymore.
        # * Check if it's OK that items not found within first 10 results.
        expect(ids)
          .to include_items(
            %w[991002132979703811 991024521489703811 991026169729703811]
            # 991030027489703811 removed as metadata does not match
          )
          .within_the_first(11)
      end
    end

    context "Audio signal processing" do
      let(:search_term) { "Audio signal processing" }
      it "returns relevant results" do
        expect(ids)
          .to include_items(%w[991011656609703811 991036792442803811 991036798461503811])
          .within_the_first(15)
      end
    end

    context "political polarization" do
      let(:search_term) { "political polarization" }
      it "returns relevant results" do
        expect(ids)
          .to include_items(
            %w[991009537899703811 991020291669703811 991010670569703811 991020302469703811]
            )
          .within_the_first(10)
      end
    end

    context "musical searching" do
      let(:search_term) { "c# min" }
      it "returns results about c sharp minor" do
        expect(ids)
            .to include_items(
              %w[991001795629703811 991001879639703811 991022362639703811]
              )
            .within_the_first(10)
      end
      let(:search_term) { "c sharp min" }
      it "returns results about c sharp minor" do
        expect(ids)
          .to include_items(
            %w[991001795629703811 991001879639703811 991022362639703811]
            )
          .within_the_first(10)
      end
    end
  end
end
