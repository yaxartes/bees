require_relative 'pollen'
require_relative 'harvest'
require 'csv'

class StatisticCalculator
  attr_reader :harvest_amount, :sugar_amount, :sugar_by_bee, :sugar_by_day

  def initialize(pollens_file, harvest_file)
    @pollens = []
    @harvest = []

    CSV.foreach(pollens_file) do |row|
      next if row[0] == 'id'
      @pollens << Pollen.new(row[0].to_i, row[1], row[2].to_i)
    end

    CSV.foreach(harvest_file) do |line|
      next if line[0] == 'bee_id'
      @harvest << Harvest.new(line[0].to_i, line[1], line[2].to_i, line[3].to_f)
    end

    @harvest_amount = {}
    @sugar_amount = {}
    @sugar_by_bee = {}
    @sugar_by_day = {}
  end

  def call
    @harvest.each do |record|
      pollen = @pollens.select { |pollen| record.pollen_id == pollen.id }
      add_element(harvest_amount, pollen.first.name, record.milligrams_harvested)

      sugar = count_sugar(record.milligrams_harvested, pollen).round(2)

      add_element(sugar_by_bee, record.bee_id, sugar)
      add_element(sugar_by_day, record.day, sugar)
    end

    harvest_amount.each do |key, value|
      pollen = @pollens.select { |pollen| pollen.name == key }
      sugar_amount[key] = count_sugar(value, pollen).round(2)
    end

    sugar_by_bee.each do |k, v|
      days = @harvest.select { |h| h.bee_id == k }.map(&:day).count
      sugar_by_bee[k] = (v / days).round(2)
    end
  end

  def add_element(hash, key, value)
    hash[key] ? hash[key] += value : hash[key] = value
  end

  def count_sugar(amount, pollen)
    amount * pollen.first.sugar_per_mg
  end
end
