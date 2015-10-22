#I lose my keys all th time too
def intro
  system("clear")
  puts <<-EOP
    WHERE ARE MY XXXXing KEYS!!!

    You lost your keys!
    Damm!
    They fell out of your pocket somewhere in the house!
    And you are late for Wyncode, you have to leave in 5 minutes!
    You are looking for 2 Keys, the house key and the car key.
    You have to find both of them or there will be serious mockery!!
    Oh, and you dont know your way around the freakin house!!!!
    Happy hunting!

  EOP
end
#------------------------------------------------------------------


def drop_keys                       #randomly drop the keys
  @keys.each do |key|
    while true
      index = rand(@house.size).to_i
      index -= 1
      if @rooms[@house[index]]
        redo
      else
        @rooms[@house[index]] = key
        break
      end
    end
  end
end

# Method to prompt for an item in a list
def ask(question,list)
  list.each do |item|
    puts item
  end
  puts ""
  print question
  answer = gets.chomp.downcase
  while !list.map{|item| item.downcase}.include? answer
    print "That's not on the list, try again! "
    answer = gets.chomp.downcase
  end
  puts ""
  return answer
end

#look for a key
def look
  if @rooms[@here]            #values are initialized to nil
    @found = @rooms[@here]
  else
    @found = nil
  end

  #Evaluate the found keys
  if @found
    @rooms[@here] = nil       #take the key out of the room
    @found_keys << @found     #add it to the keys found
  end

  if @found_keys.sort.eql? @keys.sort   #found both keys??
    @found_them = true
  end
end

#print results
def print_results
  puts "You are in the #{@here}"
  puts
  if @found
    puts "YOU FOUND THE DAMM #{@found} KEY!!"
  else
    puts "UH OH, NOTHING HERE!!"
    puts ""
  end
end

#prints time message based on the remaining time
def print_timer
  case @timer             #funny messages, not the state machine
    when 5
      puts "No Pressure you have #{@timer} minutes left"
    when 4
      puts "You might want to hurry you have #{@timer} minutes left"
    when 3
      puts "OK NOW PANIC YOU HAVE #{@timer} MINUTES"
    when 2
      puts "CRAP! #{@timer} MINUTES"
    when 1
      puts "WHERE ARE MY XXXXING KEYS!!! #{@timer} MINUTE!!!"
    else
      puts "OH NOOOOOOOOOO!"
  end
  puts ""
  puts ""
end

#set @here for the next loop based on user selection from map list
def next_door
  case @here
    when "kitchen"
      @here = ask("which room next? ", ["basement", "garage", "family"])
    when "basement"
      @here = ask("which room next? ", ["kitchen", "rumpus"])
    when "garage"
      @here = ask("which room next? ", ["kitchen"])
    when "family"
      @here = ask("which room next? ", ["kitchen", "bedroom"])
    when "rumpus"
      @here = ask("which room next? ", ["basement", "garage"])
    when "bedroom"
      @here = ask("which room next? ", ["family", "attic"])
    when "attic"
      @here = ask("which room next? ", ["bedroom", "family"])
    else
      puts "soemthing is seriously wrong"
  end
end

#exit the game
def exit_game
  if !@debug
    system("clear")
  end

  if @found_them
    puts
    puts "<><><><><><><><><><><><><><><>"
    puts "YOU FOUND YOUR XXXXING KEYS!!!"
    puts "<><><><><><><><><><><><><><><>"
    puts ""
    puts "Be more careful next time! Thanks for playing!"
    puts
    puts
  else
    puts ""
    puts "Sorry amigo, better start the walk of shame"
    puts
    puts "Just got this text from Damon..."
    puts
    puts "--------------------------------------------"
    puts "LOST YOUR KEYS AGAIN, YOU IMBECILE!!!"
    puts "--------------------------------------------"
    puts
    puts "Well, thanks for playing anyway!"
    puts
    puts
  end

  puts ""
  puts ""
end

#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
#               START OF PROGRAM CODE
#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

#initialize the game variables note: this section in main for instances

@debug = false                #if true supresses clear screen & allow p

@found_keys = []              #holds the keys found
@timer = 5                    #count down to mockery!!! 1 each loop
@found_them = false           #Did you find them????
@found = nil                  #what you find in each room
@here = nil                   #the room you are in (state variable)
@rooms = {                    #replace the nil with the er, "key" name
    "kitchen" => nil,
    "basement" => nil,
    "garage" => nil,
    "bedroom" => nil,
    "attic" => nil,
    "family" => nil,
    "rumpus" => nil
}
@keys = ["House", "Car"]      #the keys to look for

@house = [                    #the rooms in the house, possible to shuffle
    "kitchen",
    "basement",
    "garage",
    "bedroom",
    "attic",
    "family",
    "rumpus"
]
# doors shows where the doors in each room go
# note this hash could be used to replace the case statement
# note could also be used to randomize the map using the house array
@doors = {
    "kitchen" => ["basement", "garage", "family"],
    "basement" => ["kitchen", "rumpus"],
    "garage" => ["kitchen"],
    "family" => ["kitchen", "bedroom"],
    "rumpus" => ["basement", "garage"],
    "bedroom" => ["family", "attic"],
    "attic" => ["bedroom", "family"]
}
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
#------------------------start of main program -------------------------
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------

#display the intro

intro

#find out where our fearless hero wants to start!
@here = ask("which room do you want to start in? ", @house)

#randomly drop the keys

drop_keys

#main game loop

while @timer > 0              #loop until you run out of time

  @timer -= 1                 #decrement the timer (where is my -- ?!!)

  #look for keys in the new room

  look

  #print the results to the screen

  if !@debug
    system("clear")
  end

  print_results

  #check if the keys were found

  if @found_them        #break the loop when you find them
    break
  end

  #print the reamining time message

  print_timer

  #Setup for next loop

  next_door


  @found = nil                #clear found for next loop

end #end of main loop

#display the game result and exit
exit_game
