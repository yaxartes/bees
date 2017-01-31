require_relative 'pollen'
require_relative 'harvest'
require 'csv'

pollens = []

CSV.foreach('data/pollens.csv') do |row|
  next if row[0] == 'id'
  pollens << Pollen.new(row[0].to_i, row[1], row[2].to_i)
end

harvest = []
harvest_amount = {}
pollens.each do |pollen|
  harvest_amount[pollen.name] = 0
end

CSV.foreach('data/harvest.csv') do |line|
  next if line[0] == 'bee_id'
  harvest << Harvest.new(line[0].to_i, line[1], line[2].to_i, line[3].to_f)
  pollens.each do |pollen|
    harvest_amount[pollen.name] += line[3].to_f if line[2].to_i == pollen.id
  end
end

puts harvest_amount.max_by{|k,v| v }

sugar_amount = {}

harvest_amount.each do |key, value|
  pollen = pollens.select { |pollen| pollen.name == key }
  sugar_amount[key] = value * pollen.first.sugar_per_mg
end
puts sugar_amount.max_by{|k,v| v }