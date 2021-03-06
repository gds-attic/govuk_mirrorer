module GovukMirrorer
  class Configurer
    class NoRootUrlSpecifiedError < Exception ; end

    def self.run(args)
      require 'optparse'
      options = {
        :site_root => ENV['MIRRORER_SITE_ROOT'],
        :request_interval => 0.1,
      }
      OptionParser.new do |o|
        o.banner = "Usage: govuk_mirrorer [options]"

        o.on('--site-root URL',
             "Base URL to mirror from",
             "  falls back to MIRRORER_SITE_ROOT env variable") {|root| options[:site_root] = root }
        o.on('--request-interval INTERVAL', Float,
             "Specify the delay between requests in seconds",
             "  defaults to 0.1") {|interval| options[:request_interval] = interval }

        o.separator "Logging:"
        o.on('--logfile FILE', "Enable logging to a file") { |file| options[:log_file] = file }
        o.on('--syslog [FACILITY]',
             "Enable logging to syslog",
             "  optionally override the default facility (local3)") do |facility|
          options[:syslog] = facility || "local3"
        end
        o.on('--loglevel LEVEL', 'DEBUG/INFO/WARN/ERROR, it defaults to INFO') do |level|
          options[:log_level] = level
        end
        o.on('-v', '--verbose', 'sets loglevel to DEBUG') { |level| options[:log_level] = 'DEBUG' }

        o.separator ""
        o.on('-h', '--help') { puts o; exit }
        o.parse!(args)
      end

      # Error if site_root nil or blank
      raise NoRootUrlSpecifiedError if options[:site_root].nil? or options[:site_root].empty?

      options
    end
  end
end
