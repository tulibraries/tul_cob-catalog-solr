# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Searches with quotes in the terms" do
  let(:solr)  { RSolr.connect(url: ENV["SOLR_URL"]) }
  let(:term) { "" }
  let(:quoted_term) { "\"#{term}\"" }
  let(:solr_path) { "search" }
  let(:extra_params) { {} }
  let(:quoted_results) {
    solr.get(solr_path, params: { q: quoted_term  }
      .merge(extra_params))
  }
  let(:non_quoted_results) {
    solr.get("search", params: { q: term  }
      .merge(extra_params))
  }
  let(:count_quoted_results) { quoted_results["response"]["numFound"] }
  let(:count_not_quoted_results) { non_quoted_results["response"]["numFound"] }


  context "quoted queries with more than one term" do
    let(:term) { "book readers" }

    it "returns less results when quoted" do
      expect(count_quoted_results).to be < count_not_quoted_results
    end
  end

  context "quoted queries with one term" do
    let(:term) { "readers" }
    # In the application with override this path dynamically.
    let(:solr_path) { "single_quoted_search" }

    it "returns less results when quoted" do
      expect(count_quoted_results).to be < count_not_quoted_results
    end
  end


  context "title quoted query with one term" do
    let(:term) { "readers" }
    let(:extra_params) {
      { qf: "${title_qf}", pf: "${title_pf}",
        fl: "marc_display_raw", rows: 49 }
    }
    # In the application with override this path dynamically.
    let(:solr_path) { "single_quoted_search" }

    it "returns less results when quoted" do
      expect(count_quoted_results).to be < count_not_quoted_results
    end

    it "only returns results that contain the searched term" do
      all_results_contain_search_term = quoted_results["response"]["docs"].all? do |doc|
        doc["marc_display_raw"]&.match /#{term }/i
      end
      expect(all_results_contain_search_term)
    end
  end

  context "title quoted query with multiple terms" do
    let(:term) { "Book readers" }
    let(:extra_params) { { qf: "${title_qf}", pf: "${title_pf}" } }

    it "returns less results when quoted" do
      expect(count_quoted_results).to be < count_not_quoted_results
    end
  end

  context "subject quoted query with one term" do
    let(:term) { "chemically" }
    let(:extra_params) { { qf: "${subject_qf}", pf: "${subject_pf}" } }
    # In the application with override this path dynamically.
    let(:solr_path) { "single_quoted_search" }

    it "returns less results when quoted" do
      expect(count_quoted_results).to be < count_not_quoted_results
    end
  end

  context "subject quoted query with multiple terms" do
    let(:term) { "ancient history" }
    let(:extra_params) { { qf: "${subject_qf}", pf: "${subject_pf}" } }

    it "returns less results when quoted" do
      expect(count_quoted_results).to be < count_not_quoted_results
    end
  end

  context "author quoted query with one term" do
    # This test doesn't work with all names in this test set.
    let(:term) { "William" }
    let(:solr_path) { "single_quoted_search" }
    let(:extra_params) { { qf: "${author_qf}", pf: "${author_pf}" } }

    it "returns less results when quoted" do
      expect(count_quoted_results).to be < count_not_quoted_results
    end
  end

  context "author quoted query with multiple terms" do
    let(:term) { "William Shakespeare" }
    let(:extra_params) { { qf: "${author_qf}", pf: "${author_pf}" } }

    it "returns less results when quoted" do
      expect(count_quoted_results).to be < count_not_quoted_results
    end
  end

end
