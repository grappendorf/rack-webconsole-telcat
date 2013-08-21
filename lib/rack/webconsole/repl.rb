# encoding: utf-8
require 'multi_json'
require 'digest/sha1'

module Rack
  class Webconsole
    # {Repl} is a Rack middleware acting as a Ruby evaluator application.
    #
    # In a nutshell, it evaluates a string in a {Sandbox} instance stored in an
    # evil global variable. Then, to keep the state, it inspects the local
    # variables and stores them in an instance variable for further retrieval.
    #
    class Repl
      @@request = nil
      @@token   = nil

      class << self
        # Returns the autogenerated security token
        #
        # @return [String] the autogenerated token
        def token
          @@token
        end

        # Regenerates the token.
        def reset_token
          @@token = Digest::SHA1.hexdigest("#{rand(36**8)}#{Time.now}")[4..20]
        end

        # Returns the original request for inspection purposes.
        #
        # @return [Rack::Request] the original request
        def request
          @@request
        end

        # Sets the original request for inspection purposes.
        #
        # @param [Rack::Request] the original request
        def request=(request)
          @@request = request
        end
      end

      # Honor the Rack contract by saving the passed Rack application in an ivar.
      #
      # @param [Rack::Application] app the previous Rack application in the
      #   middleware chain.
      def initialize(app)
        @app = app
      end

      # Evaluates a string as Ruby code and returns the evaluated result as
      # JSON.
      #
      # It also stores the {Sandbox} state in a `$sandbox` global variable, with
      # its local variables.
      #
      # @param [Hash] env the Rack request environment.
      # @return [Array] a Rack response with status code 200, HTTP headers
      #   and the evaluated Ruby result.
      def call(env)
        status, headers, response = @app.call(env)

        req = Rack::Request.new(env)
        params = req.params

        return [status, headers, response] unless check_legitimate(req)

        $sandbox ||= Sandbox.new
        hash = Shell.eval_query params['query']
        response_body = MultiJson.encode(hash)
        headers = {}
        headers['Content-Type'] = 'application/json'
        headers['Content-Length'] = response_body.bytesize.to_s
        [200, headers, [response_body]]
      end

      private

      def check_legitimate(req)
#        req.post? && !Repl.token.nil? && req.params['token'] == Repl.token
        Rails.env.development?
      end
    end
  end
end