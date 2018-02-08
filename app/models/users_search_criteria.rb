class UsersSearchCriteria < SearchCriteria
  attr_accessor :users

  def initialize(attributes = {}, users = nil, search_option = DEFAULT_SEARCH_OPTION)
    super(attributes, search_option)
    raise ArgumentError unless ['email', 'show_all', 'user_name'].include?(search_option)
    @users = users

    super attributes

    #self.class.default_per_page = 15

    #run_callbacks :initialize do; end
  end

  def self.none
    UsersSearchCriteria.new({}, User.none)
  end

  #def attributes
  #  { 'search_string' => search_string, 'search_option' => search_option, 'page' => paginate_params[:page], 'per_page' => paginate_params[:per_page] }
  #end

  #def show_all?
  #  search_option == 'show_all'
  #end

  protected

  def action_after_initialize
    return User.none unless @users.nil?
    return User.none unless valid?
    # !!!WARNING This needs to be sanitized WARNING!!!

    #@users = User.where("users.:search_option LIKE :search_string",
    #                    search_option: "%#{sanitize_sql_like(search_option)}%",
    #                    search_string: "%#{search_string}%") # <= Sanitize this!!!

    if show_all?
      @users = User.order(:email).paginate(page: paginate_params[:page], per_page: paginate_params[:per_page])
    else
      @users = User.find_by_search_criteria_with_paginate(search_option, search_string, paginate_params)
    end

    # Note: the below will not work for anything but text searches; if casting
    # is involved, we'll have to go with something non-database agnostic
    # (See above).
    # !!!WARNING This needs to be sanitized WARNING!!!
    # option = User.arel_table[search_option]
    # @users = User.where(option.matches("%#{search_string}%"))
  end

  protected

  def clear_search_string
    # Override: we do not want the search_string cleared out after every search.
  end
end
