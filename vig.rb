require 'facets'

def encrypt(string, keys)
    encrypted_word = ""
    string.each_char.with_index do |char, i|
        key = keys[i % keys.length]
        index = LETTER_TO_INDEX[char]
        encrypted_word << INDEX_TO_LETTER[(index + key) % 26] 
    end 
    return encrypted_word.upcase
end 

def decrypt_known(string, keys)
    decrypted_word = ""
    string.each_byte.with_index do |char, i|
        key = keys[i % keys.length]
        index = char-65
        decrypted_word << INDEX_TO_LETTER[(index - key) % 26]
    end 
    return decrypted_word
end 

def decrypt_unknown(string)
    def frequency(array)
        hash = Hash.new(0)
        array.each{|key| hash[key] += 1}
        return hash
    end
    def coincidences(string)
        original_string = string.dup
        check_string = string.dup
        coincidence_array = []
        
        # loops
        (0...original_string.length).step(1) do |i|
            coincidence_array[i] = 0
            (0...check_string.length).step(1) do |j|
                # puts "#{i} -- #{j}"
                if original_string[i+j] == check_string[j]
                    coincidence_array[i] += 1
                else end
            end
            check_string.chop!
        end
        # original_string.length.times do |i|
        #     coincidence_array[i] = 0
        #     (0...check_string.length).step(1) do |j|
        #         # puts "#{i} -- #{j}"
        #         if original_string[j] == check_string[j]
        #             coincidence_array[i] += 1
        #         else end
        #     end
        #     check_string = check_string.rotate(-1)
        # end
        p coincidence_array
        coincidence_array.shift
        p coincidence_array.max
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
y = "itshouldbenotedthativeupvotedeverysinglepersonwhosdisagreedwithmehereasfarasiknowinthgradeitookansattestwithoutpreparingforitatallitwasspurofthemomentiknewaboutitaboutanhouraheadoftimeanddidntdoanyresearchoranythingiscoredhigheronitthantheaveragepersonusingittoapplyforcollegeinmyareaaniqtesthasshownmetobeinthethpercentileforiqthisisthehighestresultthetestiwasgivenreachesanythingfurtherandtheydconsiderittobewithinthemarginoferrorforthattestmymothersboyfriendofyearsisanaerospaceengineerwhograduatedvirginiatechattheageofiunderstandphysicsbetterthanhimandioweverylittleofittohimashewouldrarelygivemeadecentexplanationofanythingjusttellmethatmyideaswerewrongandbecomeaggravatedwithmefornotquiteunderstandingthermodynamicshesnotparticularlysuccessfulasanengineerbutivemetlotsofotherengineerswhoarentasgoodasmeatphysicssoimguessingthatsnotjustaresultofhimbeingbadatitimalsoprettygoodatengineeringidonthaveadegreeandotherthanphysicsidonthaveabetterunderstandingofanyaspectofengineeringthananyactualengineerbutihavelotsofingenuityforinventingnewthingsforexampleiindependentlyinventedregenerativebrakesbeforefindingoutwhattheywereandiwasonlysevenoreightyearsoldwhenistartedinventingwirelesselectricitysolutionsmyfirstideabeingtouseapowerfulinfraredlasertotransmitenergyadmittedlynotthebestplanihaveindependentlythoughtofbasicallyeverybranchofphilosophyivecomeacrosseveryquestionofexistentialismwhichiveseendiscussedinsmbcorxkcdorredditoranywhereelsethethoughtshaventbeennewtomephilosophyhasprettymuchgottentrivialformeiveconsideredtakingaphilosophycoursejusttoseehoweasyitispsychologyiactuallyunderstandbetterthanpeoplewithdegreesunlikeengineeringtheresnoaspectofpsychologywhichidonthaveaverygoodunderstandingoficandebunkmanyofevensigmundfreudstheoriesimagoodenoughwriterthatimwritingabookandsofareverybodywhosreadanyofithassaiditwasreallygoodandplausibletoexpecttohavepublishedandthatsnotjustlikemeandfamilymembersthatcountsstrangersontheinternetiveheardzeronegativeappraisalofitsofarpeoplehavecritiqueditbutnotinsulteditidontknowifthatwillsufficeasevidencethatimintelligentimdonewithitthoughbecauseidratherdefendmymaturitysinceitswhatyouvespentthemosttimeattackingthefollowingaresomeexamplesofmymoralsandethicalcodeibelievefirmlythateverybodydeservesafutureifweweretocapturehitlerattheendofwwiiiwouldbeagainstexecutinghiminfactifwehadanywayofrehabilitatinghimandknowingthathewasntjustfakingitidevensupporttheconceptoflettinghimgofreethisisessentiallybecauseithinkthatwhoeveryouareinthepresentisaseparateentityfromwhoyouwereinthepastandwhoyouareinthefutureandwhileyourpresentselfshouldtakeresponsibilityforyourpastselfsactionsitshouldntbepunishedforthemsimplyforthesakeofpunishmentespeciallyifthepresentselfregretstheactionsofthepastselfandfeelsgenuineguiltaboutthemidontbelieveinjudgementofpeoplebasedontheirpersonalchoicesaslongasthosepersonalchoicesarentharmingothersidonthaveanyissuewithanytypeofsexualitywhatsoevershortofphysicallyactingoutnecrophiliapedophiliaorotheractswhichhaveaharmfulaffectonothersbutidontcarewhatapersonsfantasiesconsistofaslongastheyrecognizethedifferencebetweenrealityandfictionandcanseparatethem"
x = encrypt(y,[1,2,3,4,5,6,7,8,9,10])

puts x

decrypt_unknown(x)