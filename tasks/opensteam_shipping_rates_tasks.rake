
namespace :opensteam do
  namespace :plugins do
    namespace :shipping_rate do

      desc "install the shipping_rate plugin for opensteam (copy migration files..)"
      task :install do
        system "rsync -ruv vendor/plugins/opensteam_shipping_rate/db/migrate db"
      end
    end
  end
end

