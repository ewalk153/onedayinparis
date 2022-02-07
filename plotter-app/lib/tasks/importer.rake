require 'csv'
namespace :importer do
  desc "TODO"
  task add_stations: :environment do
    MetroStation.delete_all
    file_name = ENV["FILENAME"]
    CSV.open(file_name).each do |csv|
      # node_id, station name
      MetroStation.create(node_id: csv[0], name: csv[1])
    end
  end
end
