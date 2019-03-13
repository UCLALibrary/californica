# frozen_string_literal: true
class BrandingInfoController < ApplicationController
  respond_to :json
  def show
    @banner_info = CollectionBrandingInfo.where(collection_id: params[:id])[0]
    respond_with @banner_info
  end
end
