module Otis
  module Generator
    class MapPresenter
      def initialize(routes)
        @routes = routes
      end

      def to_s
        s = ''
        @routes.each_pair { |route, klass| s << ":#{route} => #{klass},\n" }
        s
      end
    end
  end
end