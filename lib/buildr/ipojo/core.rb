module Buildr
  module Ipojo
    class << self

      def ipojo_version
        @ipojo_version ||= '1.6.2'
      end

      def ipojo_version=(ipojo_version)
        @ipojo_version = ipojo_version
      end

      def annotation_artifact
        "org.apache.felix:org.apache.felix.ipojo.annotations:jar:#{self.ipojo_version}"
      end

      # The specs for requirements
      def requires
        [
          self.annotation_artifact,
          "org.apache.felix:org.apache.felix.ipojo.metadata:jar:1.4.0",
          "org.apache.felix:org.apache.felix.ipojo.manipulator:jar:#{self.ipojo_version}",
          'asm:asm-all:jar:3.0'
        ]
      end

      # Repositories containing the requirements
      def remote_repository
        'https://repository.apache.org/content/repositories/releases'
      end

      def pojoize(project, input_filename, output_filename, metadata_filename)
        trace("Enhancing #{input_filename} with ipojo metadata")
        cp = Buildr.artifacts(self.requires).each(&:invoke).map(&:to_s)
        cp += [File.expand_path(File.dirname(__FILE__) + '/ipojo_cli.jar')]
        args =
          [
            input_filename,
            output_filename,
            metadata_filename,
            Buildr.application.options.trace ? "true" : "false",
            {:classpath => cp}
          ]
        Java::Commands.java 'buildr.ipojo.cli.Main', *(args)
      end
    end
  end
end
