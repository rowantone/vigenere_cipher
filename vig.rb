# VIGENERE CIPHER -- ROWAN
# http://rowan.codes/

$verbose = 0
$elapsed_time = Time.now
INDEX_TO_LETTER = {0=>"a", 1=>"b", 2=>"c", 3=>"d", 4=>"e", 5=>"f", 6=>"g", 7=>"h", 8=>"i", 9=>"j", 10=>"k", 11=>"l", 12=>"m", 13=>"n", 14=>"o", 15=>"p", 16=>"q", 17=>"r", 18=>"s", 19=>"t", 20=>"u", 21=>"v", 22=>"w", 23=>"x", 24=>"y", 25=>"z"}

def send_info(message)
    if $verbose == 1
        #do nothing
    else
        puts "INFO [#{(Time.now-$elapsed_time).round(3).to_s.ljust(5, '0')}] -- #{message}"
    end
end

def get_freq(filename)
    freq = Hash.new
    testing = File.open(filename)
    string = testing.read.force_encoding 'ASCII-8BIT'
    total = 0
    string.each_byte do |char|
        if freq[char] != nil
            freq[char] += 1
            total += 1
        else
            freq[char] = 1
            total += 1
        end
    end
    255.times do |i|
        if freq[i] == nil
            freq[i] = 0
        else 
            freq[i] = (freq[i].to_f/total).round(8)
        end
    end
    freq = freq.sort_by {|i,j| [i]}
    testing.close
    return freq
end

def get_freq_string(string)
    freq = Hash.new
    total = 0
    string.each_byte do |char|
        if freq[char] != nil
            freq[char] += 1
            total += 1
        else
            freq[char] = 1
            total += 1
        end
    end
    255.times do |i|
        if freq[i] == nil
            freq[i] = 0
        else 
            freq[i] = (freq[i].to_f/total).round(8)
        end
    end
    freq = freq.sort_by {|i,j| [i]}
    return freq
end

def encrypt(filename, keys, output)
    send_info("Encrypting #{filename}...")
    file_input = File.open(filename)
    string = file_input.read.force_encoding 'ASCII-8BIT'
    encrypted_word = ""
    string.each_byte.with_index do |char, i|
        key = (keys[i % keys.length]).ord
        encrypted_word << ((char+key)%256).chr
    end
    x = File.open(output, "w")
    x.puts encrypted_word
    x.close
    send_info("done!")
    return encrypted_word
end 

def decrypt_known(filename, keys, output)
    send_info("Decrypting #{filename}...")
    file_input = File.open(filename)
    string = file_input.read.force_encoding 'ASCII-8BIT'
    decrypted_word = ""
    string.each_byte.with_index do |char, i|
        key = (keys[i % keys.length]).ord
        decrypted_word << ((char-key)%256).chr
    end 
    x = File.open(output, "w")
    x.puts decrypted_word
    x.close
    return decrypted_word
end 

def decrypt_unknown(filename, output)
    def frequency(array)
        hash = Hash.new(0)
        array.each{|key| hash[key] += 1}
        return hash
    end
    
    def find_key_length(string)
        send_info("Finding key length...")
        def gcd(distance_array)
            array = []
            for a in distance_array[0...10] do
                array.insert(-1, a[0])
            end
            key_length = array.reduce(:gcd)
            return key_length
        end

        check_string = string.dup
        coincidence_hash = Hash.new
        distance_hash = Hash.new

        # loops
        # find indexes of strings of length 3
		(1...check_string.length-2).step(1) do |i|
            grab = "#{check_string[i-1].chr}#{check_string[i].chr}#{check_string[i+1].chr}"
            if coincidence_hash[grab] != nil
                coincidence_hash[grab].insert(-1, i)
            else
                coincidence_hash[grab] = [i]
            end
        end

        # find distance between indexes for each string
        for a in  coincidence_hash do
            if a[1].length > 1
                (0...a[1].length-1).step(1) do |i|
                    grab = (a[1][i] - a[1][i+1]).abs
                    if distance_hash[grab] != nil
                        distance_hash[grab] += 1
                    else
                        distance_hash[grab] = 0
                    end
                end
            else next end
        end
        
        distance_hash = distance_hash.sort_by {|i,j| [-j, i]}
        key_length = gcd(distance_hash.to_a)
        send_info("Key length: #{key_length} characters")
        return key_length
    end

    def find_key(key_length, string)
        send_info("Finding key...")
        def conv_integer_to_char(array)
            result = []
            for element in array
                result.insert(-1, element.chr)
            end
            return result
        end
        send_info("Training reference...")
        darwin = get_freq("darwin.txt")
        current_check = []
        char_freq = Hash.new
        the_key = []
        send_info("Deciphering...")
        key_length.times do |k|
            string.each_byte.with_index do |char, i|
                if i % key_length == k
                    current_check.insert(-1, char)
                else next end
                current_check = conv_integer_to_char(current_check)
            end
            char_freq = get_freq_string(current_check.join)
            shift = -1
            max = 0
            char_freq.rotate!(97)
            26.times do |i|
                total = 0
                255.times do |j|
                    if darwin[j][1].to_f == 0 || char_freq[j][1].to_f == 0
                        next
                    else
                        total += (darwin[j][1].to_f * char_freq[j][1].to_f)
                    end
                end
                if total > max
                    max = total
                    shift = i
                else end
                char_freq.rotate!
            end
            the_key.insert(-1, INDEX_TO_LETTER[shift])
            print "suspected key: #{the_key.join}\r"
            
            char_freq.rotate!(-26)
            shift = -1
            max = 0
            current_check.clear
        end
        puts
        send_info("done!")
        return the_key
    end
    
    input_file = File.open(filename)
    input_string = input_file.read.force_encoding 'ASCII-8BIT'
    key_length = find_key_length(input_string)
    key = find_key(key_length, input_string)
    decrypt_known(filename, key, output)
end

def get_help
    puts
    puts "\tUsage: vig.rb (-q) [input] [output] [-e|-d|-a] (key)"
    puts "Optional:"
    puts "\t-q\tverbose output (ignore INFO)"
    puts "Arguments:"
    puts "\tinput\tinput file name"
    puts "\toutput\toutput file"
    puts "\t-e\tencrypt a file, with given key"
    puts "\t-d\tdecrypt a file, with given key"
    puts "\t-a\tattack a file, not knowing key"
    puts "\tkey\tlowercase a-z only (sorry) for encrypt/decrypt"
end

def get_input
    offset = 0
    if ARGV.include? "-q"
        verbose = 1
        offset += 1
    end
    if ARGV[offset+2] == "-e"
        encrypt(ARGV[offset], ARGV[offset+3], ARGV[offset+1])
    elsif ARGV[offset+2] == "-d"
        decrypt_known(ARGV[offset], ARGV[offset+3], ARGV[offset+1])
    elsif ARGV[offset+2] == "-a"
        decrypt_unknown(ARGV[offset], ARGV[offset+1])
    else
        get_help()
    end
end

def main
    get_input
end

main

