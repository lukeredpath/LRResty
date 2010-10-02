THEME_PATH = "Documentation/theme"
DOC_OUTPUT = "Documentation/html"
SITE_ROOT  = "/var/www/projects.lukeredpath.co.uk/resty"

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

