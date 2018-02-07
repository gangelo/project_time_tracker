#require 'search_skill'
#require 'search_skills_creator'
#require 'model_helpers_pagination'
#require 'model_helpers_transform_to_attributes'
#require 'skills_search_string'

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

  DEFAULT_SEARCH_OPTION = 'email'.freeze

  attr_accessor :search_string
  attr_accessor :search_option
  attr_accessor :users

  validates_presence_of :search_string
  validates_presence_of :search_option

  def initialize(attributes = {}, user = nil, search_option = DEFAULT_SEARCH_OPTION)
    raise ArgumentError if search_option.blank?
    raise ArgumentError unless ['email', 'id', 'user_name'].include?(search_option)
    @user = user
    @users = User.none
    @search_string = ""
    @search_option ||= DEFAULT_SEARCH_OPTION

    super attributes

    self.class.default_per_page = 15

    run_callbacks :initialize do; end
  end

  def attributes
    { 'search_string' => search_string, 'search_option' => search_option, 'page' => paginate_params[:page], 'per_page' => paginate_params[:per_page] }
  end

  protected

  def action_after_initialize
    #@user_profiles = has_search_skills? ? UserProfile.find_by_skills_with_paginate(valid_search_skills, paginate_params, @user) : @user_profiles.paginate(paginate_params)
    #@users = User.where("users.:search_option LIKE :search_string",
    #                    search_option: "%#{sanitize_sql_like(search_option)}%",
    #                    search_string: "%#{search_string}%")

    # Note: the below will not work for anything but text searches; if casting
    # is involved, we'll have to go with something non-database agnostic
    # (See above).
    option = User.arel_table[search_option]
    @users = User.where(option.matches("%#{search_string}%"))
  end

  private

  def clear_search_string
    search_string.clear unless search_string.blank?
  end
end
