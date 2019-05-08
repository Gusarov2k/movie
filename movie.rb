input_arg = ARGV[0]

if input_arg.nil?
  file_name = 'movies.txt'
elsif File.file? input_arg
  file_name = input_arg
else
  abort 'Your file don\'t find try to again'
end

movies_base = []
File.open(file_name).each { |line| movies_base.push(line) }

movies = movies_base.map { |item| item.split('|') }

movies.each do |col|
  puts "#{col[1]} - #{'*' * ((col[7].to_f - 8).ceil(1) / 0.1).ceil(1).to_i}" if col[1].include? 'Max'
end
