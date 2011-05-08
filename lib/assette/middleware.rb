require 'assette/server'

module Assette
  class Middleware
    def initialize(app, *args)
      @app = app
    end
    
    def call(env)
      if env['PATH_INFO'] == '/'
        return @app.call(env)
      end
      
      assette_resp = Assette::Server.call(env)
      if assette_resp[0] == 200
        assette_resp
      else
        @app.call(env)
      end
    end
  end
end