# frozen_string_literal: true
require "rails_helper"

RSpec.describe CsvImportsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/csv_imports").to route_to("csv_imports#index")
    end

    it "routes to #new" do
      expect(get: "/csv_imports/new").to route_to("csv_imports#new")
    end

    it "routes to #preview" do
      expect(post: "/csv_imports/preview").to route_to("csv_imports#preview")
    end

    it "routes to #create" do
      expect(post: "/csv_imports").to route_to("csv_imports#create")
    end

    it "routes to #show" do
      expect(get: "/csv_imports/1").to route_to("csv_imports#show", id: "1")
    end
  end
end
