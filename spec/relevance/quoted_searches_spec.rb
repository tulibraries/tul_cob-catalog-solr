# frozen_string_literal: true
require "spec_helper"

RSpec.describe "Searches with quotes in the terms" do

    let(:solr)  { RSolr.connect(url: ENV["SOLR_URL"]) }
    let(:term) { "" }
    let(:quoted_term) { "\"#{term}\""}
    let(:solr_path) { "search" }
    let(:extra_params) { {} }
    let(:num_found_quoted) {
      results = solr.get(solr_path, params: { q: quoted_term  }
        .merge(extra_params))
      results["response"]["numFound"]
    }
    let(:num_found_not_quoted) {
      results = solr.get("search", params: { q: term  }
        .merge(extra_params))
      results["response"]["numFound"]
    }


  context "quoted queries with more than one term" do
    let(:term) { "book readers"}

    it "quoted query to have less results than regular query" do
      expect(num_found_quoted).to be < num_found_not_quoted
    end
  end

  context "quoted queries with one term" do
    let(:term) { "readers" }
    # In the application with override this path dynamically.
    let(:solr_path) { "single_quoted_search" }

    it "quoted query to have less results than regular query" do
      expect(num_found_quoted).to be < num_found_not_quoted
    end
  end


  context "title quoted query with one term" do
    let(:term) { "readers" }
    let(:extra_params) { { qf: "${title_qf}", pf: "${title_pf}" }}
    # In the application with override this path dynamically.
    let(:solr_path) { "single_quoted_search" }

    it "quoted query to have less results than regular query" do
      expect(num_found_quoted).to be < num_found_not_quoted
    end
  end

  context "title quoted query with multiple terms" do
    let(:term) { "Book readers" }
    let(:extra_params) { { qf: "${title_qf}", pf: "${title_pf}" }}

    it "quoted query to have less results than regular query" do
      expect(num_found_quoted).to be < num_found_not_quoted
    end
  end

  context "subject quoted query with one term" do
    let(:term) { "chemically" }
    let(:extra_params) { { qf: "${subject_qf}", pf: "${subject_pf}" }}
    # In the application with override this path dynamically.
    let(:solr_path) { "single_quoted_search" }

    it "quoted query to have less results than regular query" do
      expect(num_found_quoted).to be < num_found_not_quoted
    end
  end

  context "subject quoted query with multiple terms" do
    let(:term) { "ancient history" }
    let(:extra_params) { { qf: "${subject_qf}", pf: "${subject_pf}" }}

    it "quoted query to have less results than regular query" do
      expect(num_found_quoted).to be < num_found_not_quoted
    end
  end

  context "author quoted query with one term" do
    # This test doesn't work with all names in this test set.
    let(:term) { "William" }
    let(:solr_path) { "single_quoted_search" }
    let(:extra_params) { { qf: "${author_qf}", pf: "${author_pf}" }}

    it "quoted query to have less results than regular query" do
      expect(num_found_quoted).to be < num_found_not_quoted
    end
  end

  context "author quoted query with multiple terms" do
    let(:term) { "William Shakespeare" }
    let(:extra_params) { { qf: "${author_qf}", pf: "${author_pf}" }}

    it "quoted query to have less results than regular query" do
      expect(num_found_quoted).to be < num_found_not_quoted
    end
  end

end


