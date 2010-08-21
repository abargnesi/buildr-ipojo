module Buildr
  module Ipojo
    module ProjectExtension
      include Extension

      attr_accessor :ipojo_metadata

      def ipojo?
        !@ipojo_metadata.nil?
      end

      after_define do |project|
        if project.ipojo?
          # Add artifacts to java classpath
          Buildr::Ipojo.requires.each do |spec|
            a = Buildr.artifact(spec)
            a.invoke
            Java.classpath << a.to_s
          end
          project.packages.each do |pkg|
            if pkg.respond_to?(:to_hash) && pkg.to_hash[:type] == :jar
              pkg.enhance do
                begin
                  tmp_filename = pkg.to_s + ".out"
                  Buildr::Ipojo.pojoize(project, pkg.to_s, tmp_filename, project.ipojo_metadata)
                  FileUtils.mv tmp_filename, pkg.to_s
                rescue => e
                  FileUtils.rm_rf pkg.to_s
                  raise e
                end
              end
            end
          end
        end
      end
    end
  end
end

class Buildr::Project
  include Buildr::Ipojo::ProjectExtension
end