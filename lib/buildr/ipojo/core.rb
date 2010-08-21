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
        pojoizer = Java.org.apache.felix.ipojo.manipulator.Pojoization.new
        pojoizer.setUseLocalXSD()
        pojoizer.pojoization(Java.java.io.File.new(input_filename),
                             Java.java.io.File.new(output_filename),
                             Java.java.io.FileInputStream.new(metadata_filename))
        pojoizer.getWarnings().each do |warning|
          trace("Pojizer Warning: #{warning}")
        end
        error = false
        pojoizer.getErrors().each do |warning|
          error("Pojizer Error: #{warning}")
          error = true
        end
        raise "Errors processing #{input_filename} with pojoize" if error
      end
    end
  end
end
