module Buildr
  module Ipojo
    class << self

      def annotation_artifact
        "org.apache.felix:org.apache.felix.ipojo.annotations:jar:1.6.4"
      end

      # The specs for requirements
      def requires
        [
          self.annotation_artifact,
          "org.apache.felix:org.apache.felix.ipojo.metadata:jar:1.4.0",
          "org.apache.felix:org.apache.felix.ipojo.manipulator:jar:1.6.4",
          "org.apache.felix:org.apache.felix.ipojo.ant:jar:1.6.0",
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

        Buildr.ant "ipojo" do |ant|
          ant.taskdef :name => "enhancer",
                      :classname => "org.apache.felix.ipojo.task.IPojoTask",
                      :classpath => Buildr.artifacts(self.requires).each(&:invoke).map(&:to_s).join(File::PATH_SEPARATOR)
          ant.enhancer :input => input_filename,
                       :output => output_filename,
                       :metadata => metadata_filename
        end
      end
    end
  end
end
