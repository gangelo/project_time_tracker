class SearchCriteria
  extend ActiveModel::Callbacks
  define_model_callbacks :initialize, only: :after

  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  include ModelHelpers::Pagination

  after_initialize :action_after_initialize
  after_validation :clear_search_string

  DEFAULT_SEARCH_OPTION = 'show_all'.freeze

  attr_accessor :search_string
  attr_accessor :search_option

  validates_presence_of :search_string, unless: :show_all?
  validates_presence_of :search_option

  def initialize(attributes = {}, search_option = DEFAULT_SEARCH_OPTION)
    search_option = DEFAULT_SEARCH_OPTION if search_option.blank?
    @search_string = ""
    @search_option ||= DEFAULT_SEARCH_OPTION

    super attributes

    self.class.default_per_page = 15

    run_callbacks :initialize do; end
  end

  def attributes
    { 'search_string' => search_string, 'search_option' => search_option, 'page' => paginate_params[:page], 'per_page' => paginate_params[:per_page] }
  end

  def show_all?
    search_option == 'show_all'
  end

  protected

  def action_after_initialize
  end

  def clear_search_string
    search_string.clear unless search_string.blank?
  end
end
