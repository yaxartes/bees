# coding: utf-8
require_relative 'statistic_calculator'
require 'terminal-table'

def make_table(hash, column_1, column_2)
  Terminal::Table.new rows: hash.sort_by { |k, v| v }.reverse.to_h.to_a, headings: [column_1, column_2]
end

puts 'Выберите нужный показатель'
puts 'Введите 1, чтобы узнать, из какой пыльцы было получено больше всего сахара'
puts 'Введите 2, чтобы узнать самую популярную пыльцу'
puts 'Введите 3, чтобы узнать урожай по дням'
puts 'Введите 4, чтобы узнать эффективность пчел'

stat = StatisticCalculator.new('data/pollens.csv', 'data/harvest.csv')
stat.call

case gets.chomp
  when '1'
    puts stat.sugar_amount.max_by { |k,v| v }
  when '2'
    puts stat.harvest_amount.max_by { |k,v| v }
  when '3'
    puts make_table(stat.sugar_by_day, 'День', 'Количество сахара')
  when '4'
    puts make_table(stat.sugar_by_bee, 'ИД пчелы', 'Среднее количество сахара в день')
end
