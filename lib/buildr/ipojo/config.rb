module Buildr
  module Ipojo
    class Config
      attr_writer :metadata_file

      attr_reader :project

      def initialize(project)
        @project= project
      end

      def metadata_file
        return @metadata_file unless @metadata_file.nil?
        filename = project._(:src, :main, :config, "ipojo.xml")
        File.exist?(filename) ? filename : nil
      end

    end
  end
end
