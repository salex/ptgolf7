
class Games::Scheduled < Game

  def form_teams(makeup,form_method)
    teams = GameObjects::ScheduledGame::FormTeams.new(self.rounds.size,makeup,form_method).teams
    # puts "WHAT TEAMS #{teams}"
    # redirect_to root_path if teams.blank?
    return false if teams.blank?  
    if makeup == 'individuals' || makeup == 'assigned'
      scheduled_rounds = self.current_players_name
    elsif form_method == :least_paired
      scheduled_rounds = GameObjects::ScheduledGame::LeastPaired.new(self).scheduled_rounds
    elsif form_method == :redistribution
      scheduled_rounds = GameObjects::ScheduledGame::Redistribution.new(self).scheduled_rounds
    else
      scheduled_rounds = self.current_players
    end
    if scheduled_rounds.present?
      t = 0
      teams.each do |a|
        t += 1 unless makeup == 'assigned'
        a.each do |m|
          scheduled_rounds[m-1].team = t
          scheduled_rounds[m-1].save
        end
      end
      self.stats[:makeup] = makeup
      self.stats[:seed_method] = form_method
      self.stats[:round][:makeup] = makeup
      self.stats[:round][:seed_method] = form_method
      self.status = 'Pending'
      self.save
    else
      false
    end
  end
  
end
