module ModelHelpers
  module Pagination
    def self.included(base)
      base.extend(ClassMethods)
    end

    public

    module ClassMethods
      def default_per_page
        @@default_per_page ||= 25
      end

      def default_per_page=(value)
        @@default_per_page = value
      end
    end # ClassMethods

    def paginate_params
      {page: page, per_page: per_page}
    end

    def page
      @page.presence || 1
    end

    def page=(value)
      @page = value
    end

    def per_page
      @per_page.presence || self.class.default_per_page
    end

    def per_page=(value)
      @per_page = value
    end

  end
end
