module Otis
  module Generator
    class CLI < Thor
      include Thor::Actions
      argument :name

      def self.source_root
        File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      #TODO: make it generate a simples structure without the WSDL
      desc "generate NAME", "Generates gem structure based on a WSDL file"
      method_option :wsdl, :aliases => "-w", :desc => "Input WSDL to be used as reference"
      option :wsdl
      def generate
        n = name
        name = n.chomp("/") # remove trailing slash if present
        unless options[:wsdl]
          puts "You did not provide any WSDL file. Sorry, I can't guess the structure of the webservice without it!"
          puts "Bye."
          exit
        end
        routes = routes(options[:wsdl])

        generate_soap(name, routes)

        namespaced_path = name.tr('-', '/')
        target = File.join(Dir.pwd, name)

        constant_name = constantize(name)
        constant_array = constant_name.split('::')
        git_user_name = `git config user.name`.chomp
        git_user_email = `git config user.email`.chomp
        opts = {
          :name            => name,
          :models          => routes.keys,
          :namespaced_path => namespaced_path,
          :constant_name   => constant_name,
          :constant_array  => constant_array,
          :author          => git_user_name.empty? ? "TODO: Write your name" : git_user_name,
          :email           => git_user_email.empty? ? "TODO: Write your email address" : git_user_email,
          :test            => options[:test]
        }
        gemspec_dest = File.join(target, "#{name}.gemspec")
        template(File.join("newgem/Gemfile.tt"),               File.join(target, "Gemfile"),                             opts)
        template(File.join("newgem/Rakefile.tt"),              File.join(target, "Rakefile"),                            opts)
        template(File.join("newgem/LICENSE.txt.tt"),           File.join(target, "LICENSE.txt"),                         opts)
        template(File.join("newgem/README.md.tt"),             File.join(target, "README.md"),                           opts)
        template(File.join("newgem/gitignore.tt"),             File.join(target, ".gitignore"),                          opts)
        template(File.join("newgem/newgem.gemspec.tt"),        gemspec_dest,                                             opts)
        template(File.join("newgem/lib/newgem.rb.tt"),         File.join(target, "lib/#{namespaced_path}.rb"),           opts)
        template(File.join("newgem/lib/newgem/version.rb.tt"), File.join(target, "lib/#{namespaced_path}/version.rb"),   opts)

        template(File.join("newgem/rspec.tt"),               File.join(target, ".rspec"),                              opts)
        template(File.join("newgem/spec/spec_helper.rb.tt"), File.join(target, "spec/spec_helper.rb"),                 opts)
        template(File.join("newgem/spec/newgem_spec.rb.tt"), File.join(target, "spec/#{namespaced_path}/#{namespaced_path}_spec.rb"),     opts)

        Dir.chdir(target) { `git init`; `git add .` }
      end

      private
      def generate_soap(name, routes)
        target = File.join(Dir.pwd, name)
        opts = {
          name: name,
          routes: Otis::Generator::MapPresenter.new(routes)
        }
        # Generate the map
        template(File.join("newgem/lib/newgem/map.rb.tt"), File.join(target, "lib/#{name}/map.rb"), opts)
        # Generate the models
        routes.each_pair do |file_name, class_name|
          template(File.join("newgem/lib/newgem/model.rb.tt"), File.join(target, "lib/#{name}/#{file_name.to_s}.rb"), {klass: class_name, name: constantize(name)})
        end

      end

      def routes(wsdl)
        #TODO: Make it break nicely when the file is not found.
        routes = {}
        keys = Savon.client(wsdl: "./#{wsdl}").operations
        keys.each {|name| routes[name] = constantize(name.to_s)}
        routes
      end

      def constantize(name)
        constant_name = name.split('_').map{|p| p[0..0].upcase + p[1..-1] }.join
        constant_name.split('-').map{|q| q[0..0].upcase + q[1..-1] }.join('::') if constant_name =~ /-/
        constant_name
      end
    end
  end
end