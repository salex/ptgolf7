class GameObjects::ScheduledGame::TeamOptions

  TeamMakeup = [:assigned, :individuals,:twosomes,:threesomes,:foursomes,:mixed34,:mixed23]
  FormingMethods = [:seeded,:random,:draw,:abcd_battle,:redistribution,:least_paired,:stacked,:stacked_draw,:blind_draw]

  attr_accessor  :numb_players, :options

  def initialize(numb_players)
    @numb_players = numb_players
    @options = {}.with_indifferent_access
    TeamMakeup.each do |makeup|
      response = send(makeup)
      options[makeup] = response if response.present?
    end
  end

  private

  def individuals
    # number of teams = numbe of players - individual play
    {individual:numb_players, teams:numb_players}
  end

  def assigned
    # group makes up their own teams 
    {assigned:numb_players,teams:numb_players}
  end

  def twosomes
    return nil if numb_players < 4
    numb_players.modulo(2).zero? ? {twosome:numb_players / 2,teams:numb_players / 2} : nil
  end

  def threesomes
    return nil if numb_players < 6
    numb_players.modulo(3).zero? ? {threesome:numb_players / 3,teams:numb_players / 3} : nil
  end

  def foursomes
    return nil if numb_players < 8
    numb_players.modulo(4).zero? ? {foursome:numb_players / 4,teams:numb_players / 4} : nil
  end

  def mixed23
    return nil if twosomes.present? || foursomes.present? || numb_players < 5
    s3 = (numb_players / 3) - (3 - numb_players.modulo(3)) + 1
    return nil if s3*3 == numb_players
    s2 = (numb_players - (s3 * 3)) / 2
    {twosome:s2,threesome:s3,teams:s2+s3 }
  end

  def mixed34
    return nil if foursomes.present? || numb_players < 7
    s4 = (numb_players / 4) - (4 - numb_players.modulo(4)) + 1
    return nil if s4*4 == numb_players || s4.zero?
    s3 = (numb_players - (s4 * 4)) / 3
    {threesome:s3,foursome:s4,teams:s3+s4}
  end

end
