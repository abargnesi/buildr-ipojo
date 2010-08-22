require File.expand_path('../../../spec_helper', __FILE__)

def open_zip_file(file = 'target/foo-2.1.3.jar')
  jar_filename = @foo._(file)
  File.should be_exist(jar_filename)
  Zip::ZipFile.open(jar_filename) do |zip|
    yield zip
  end
end

def open_main_manifest_section(file = 'target/foo-2.1.3.jar')
  jar_filename = @foo._(file)
  File.should be_exist(jar_filename)
  yield Buildr::Packaging::Java::Manifest.from_zip(jar_filename).main
end

def init_project(project)
  project.version = "2.1.3"
  project.group = "mygroup"
  compile.with Buildr::Ipojo.annotation_artifact
end

describe "ipojo" do
  before do
    write "src/main/java/com/biz/Foo.java", <<SRC
package com.biz;
@org.apache.felix.ipojo.annotations.Component
public class Foo {}
SRC
  end

  describe "with no metadata file and pojoized!" do
    before do
      @foo = define "foo" do
        init_project(project)
        project.ipojoize!
        package :jar
      end
      task('package').invoke
    end

    it "produces a .jar in the correct location" do
      File.should be_exist(@foo._("target/foo-2.1.3.jar"))
    end

    it "produces a .jar containing expected manifest ipojo entries" do
      open_main_manifest_section do |attribs|
        attribs['iPOJO-Components'].should match(/\$name="com\.biz\.Foo"/)
        attribs['iPOJO-Components'].should_not match(/instance \{ \$component="com\.biz\.Foo" \}/)
      end
    end
  end

  describe "with default metadata file and pojoized!" do
    before do
    write "src/main/config/ipojo.xml", <<SRC
<ipojo><instance component="com.biz.Foo"/></ipojo>
SRC
      @foo = define "foo" do
        init_project(project)
        project.ipojoize!
        package :jar
      end
      task('package').invoke
    end

    it "produces a .jar in the correct location" do
      File.should be_exist(@foo._("target/foo-2.1.3.jar"))
    end

    it "produces a .jar containing expected manifest ipojo entries" do
      open_main_manifest_section do |attribs|
        attribs['iPOJO-Components'].should match(/\$name="com\.biz\.Foo"/)
        attribs['iPOJO-Components'].should match(/instance \{ \$component="com\.biz\.Foo" \}/)
      end
    end
  end

  describe "with non-default metadata file and pojoized!" do
    before do
    write "src/main/config/non-default-ipojo.xml", <<SRC
<ipojo><instance component="com.biz.Foo"/></ipojo>
SRC
      @foo = define "foo" do
        init_project(project)
        project.ipojoize!
        project.ipojo.metadata_file = project._("src/main/config/non-default-ipojo.xml")
        package :jar
      end
      task('package').invoke
    end

    it "produces a .jar in the correct location" do
      File.should be_exist(@foo._("target/foo-2.1.3.jar"))
    end

    it "produces a .jar containing expected manifest ipojo entries" do
      open_main_manifest_section do |attribs|
        attribs['iPOJO-Components'].should match(/\$name="com\.biz\.Foo"/)
        attribs['iPOJO-Components'].should match(/instance \{ \$component="com\.biz\.Foo" \}/)
      end
    end
  end
end
