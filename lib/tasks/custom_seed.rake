# allows for custom seeds 
# can now run: 'rake db:seed:filename' -- excluding the .rb off the custom seed file
# see stack overflow for additional details: 
# http://stackoverflow.com/questions/19872271/adding-a-custom-seed-file

namespace :db do
  namespace :seed do
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb').intern #intern is alias for .to_sym  
      task task_name => :environment do
        load(filename) if File.exist?(filename)
      end
    end
  end
end
