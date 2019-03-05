require 'digest'

$encoded = ['6f047ccaa1ed3e8e05cde1c7ebc7d958','275a5602cd91a468a0e10c226a03a39c','b4ba93170358df216e8648734ac2d539','dc1c6ca00763a1821c5af993e0b6f60a','8cd9f1b962128bd3d3ede2f5f101f4fc','554532464e066aba23aee72b95f18ba2']
#Prevents the Output file from being overwritten and only allows for appending
$f = File.new("Ouput.txt", 'a')
$digest = Hash.new

#the logic of the dictionary attack is to look at the array of encoded values. This could easily be converted to get the values from an input file
def dictionary_attack()
  puts "Entered Attack"
  $encoded.each do |i|
    #Process clock time looks at the monotonic clock which maximizes accuracy and prevents time skips (each call gets the system time)
    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    #Querries the hash map to find the given element of the encoded passwords
    hash = $digest[i]
    elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - starting
    $f.write("The password for the hash value #{i} is #{hash}, it takes the program #{elapsed} sec to recover this password.\n")
  end
end

#For any given line, process_line will encrypt the given password (with the new line chopped) and
def process_line(password)
    md5 = Digest::MD5.hexdigest(password.chop!)
    if $encoded.include? md5 then $digest[md5] = password end
end

# function to process each line of a file and extract the passwords
def process_file(file_name)
	begin
		File.foreach(file_name, encoded: 'ASCII') do |line|
				process_line(line)
		end
	rescue
		STDERR.puts "Could not open file, #{$!}"
		exit 4
	end
end

# Executes the program
def main_loop()
	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end
  process_file(ARGV[0])
end

if __FILE__==$0
	main_loop()
  dictionary_attack()
  $f.close
end
