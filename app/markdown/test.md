
#### Side Games

Side Games gives the option in playing different Golf games that are often played such as:

* Par3 or closest to hole
  * All Par 3's are scored by who got clossed to hole. 
  * This is usually marked by a tag and the last team picks up the tag of whoever had the closet to the hole
* Skins or Birdies
  * A modified skins game with no rollover. If only one player get a birdie or higher they are the winner
  * An eagle trumps a birdie

A ruby class (Skins Par3) manages all actions

* Three attributes are the basis for all methods and results
  * Players (rounds) are all players in the Game, 
  * :player_good is a hash with the key :player_id and value what is used to score the game
    * For skins this is the hole score for each hole as a string '..b....b......b...'
    * For par3 this is the number of the par3 as a string '3'
    * This also defines who is in the side game. You must be a player to be in the sde game
  * :good is the results of scoring all the player_good to determine the winners


~~~ ruby
def side_games_to_skins
  skins = {}
  skins['good'] = game.side_games[:skins][:good]
  skins['player_par'] = {}
  game.side_games[:skins][:in].each_key do |id|
    if @round_index.include?(id.to_i)
      skins['player_par'][id] = game.side_games[:skins][:cards][id][:par]
    end
  end
  skins
end

~~~
