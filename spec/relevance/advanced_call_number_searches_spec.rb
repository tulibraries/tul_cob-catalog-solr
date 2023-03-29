# frozen_string_literal: true
require "spec_helper"

RSpec.describe "Advanced Searches Using Call Number" do
  solr = RSolr.connect(url: ENV["SOLR_URL"])
  let(:query) { "_query_:{!edismax qf=alma_mms_t}#{mms_id} AND _query_:{!edismax qf=call_number_t}#{call_number}"}

  let(:response) { solr.get("select", params: { q: query }) }

  let(:ids) { (response.dig("response", "docs") || []).map { |doc| doc.fetch("id") }.compact }


  context "search starts with ML"  do
    let(:mms_id) { "991003128809703811" }
    let(:call_number) { "ML*" }

    it "returns a doc with the specified mms_id" do
      expect(ids).to eq(["991003128809703811"])
    end
  end

  context "search starts with ML128"  do
    let(:mms_id) { "991003128809703811" }
    let(:call_number) { "ML128*" }

    it "value a doc with the specified mms_id" do
      expect(ids).to eq(["991003128809703811"])
    end
  end

  context "value starts with ML128."  do
    let(:mms_id) { "991003128809703811" }
    let(:call_number) { "ML128.*" }

    it "returns a doc with the specified mms_id" do
      expect(ids).to eq(["991003128809703811"])
    end
  end

  context "value starts with ML128.A"  do
    let(:mms_id) { "991003128809703811" }
    let(:call_number) { "ML128.*" }

    it "returns a doc with the specified mms_id" do
      expect(ids).to eq(["991003128809703811"])
    end
  end

  context "value starts with ML128.A T48*"  do
    let(:mms_id) { "991003128809703811" }
    let(:call_number) { "\"ML128.A4 T48*\"" }

    it "returns a doc with the specified mms_id" do
      expect(ids).to eq(["991003128809703811"])
    end
  end

  context "value is ML128.A4 T48 1960 "  do
    let(:mms_id) { "991003128809703811" }
    let(:call_number) { "\"ML128.A4 T48 1960\"" }

    it "returns a doc with the specified mms_id" do
      expect(ids).to eq(["991003128809703811"])
    end
  end

  context "value starts with partial ML128.A4 T48 "  do
    let(:mms_id) { "991003128809703811" }
    let(:call_number) { "\"ML128.A4 T48*\"" }

    it "returns a doc with the specified mms_id" do
      expect(ids).to eq(["991003128809703811"])
    end
  end

  context "value contains 1960 "  do
    let(:mms_id) { "991003128809703811" }
    let(:call_number) { "*1960*" }

    it "returns a doc with the specified mms_id" do
      expect(ids).to eq(["991003128809703811"])
    end
  end

  context "value contains 1960 "  do
    let(:mms_id) { "991003128809703811" }
    let(:call_number) { "*1960*" }

    it "returns a doc with the specified mms_id" do
      expect(ids).to eq(["991003128809703811"])
    end
  end
end

