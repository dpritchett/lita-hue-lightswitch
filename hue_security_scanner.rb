require "hue_security_scanner/version"

require 'hue'
require 'logger'
require 'text_me'

module HueSecurityScanner
  def self.scan!
    Scanner.new.scan!
  end

  class Scanner
    def initialize
      begin
        @client = Hue::Client.new
      rescue Curl::Err::SSLCACertificateError => err
        oops(err.message) if rand(1..20) == 5
        abort "Hue's SSL Cert is expired."
      rescue Curl::Err::HostResolutionError => err
        oops err.message
        abort "I give up!"
      end
    end

    def logger
      Logger.new(STDOUT)
    end

    attr_reader :client

    def securities_name
      'Outside'
    end

    def securities
      client.groups.select { |g| g.name == securities_name }.first
    end

    def unreachables
      securities.lights.reject(&:reachable?)
    end

    def reachables
      securities.lights.select(&:reachable?)
    end

    def offs
      reachables.reject(&:on?)
    end

    def ons
      reachables.select(&:on?)
    end

    def names(lights)
      lights.map(&:name).join(", ")
    end

    def scan!
      if securities.nil?
        oops "No security lights exist!"
        abort
      end

      if securities.all?(&:on?)
        logger.info "All clear! [#{names(ons)}] are all on."
      else
        if unreachables.any?
          oops "Unreachable security lights! [#{names(unreachables)}]"
        end

        if offs.any?
          oops "Inactive security lights! [#{names(offs)}]"
        end
      end
    end

    def oops(message)
      logger.error message

      begin
        send_text message
      rescue Faraday::ConnectionFailed => err
        logger.error err.message
      end
    end

    def send_text(message)
      TextMe.text_me! message
    end
  end
end
