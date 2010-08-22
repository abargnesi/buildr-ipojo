module Buildr
  module Ipojo
    module ProjectExtension
      include Extension

      def ipojo?
        !@ipojo.nil?
      end

      def ipojo
        @ipojo ||= Buildr::Ipojo::Config.new(self)
      end

      def ipojoize!
        self.ipojo
      end

      after_define do |project|
        if project.ipojo?
          project.packages.each do |pkg|
            if pkg.respond_to?(:to_hash) && pkg.to_hash[:type] == :jar
              pkg.enhance do
                pkg.enhance do
                  begin
                    tmp_filename = pkg.to_s + ".out"
                    metadata_filename = project.ipojo.metadata_filename
                    if metadata_filename.nil?
                      metadata_filename = project._(:target, :generated, :config, "ipojo.xml")
                      mkdir_p File.dirname(metadata_filename)
                      File.open(metadata_filename, "w") do |f|
                        f << "<ipojo></ipojo>"
                      end
                    end
                    info("Processing #{File.basename(pkg.to_s)} through iPojo pre-processor")
                    Buildr::Ipojo.pojoize(project, pkg.to_s, tmp_filename, metadata_filename)
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
end

class Buildr::Project
  include Buildr::Ipojo::ProjectExtension
end