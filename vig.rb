# work on keys using "whatever".bytes conv

def encrypt(string, keys)
    encrypted_word = ""

    string.each_byte.with_index do |char, i|
        key = (keys[i % keys.length]).ord
        encrypted_word << ((char+key)%256).chr
    end 
    puts "end encrypt"
    open('encrypted.txt', 'w') do |f|
        f.puts encrypted_word
    end
    return encrypted_word
end 

def decrypt_known(string, keys)
    decrypted_word = ""
    string.each_byte.with_index do |char, i|
        key = (keys[i % keys.length]).ord
        decrypted_word << ((char-key)%256).chr
    end 
    puts "end decrypt"
    return decrypted_word
end 

def decrypt_unknown(string)
    def frequency(array)
        hash = Hash.new(0)
        array.each{|key| hash[key] += 1}
        return hash
    end
    
    def coincidences(string)
        def gcd(distance_array)
            array = []
            for a in distance_array[0...10] do
                array.insert(-1, a[0])
            end
            p array
            x = array.reduce(:gcd)
            puts x
        end

        check_string = string.dup
        coincidence_hash = Hash.new
        distance_hash = Hash.new

        # loops
        # find indexes of strings of length 3
		(1...check_string.length-2).step(1) do |i|
			grab = "#{check_string[i-1]}#{check_string[i]}#{check_string[i+1]}"
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
            else
                next
            end
        end
        distance_hash = distance_hash.sort_by {|i,j| [-j, i]}
        p distance_hash[0]
        gcd(distance_hash.to_a)

        # coincidence_hash = coincidence_hash.sort_by {|i,j| [-j.length, i]}
        # p coincidence_hash
    end
    x = frequency(string.split(""))
    x = x.sort_by{|a,b|b}
    x.reverse!
    # p x
    coincidences(string)
end
INDEX_TO_LETTER = {0=>"a", 1=>"b", 2=>"c", 3=>"d", 4=>"e", 5=>"f", 6=>"g", 7=>"h", 8=>"i", 9=>"j", 10=>"k", 11=>"l", 12=>"m", 13=>"n", 14=>"o", 15=>"p", 16=>"q", 17=>"r", 18=>"s", 19=>"t", 20=>"u", 21=>"v", 22=>"w", 23=>"x", 24=>"y", 25=>"z"}

LETTER_TO_INDEX = {"a"=>0,"b"=> 1,"c"=> 2,"d"=> 3,"e"=> 4,"f"=> 5,"g"=> 6,"h"=> 7,"i"=> 8,"j"=> 9, "k"=>10, "l"=>11, "m"=>12, "n"=>13, "o"=>14, "p"=>15, "q"=>16, "r"=>17, "s"=>18, "t"=>19, "u"=>20,"v"=>21, "w"=>22, "x"=>23, "y"=>24, "z"=>25}

LETTER_FREQUENCY = {"e"=>12.702,"t"=>9.356,"a"=>8.167,"o"=>7.507,"i"=>6.966,"n"=>6.749,"s"=>6.327,"h"=>6.094,"r"=>5.987,"d"=>4.253,"l"=>4.025,"u"=>2.758,"w"=>2.560,"m"=>2.406,"f"=>2.228,"c"=>2.202,"g"=>2.015,"y"=>1.994,"p"=>1.929,"b"=>1.492,"k"=>1.292,"v"=>0.978,"j"=>0.153,"x"=>0.150,"q"=>0.095,"z"=>0.077}
y = "I Love mY boYfriend !!!"
x = encrypt(y, "thisIsTheStupidKey")

puts x

z = decrypt_known(x,"thisIsTheStupidKey")
puts z
