# encoding: UTF-8
require 'fileutils'

module TabulaApi
  module Settings

    def self.getDataDir
      # OS X: ~/Library/Application Support/Tabula
      # Win:  %APPDATA%/Tabula
      # Linux: ~/.tabula

      # when invoking as "java -Dtabula.data_dir=/foo/bar ... -jar tabula.war"
      data_dir = java.lang.System.getProperty('tabula.data_dir')
      unless data_dir.nil?
        return java.io.File.new(data_dir).getPath
      end

      # when invoking with env var
      data_dir = ENV['TABULA_DATA_DIR']
      unless data_dir.nil?
        return java.io.File.new(data_dir).getPath
      end

      # use the usual directory in (system-dependent) user home dir
      data_dir = nil
      case java.lang.System.getProperty('os.name')
      when /Windows/
        # APPDATA is in a different place (under user.home) depending on
        # Windows OS version. so use that env var directly, basically
        appdata = ENV['APPDATA']
        if appdata.nil?
          home = java.lang.System.getProperty('user.home')
        end
        data_dir = java.io.File.new(appdata, '/Tabula').getPath

      when /Mac/
        home = java.lang.System.getProperty('user.home')
        data_dir = File.join(home, '/Library/Application Support/Tabula')


      else
        # probably *NIX
        home = java.lang.System.getenv('XDG_DATA_HOME')
        if !home.nil?
          # XDG
          data_dir = File.join(data_home, '/tabula')
        else
          # other, normal *NIX systems
          home = java.lang.System.getProperty('user.home')
          home = '.' if home.nil?
          data_dir = File.join(home, '/.tabula')
        end
      end # /case

      data_dir
    end
    ########## Initialize environment, using helpers ##########
    FileUtils.mkdir_p(File.join(self.getDataDir, 'pdfs'))
  end
end
