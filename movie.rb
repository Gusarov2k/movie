file_name = ARGV[0]
movies_base = []

if file_name.nil?
  @file_true = 'movies.txt'
elsif File.file? file_name
  @file_true = file_name
else
  abort 'Your file don\'t find try to again'
  exit!
end

File.open(@file_true).each { |line| movies_base.push(line) }

movies = []
movies_base.each { |item| movies.push(item.split('|')) }

movies.each do |col|
  puts "#{col[1]} - #{'*' * ((col[7].to_f - 8).ceil(1) / 0.1).ceil(1).to_i}" if col[1].include? 'Max'
end
