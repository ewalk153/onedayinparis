require 'csv'
namespace :data do
  desc "Adds stations to data store"
  task import: :environment do
    MetroStation.delete_all
    file_name = ENV["FILENAME"]
    CSV.open(file_name).each do |csv|
      # node_id, station name
      MetroStation.create(node_id: csv[0], name: csv[1])
    end
  end

  desc "Exports station data"
  task export: :environment do
    file_name = ENV["FILENAME"]
    raise "FILENAME param required" unless file_name.present?
    raise "file exists" if File.exist?(file_name)
    CSV.open(file_name, "w") do |csv|
      # node_id, station name, x, y
      MetroStation.all.each do |metro|
        csv << [metro.node_id, metro.name, metro.x, metro.y]
      end
    end
  end

  desc "recover metros html"
  task parse_metro: :environment do
    string_doc = File.open("metros.html").read
    doc = Nokogiri::HTML(string_doc, nil, Encoding::UTF_8.to_s)
    result = doc.css(tag).map do |x|
      x.css("p").map { |n| n.children.last.to_s.strip }.tap { |r| r[-1] = r.last.split(",").map(&:strip)}.flatten
    end
    titles = %w(name node_id x y)
    result.map do |r|
      MetroStation.create Hash[titles.zip(r)]
    end
  end
end

