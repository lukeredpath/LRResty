require 'plist'

THEME_PATH = "Documentation/theme"
DOC_OUTPUT = "Documentation/html"
SITE_ROOT  = "/var/www/projects.lukeredpath.co.uk/resty"

unless defined?(VERSION)
  VERSION = "0.9"
end

def modify_plist(path, &block)
  if plist = Plist::parse_xml(path)
    yield plist if block_given?
    Plist::Emit.save_plist(plist, path)
  end
end

namespace :website do
  desc "Deploy to production"
  task :deploy => [:upload_website, :upload_docs]

  desc "Regenerate the site"
  task :generate do
    Dir.chdir("Documentation/website") do
      system("jekyll")
    end
  end
  
  desc "Generate the doxygen documentation"
  task :generate_docs do  
    system("appledoc --keep-intermediate-files --verbose 1 --output Documentation/generated --project-name Resty Classes/")
  end
  
  task :upload_website => [:generate, "build:diskimage"] do
    system("rsync -avz --delete Documentation/website/_site/ lukeredpath.co.uk:#{SITE_ROOT}")
  end
  
  task :upload_docs => :generate_docs do
    system("rsync -avz --delete Documentation/html/ lukeredpath.co.uk:#{SITE_ROOT}/api")
  end
end

namespace :build do
  TARGET = "LRResty"
  CONFIG = "Release"
  LIB_NAME = "libLRResty.a"
  BUILD_DIR = "build"
  BASE_SDK = 4.2
  
  desc "Build the static library for the simulator platform"
  task :simulator do
    system("xcodebuild -target #{TARGET} -configuration #{CONFIG} -sdk iphonesimulator#{BASE_SDK}")
  end
  
  desc "Build the static library for the device platform"
  task :device do
    system("xcodebuild -target #{TARGET} -configuration #{CONFIG} -sdk iphoneos#{BASE_SDK}")
  end
  
  desc "Build the static library for the Mac platform"
  task :mac do
    system("xcodebuild -target #{TARGET}-Mac -configuration #{CONFIG}")
  end
  
  desc "Build a combined simulator/device library using lipo"
  task :combined => [:simulator, :device] do
    FileUtils.mkdir_p("#{BUILD_DIR}/CombinedLib")
    system("lipo #{BUILD_DIR}/#{CONFIG}-iphonesimulator/#{LIB_NAME} #{BUILD_DIR}/#{CONFIG}-iphoneos/#{LIB_NAME} -create -output #{BUILD_DIR}/CombinedLib/libLRResty.a")
  end
  
  desc "Clean the build products directory"
  task :clean do
    system("xcodebuild clean")
  end

  FRAMEWORK_NAME = "LRResty.framework"
  
  namespace :ios do
    desc "Create the static framework for the iOS platform"
    task :framework => [:clean, :combined] do
      build_framework("#{BUILD_DIR}/CombinedLib/libLRResty.a")
    end
    
    desc "Build a disk image for the iOS static framework"
    task :diskimage => :framework do
      FileUtils.mkdir_p("pkg")
      system("hdiutil create -srcfolder #{BUILD_DIR}/Release-iOS pkg/LRResty-iOS-#{VERSION}.dmg")
    end
  end
  
  namespace :mac do
    desc "Create the framework for the Mac platform"
    task :framework => [:clean, :mac] do
      build_framework("#{BUILD_DIR}/Release-Mac/libLRResty.a")
    end
    
    desc "Build a disk image for the Mac framework"
    task :diskimage => :framework do
      FileUtils.mkdir_p("pkg")
      system("hdiutil create -srcfolder #{BUILD_DIR}/Release-Mac pkg/LRResty-Mac-#{VERSION}.dmg")
    end
  end
  
  task :all => %w{ios:framework mac:framework}
  
  def build_framework(path_to_library)
    FileUtils.rm_rf("#{BUILD_DIR}/Release")
    
    system("xcodebuild -target LRRestyFramework -configuration #{CONFIG}")
    system("cp #{path_to_library} #{BUILD_DIR}/Release/#{FRAMEWORK_NAME}/Versions/A/LRResty")
    system("ln -s Versions/A/LRResty #{BUILD_DIR}/Release/#{FRAMEWORK_NAME}/LRResty")
    
    modify_plist("#{BUILD_DIR}/Release/#{FRAMEWORK_NAME}/Resources/Info.plist") do |plist|
      plist["CFBundleVersion"] = VERSION
    end
  end
end

task :default => "build:all"
