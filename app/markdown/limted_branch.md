#### limited branch objectives

* Limited seem to be called too often
* Limited does not change unless 
  * a new round is added for the players primary tee
  * rounds are deleted (e.g trimmed)
* If you play from another tee, the limit for that round is set, but the quota does not really need to be recomputed. 
  * it will show up on summary
  * it will change if the player's tee changes
  * player.quoto and .rquota is only primary tee
  * player.last_played should be updated, but it's not

The plan is to add limited to the players recored. It is like quota and rquota in it's for primaray tee

If a player plays from a differnt tee, it is set in the game rounds

  * The players quota will be computed but not saved since it does not pass tee and uses players tee
  * The last played will be updated if greater that the current last played.


