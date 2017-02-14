require 'spec_helper'
require 'statistic_calculator'
require 'csv'

describe StatisticCalculator do
  before do
    CSV.open('spec/data/pollens.csv', "w") do |csv|
      csv << %w(id name sugar_per_mg)
      csv << %w(1 Canola 10)
      csv << %w(2 Bluebell 3)
    end

    CSV.open('spec/data/harvest.csv', "w") do |csv|
      csv << %w(bee_id day pollen_id miligrams_harvested)
      csv << %w(1, 2013-04-01 1 100)
      csv << %w(1 2013-04-02 2 200)
      csv << %w(2, 2013-04-01 1 50)
      csv << %w(2 2013-04-02 2 20)
    end
  end

  subject { StatisticCalculator.new('spec/data/pollens.csv', 'spec/data/harvest.csv') }

  describe '#.call' do
    before do
      subject.call
    end

    it { expect(subject.harvest_amount).to eq({"Canola" => 150.0, "Bluebell" => 220.0}) }
    it { expect(subject.sugar_amount).to eq({"Canola" => 1500.0, "Bluebell" => 660.0}) }
    it { expect(subject.sugar_by_bee).to eq({1 => 800.0, 2 => 280.0}) }
    it { expect(subject.sugar_by_day).to eq({"2013-04-01" => 1500.0, "2013-04-02" => 660.0}) }
  end
end
