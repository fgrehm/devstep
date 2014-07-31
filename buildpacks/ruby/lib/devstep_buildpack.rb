$:.unshift File.expand_path("../../heroku-buildpack-ruby/lib", __FILE__)

require "language_pack"
require "language_pack/shell_helpers"
require "ruby_dev"

# Overwrite language pack detection to favor our own language pack
module LanguagePack
  # detects which language pack to use
  # @param [Array] first argument is a String of the build directory
  # @return [LanguagePack] the {LanguagePack} detected
  def self.detect(*args)
    Instrument.instrument 'detect' do
      Dir.chdir(args.first)

      # ORIGINAL CODE: pack = [ NoLockfile, Rails41, Rails4, Rails3, Rails2, Rack, Ruby ].detect do |klass|
      pack = [ RubyDev ].detect do |klass|
        klass.use?
      end

      return pack ? pack.new(*args) : nil
    end
  end
end
