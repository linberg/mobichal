require 'csv'

class PaymentNumbers
  # parse current csv file into an array of arrays and define as a variable
  used_paynums = CSV.read('existing_paynums.csv')

  # define reusable block for iterating through loop and how paynum should look with regex
  # (\d) => match digit; \1{2}} => filter paynums for max. X repeats (eg. if x = 3, then input 2 between curly brackets)
  check_repetition = Proc.new { |num| /(\d)\1{2}/.match(num) }

  50.times do
    # create a 10-digit number
    num = (Array.new(10) { rand(1..9) }.join).to_s
    # if number already in CSV file or has more than X repeating occurences generate new number
    while used_paynums.include?(num) || check_repetition.call(num)
      num = (Array.new(10) { rand(1..9) }.join).to_s
    end
    # add newly generated paynums to CSV
    CSV.open('existing_paynums.csv', 'ab') do |csv|
      csv << [num] # num returns string but needs to be array
    end
  end

  puts "*~TEST BEING EXECUTED~*"
  # data from existing CSV file
  existing_array = [['9093887392'], ['1233429014'], ['6567732207'], ['8914731202']]
  # randomly generated array with one number existing in CSV and one number that does not fill check_repetition conditions
  new_array = [['1233429014'], ['7727434888'], ['3931192036']]

  x = Proc.new { |n| /(\d)\1{2}/.match(n.to_s) }

  new_array.each do |n|
    # add paynums that fulfill conditions to existing array
    existing_array << n unless (existing_array.include?(n) || x.call(n))
  end

  puts existing_array
  # returned array should not show paynums with 3 consecutive numbers or numbers included in existing_array
  if existing_array == [['9093887392'], ['1233429014'], ['6567732207'], ['8914731202'], ['3931192036']]
    puts "... PASS :) ..."
  else
    puts "... FAIL :( ..."
  end
  puts "*~TEST ENDED~*"
end
