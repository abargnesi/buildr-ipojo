module Buildr
  module Ipojo
    class Config
      attr_writer :metadata_filename

      attr_reader :project

      def initialize(project)
        @project= project
      end

      def metadata_filename
        return @metadata_filename unless @metadata_filename.nil?
        filename = project._(:src, :main, :config, "ipojo.xml")
        File.exist?(filename) ? filename : nil
      end

    end
  end
end
