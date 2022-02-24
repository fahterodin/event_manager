require 'csv'
require 'google/apis/civicinfo_v2'
require 'time'

def clean_phone(phone)
  phone = phone.gsub(/[-()\s+]/, '').to_s
  if phone.length == 10
    phone
  elsif phone.length == 11 && phone[0] == '1'
    phone[1..10]
  else
    'Number not valid'
  end
end

def reg_hour(date)
  Time.parse(date[-5..-1]).hour
end

def reg_day(date)
  day = Date.strptime(date[0..8], "%m/%d/%Y").wday
  case day
  when 0
    'Sunday'
  when 1
    'Monday'
  when 2
    'Thursday'
  when 3
    'Wedsday'
  when 4
    'Thursday'
  when 5
    'Friday'
  when 6
    'Saturday'
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

best_hours = Hash.new(0)
best_days = Hash.new(0)

contents.each do |row|
  name = row[:first_name]
  phone = clean_phone(row[:homephone])
  date = row[:regdate]
  best_hours[reg_hour(date)] += 1
  best_days[reg_day(date)] += 1
  puts "#{name} #{phone}"
end

best_hours.sort_by { |_k, v| -v }.each do |hour, value|
  puts "#{value} registration during #{hour} o'clock"
end

best_days.sort_by { |_k, v| -v }.each do |day, value|
  puts "#{value} registration #{day}"
end
