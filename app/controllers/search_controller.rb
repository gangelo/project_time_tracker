class SearchController < ApplicationController
  before_action :authenticate_user!

  attr_accessor :search_criteria

  def index
    @search_criteria = SearchCriteria.new
  end

  def search
    paginate_params = { page: params[:page].presence || 1, per_page: params[:per_page] }
    @search_criteria = SearchCriteria.new(search_params.merge(paginate_params), current_user)
    @search_criteria.valid?
    render :index
  end

  private

  def search_params
    #params[:search_criteria][:search_attributes] ||= {}
    #params.require(:search_criteria).permit(:search_string, :search_option, search_attributes: [:id, :attribute_name])
    params.require(:search_criteria).permit(:search_string, :search_option)
  end
end
