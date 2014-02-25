module Otis
  module Generator
    class RoutesPresenter
      def initialize(routes)
        @routes = routes
      end

      def endpoints
        @routes.keys
      end

      def map
        s = ''
        @routes.each_pair { |route, klass| s << ":#{route} => #{klass},\n" }
        s
      end
    end
  end
end