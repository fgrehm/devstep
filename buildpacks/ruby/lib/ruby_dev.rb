require 'language_pack/ruby'

# Force our custom metadata dir to be used
DEVSTEP_METADATA = "#{ENV['HOME']}/.metadata"
LanguagePack::Metadata.send(:remove_const, :FOLDER)
LanguagePack::Metadata.const_set(:FOLDER, DEVSTEP_METADATA)

class LanguagePack::RubyDev < LanguagePack::Ruby
  def initialize(build_path, cache_path=nil)
    # Prevent metadata object from using the cache by forcing a nil here
    super(build_path, nil)
    # TODO: Find out how can we use the cache for rubies
  end

  def self.use?
    # FORCED_BUILDPACKS means we specified a buildpack along with the image
    # builder, so lets make sure we really use it regardless if it was
    # detected. This usually happen during the bootstrap process
    super or (ENV['FORCED_BUILDPACKS'] == '1')
  end

  def compile
    instrument 'ruby_dev.compile' do
      # check for new app at the beginning of the compile
      new_app?
      Dir.chdir(build_path)
      # remove_vendor_bundle
      if ruby_install_needed?
        install_ruby
        install_jvm
        setup_language_pack_environment
        setup_profiled
      else
        topic "Ruby '#{ruby_version.version}' already installed"
      end

      allow_git do
        install_bundler_in_app
        if File.exists?("#{@build_path}/Gemfile")
          build_bundler
        else
          topic "Skipping bundle install"
        end
        # create_database_yml
        # install_binaries
        # run_assets_precompile_rake_task
      end
      # We can't call super here...
      # super
    end

    # ... so we somehow mimic its behavior over here
    instrument 'base.compile' do
      Kernel.puts "" if @warnings.any? || @deprecations.any?
      @warnings.each do |warning|
        Kernel.puts "###### WARNING:"
        puts warning
        Kernel.puts ""
      end
      if @deprecations.any?
        topic "DEPRECATIONS:"
        puts @deprecations.join("\n")
      end
    end
  end

private

  def ruby_install_needed?
    !File.exists?(slug_vendor_ruby)
  end

  def add_to_profiled(string)
    FileUtils.mkdir_p "#{ENV['HOME']}/.profile.d"
    File.open("#{ENV['HOME']}/.profile.d/ruby.sh", "a") do |file|
      file.puts string
    end
  end

  # the base PATH environment variable to be used
  # @return [String] the resulting PATH
  def default_path
    # need to remove bin/ folder since it links
    # to the wrong --prefix ruby binstubs
    # breaking require. This only applies to Ruby 1.9.2 and 1.8.7.
    safe_binstubs = binstubs_relative_paths - ["bin"]
    paths         = [
      ENV["PATH"],
      "bin",
      system_paths,
    ]
    paths.unshift("#{slug_vendor_jvm}/bin") if ruby_version.jruby?
    paths.unshift(safe_binstubs)

    paths.join(":")
  end

  def binstubs_relative_paths
    [
      "bin",
      "#{slug_vendor_base}/bin"
    ]
  end

  def system_paths
    "/usr/local/bin:/usr/bin:/bin"
  end

  # the relative path to the bundler directory of gems
  # @return [String] resulting path
  def slug_vendor_base
    instrument 'ruby_dev.slug_vendor_base' do
      if @slug_vendor_base
        @slug_vendor_base
      elsif ruby_version.ruby_version == "1.8.7"
        @slug_vendor_base = "#{ENV['HOME']}/vendor/bundle/1.8"
      else
        @slug_vendor_base = run_no_pipe(%q(ruby -e "require 'rbconfig';puts \"#{ENV['HOME']}/vendor/bundle/#{RUBY_ENGINE}/#{RbConfig::CONFIG['ruby_version']}\"")).chomp
        error "Problem detecting bundler vendor directory: #{@slug_vendor_base}" unless $?.success?
        @slug_vendor_base
      end
    end
  end

  # the path to the vendored ruby directory
  # @return [String] resulting path
  def slug_vendor_ruby
    "#{ENV['HOME']}/vendor/#{ruby_version.version_without_patchlevel}"
  end

  # the path to the vendored jvm
  # @return [String] resulting path
  def slug_vendor_jvm
    "#{ENV['HOME']}/vendor/jvm"
  end

  # the absolute path of the build ruby to use during the buildpack
  # @return [String] resulting path
  def build_ruby_path
    "/tmp/#{ruby_version.version_without_patchlevel}"
  end

  # fetch the ruby version from bundler
  # @return [String, nil] returns the ruby version if detected or nil if none is detected
  def ruby_version
    instrument 'ruby_dev.ruby_version' do
      return @ruby_version if @ruby_version
      new_app           = !File.exist?(DEVSTEP_METADATA)
      last_version_file = "buildpack_ruby_version"
      last_version      = nil
      last_version      = @metadata.read(last_version_file).chomp if @metadata.exists?(last_version_file)

      # Suppport building projects without a Gemfile
      if File.exists?("#{@build_path}/Gemfile")
        ruby_version = bundler.ruby_version
      else
        ruby_version = DEFAULT_RUBY_VERSION
      end

      @ruby_version = LanguagePack::RubyVersion.new(ruby_version,
        is_new:       new_app,
        last_version: last_version)
      return @ruby_version
    end
  end

  # default JAVA_OPTS
  # return [String] string of JAVA_OPTS
  def default_java_opts
    "-Xmx384m -Xss512k -XX:+UseCompressedOops -Dfile.encoding=UTF-8"
  end

  # default JRUBY_OPTS
  # return [String] string of JRUBY_OPTS
  def default_jruby_opts
    "-Xcompile.invokedynamic=false"
  end

  # default JAVA_TOOL_OPTIONS
  # return [String] string of JAVA_TOOL_OPTIONS
  def default_java_tool_options
    "-Djava.rmi.server.useCodebaseOnly=true"
  end

  # list the available valid ruby versions
  # @note the value is memoized
  # @return [Array] list of Strings of the ruby versions available
  def ruby_versions
    return @ruby_versions if @ruby_versions

    Dir.mktmpdir("ruby_versions-") do |tmpdir|
      Dir.chdir(tmpdir) do
        @fetchers[:buildpack].fetch("ruby_versions.yml")
        @ruby_versions = YAML::load_file("ruby_versions.yml")
      end
    end

    @ruby_versions
  end

  # sets up the environment variables for the build process
  def setup_language_pack_environment
    instrument 'ruby_dev.setup_language_pack_environment' do
      ENV["PATH"] += ":bin" if ruby_version.jruby?
      setup_ruby_install_env
      # Node is already installed on the base image
      # ENV["PATH"] += ":#{node_bp_bin_path}" if node_js_installed?

      # TODO when buildpack-env-args rolls out, we can get rid of
      # ||= and the manual setting below
      config_vars = default_config_vars.each do |key, value|
        ENV[key] ||= value
      end

      ENV["GEM_PATH"] = slug_vendor_base
      ENV["GEM_HOME"] = slug_vendor_base
      ENV["PATH"]     = default_path
    end
  end

  # sets up the profile.d script for this buildpack
  def setup_profiled
    instrument 'ruby_dev.setup_profiled' do
      File.delete("#{ENV['HOME']}/.profile.d/ruby.sh") if File.exists?("#{ENV['HOME']}/.profile.d/ruby.sh")

      set_env_override "GEM_HOME", "#{slug_vendor_base}"
      set_env_override "GEM_PATH", "#{slug_vendor_base}"
      set_env_default  "LANG",     "en_US.UTF-8"
      set_env_override "PATH",     "#{slug_vendor_base}/bin:$PATH"

      if ruby_version.jruby?
        set_env_default "JAVA_OPTS", default_java_opts
        set_env_default "JRUBY_OPTS", default_jruby_opts
        set_env_default "JAVA_TOOL_OPTIONS", default_java_tool_options
      end
    end
  end

  # install the vendored ruby
  # @return [Boolean] true if it installs the vendored ruby and false otherwise
  def install_ruby
    instrument 'ruby_dev.install_ruby' do
      return false unless ruby_version

      invalid_ruby_version_message = <<ERROR
Invalid RUBY_VERSION specified: #{ruby_version.version}
Valid versions: #{ruby_versions.join(", ")}
ERROR

      if ruby_version.build?
        FileUtils.mkdir_p(build_ruby_path)
        Dir.chdir(build_ruby_path) do
          ruby_vm = "ruby"
          instrument "ruby_dev.fetch_build_ruby" do
            @fetchers[:mri].fetch_untar("#{ruby_version.version.sub(ruby_vm, "#{ruby_vm}-build")}.tgz")
          end
        end
        error invalid_ruby_version_message unless $?.success?
      end

      FileUtils.mkdir_p(slug_vendor_ruby)
      Dir.chdir(slug_vendor_ruby) do
        instrument "ruby_dev.fetch_ruby" do
          if ruby_version.rbx?
            raise 'RBX IS NOT SUPPORTED YET!'
          else
            @fetchers[:mri].fetch_untar("#{ruby_version.version}.tgz")
          end
        end
      end
      error invalid_ruby_version_message unless $?.success?

      app_bin_dir = "#{ENV['HOME']}/bin"
      FileUtils.mkdir_p app_bin_dir

      run("ln -s ruby #{slug_vendor_ruby}/bin/ruby.exe")

      Dir["#{slug_vendor_ruby}/bin/*"].each do |vendor_bin|
        run("ln -s #{vendor_bin} #{app_bin_dir}")
      end

      @metadata.write("buildpack_ruby_version", ruby_version.version)

      topic "Using Ruby version: #{ruby_version.version}"
      if !ruby_version.set
        warn(<<WARNING)
You have not declared a Ruby version in your Gemfile.
To set your Ruby version add this line to your Gemfile:
#{ruby_version.to_gemfile}
# See https://devcenter.heroku.com/articles/ruby-versions for more information.
WARNING
      end
    end

    true
  end

  def new_app?
    @new_app ||= !File.exist?(DEVSTEP_METADATA)
  end

  # vendors JVM into the slug for JRuby
  def install_jvm
    instrument 'ruby_dev.install_jvm' do
      if ruby_version.jruby?
        raise 'JRUBY IS NOT SUPPORTED YET!'
      end
    end
  end

  # find the ruby install path for its binstubs during build
  # @return [String] resulting path or empty string if ruby is not vendored
  def ruby_install_binstub_path
    @ruby_install_binstub_path ||=
      if ruby_version.build?
        "#{build_ruby_path}/bin"
      elsif ruby_version
        "#{slug_vendor_ruby}/bin"
      else
        ""
      end
  end

  # setup the environment so we can use the vendored ruby
  def setup_ruby_install_env
    instrument 'ruby_dev.setup_ruby_install_env' do
      ENV["PATH"] = "#{ruby_install_binstub_path}:#{ENV["PATH"]}"

      if ruby_version.jruby?
        ENV['JAVA_OPTS']  = default_java_opts
      end
    end
  end

  # installs vendored gems into the slug
  def install_bundler_in_app
    instrument 'ruby_dev.install_language_pack_gems' do
      FileUtils.mkdir_p(slug_vendor_base)
      Dir.chdir(slug_vendor_base) do |dir|
        `cp -R #{bundler.bundler_path}/. .`
      end
    end
  end

  # runs bundler to install the dependencies
  def build_bundler
    instrument 'ruby_dev.build_bundler' do
      log("bundle") do
        bundle_bin     = "bundle"
        bundle_command = "#{bundle_bin} install"
        bundle_command << " -j4"

        topic("Installing dependencies using #{bundler.version}")

        bundler_output = ""
        bundle_time    = nil
        Dir.mktmpdir("libyaml-") do |tmpdir|
          libyaml_dir = "#{tmpdir}/#{LIBYAML_PATH}"
          install_libyaml(libyaml_dir)

          # need to setup compile environment for the psych gem
          yaml_include   = File.expand_path("#{libyaml_dir}/include").shellescape
          yaml_lib       = File.expand_path("#{libyaml_dir}/lib").shellescape
          pwd            = Dir.pwd
          bundler_path   = "#{pwd}/#{slug_vendor_base}/gems/#{BUNDLER_GEM_PATH}/lib"
          # we need to set BUNDLE_CONFIG and BUNDLE_GEMFILE for
          # codon since it uses bundler.
          env_vars       = {
            "BUNDLE_GEMFILE"                => "#{pwd}/Gemfile",
            "BUNDLE_CONFIG"                 => "#{pwd}/.bundle/config",
            "CPATH"                         => noshellescape("#{yaml_include}:$CPATH"),
            "CPPATH"                        => noshellescape("#{yaml_include}:$CPPATH"),
            "LIBRARY_PATH"                  => noshellescape("#{yaml_lib}:$LIBRARY_PATH"),
            "RUBYOPT"                       => syck_hack,
            "NOKOGIRI_USE_SYSTEM_LIBRARIES" => "true"
          }
          env_vars["BUNDLER_LIB_PATH"] = "#{bundler_path}" if ruby_version.ruby_version == "1.8.7"
          puts "Running: #{bundle_command}"
          instrument "ruby_dev.bundle_install" do
            bundle_time = Benchmark.realtime do
              bundler_output << pipe("#{bundle_command} --no-clean", out: "2>&1", env: env_vars, user_env: true)
            end
          end
        end

        if $?.success?
          puts "Bundle completed (#{"%.2f" % bundle_time}s)"
          log "bundle", :status => "success"
          puts "Cleaning up the bundler cache."
          instrument "ruby_dev.bundle_clean" do
            pipe("#{bundle_bin} clean --force", out: "2> /dev/null")
          end
        else
          log "bundle", :status => "failure"
          error_message = "Failed to install gems via Bundler."
          puts "Bundler Output: #{bundler_output}"
          if bundler_output.match(/An error occurred while installing sqlite3/)
            error_message += <<ERROR


Detected sqlite3 gem which is not supported on Heroku.
https://devcenter.heroku.com/articles/sqlite3
ERROR
          end

          error error_message
        end
      end
    end
  end
end
