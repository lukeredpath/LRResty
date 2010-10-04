require 'plist'

THEME_PATH = "Documentation/theme"
DOC_OUTPUT = "Documentation/html"
SITE_ROOT  = "/var/www/projects.lukeredpath.co.uk/resty"

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
  
  task :generate_docs do  
    system("doxygen")
    system(%Q{
      cp #{THEME_PATH}/*.css #{DOC_OUTPUT}
      rm #{DOC_OUTPUT}/tabs.css
    })
  end
  
  task :upload_website => :generate do
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
  VERSION = "1.0"
  
  task :simulator do
    system("xcodebuild -target #{TARGET} -configuration #{CONFIG} -sdk iphonesimulator#{BASE_SDK}")
  end
  
  task :device do
    system("xcodebuild -target #{TARGET} -configuration #{CONFIG} -sdk iphoneos#{BASE_SDK}")
  end
  
  task :combined => [:simulator, :device] do
    FileUtils.mkdir_p("#{BUILD_DIR}/CombinedLib")
    system("lipo #{BUILD_DIR}/#{CONFIG}-iphonesimulator/#{LIB_NAME} #{BUILD_DIR}/#{CONFIG}-iphoneos/#{LIB_NAME} -create -output #{BUILD_DIR}/CombinedLib/libLRResty.a")
  end
  
  task :clean do
    system("xcodebuild clean")
  end

  FRAMEWORK_NAME = "LRResty.framework"
  
  task :framework => [:clean, :combined] do
    FileUtils.rm_rf("#{BUILD_DIR}/Release")
    
    system("xcodebuild -target LRRestyFramework -configuration #{CONFIG}")
    system("cp #{BUILD_DIR}/CombinedLib/libLRResty.a #{BUILD_DIR}/Release/#{FRAMEWORK_NAME}/Versions/A/LRResty")
    system("ln -s Versions/A/LRResty #{BUILD_DIR}/Release/#{FRAMEWORK_NAME}/LRResty")
    
    modify_plist("#{BUILD_DIR}/Release/#{FRAMEWORK_NAME}/Resources/Info.plist") do |plist|
      plist["CFBundleVersion"] = VERSION
    end
  end
end
