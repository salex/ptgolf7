class Pdf::ScoreCard < Prawn::Document
  attr_accessor  :teams, :group

  def initialize(game)
    super(page_layout: :landscape, top_margin:25, left_margin:38, right_margin:0,bottom_margin:10)
    @teams = Pdf::ScoreCard.scorecard_teams(game)
    @group = Current.group || game.group
    make_pdf
  end

  def make_pdf
    font_size(14)
    stroke_color "aaaaaa"
    last_team = @teams.keys.last
    define_grid(:columns => 1, :rows => 2, :gutter => 0)
    i = 0
    @teams.each do |team,val|
      team_card(team,val,i)
      i += 1
      start_new_page if (i % 2).zero? && team != last_team
    end

  end

  def blank_row
    Array.new(25,' ')
  end

  def hole_row
    b = Array.new(25,' ')
    b[0] = 'Hole Score'
    b
  end
  def side_row
    b = Array.new(25,' ')
    b[0] = 'Side Score'
    b
  end


  def par_row
    if @group.par_in.present?
      tee_par_in = group.par_in.split("")
      tee_par_out = group.par_out.split("")
    elsif @group.club.par_in.present?
      tee_par_in = group.club.par_in.split("")
      tee_par_out = group.club.par_out.split("")
    else
      tee_par_in = %w(4 4 3 4 5 5 4 3 4)
      tee_par_out = %w(4 5 3 4 4 5 3 4 4)
    end
    row = Array.new(25)
    row[0] = 'Par'
    idx = 2
    tee_par_in.each do |h|
      row[idx] = h
      idx += 1
    end
    idx = 13
    tee_par_out.each do |h|
      row[idx] = h
      idx += 1
    end
    row
  end

  def player_row(p)
    row = Array.new(25)
    row[0] = p[:name]
    row[1] = p[:quota]
    row[12]= p[:initial]
    row
  end

  def team_card(team,val,i)
    rows = []
    rows << ['Name','TQ',1,2,3,4,5,6,7,8,9,'in','I',10,11,12,13,14,15,16,17,18,'out','tot','+-']
    pcount = val['players'].count
    val['players'].each do |p|
      rows << player_row(p)
    end
    (4 - pcount).times do
      rows << blank_row
    end
    rows << par_row
    rows << hole_row
    rows << side_row
    # horizontal_line 0,792, at: 306
    j = i % 2
    grid(j,0).bounding_box do
      transparent(0.6) { dash(1); stroke_bounds; undash }
      # stroke_bounds
      move_down 40
      font_size 12
      text @teams[team]['header'] 
      # move_down 4
      draw_table(rows)
      # font_size(13)
      move_down 2
      font_size 12

      text @teams[team]['header']
    end
  end

  def draw_table(rows)
    font_size(10)
    e = make_table rows,
      :cell_style => {:padding => [4, 0, 4, 3],border_color:"999999"},
      :column_widths => [135,35,24,24,24,24,24,24,24,24,24,28,24,24,24,24,24,24,24,24,24,24,28,28,28] do
        row(0).font_style = :bold
        row(5).font_style = :bold
        row(0).background_color = 'e0e0e0'
        row(5).background_color = 'e0e0e0'
        values = cells.columns(1).rows(1..4)
        limited_cells = values.filter do |cell|
          cell.content.include?('*')
        end
        limited_cells.font_style = :bold
        limited_cells.background_color = 'ffdddd'
        row(-1).text_color = "CCCCCC"
        row(-2).font_style = :italic
        row(-2).text_color = "CCCCCC"
        row(-1).font_style = :italic

    end
    e.draw
  end

  def self.scorecard_teams(game)
    teams = {}
    game.game_teams.each_pair do |team,gplayers|
      teams[team] = {players:[],header:""}.with_indifferent_access
      tquota = 0
      gplayers.each do |gp|
        tquota += gp.quota
        fl = gp.full_name.split
        initial = fl.size > 1 ? fl[0][0..0] + fl[1][0..0] : fl[0][0..1]
        quota = "#{gp.tee[0..0]}#{gp.limited.present? ? (gp.quota.to_s+'*') : gp.quota}"
        teams[team][:players] << {name: gp.name,quota:quota,initial:initial }
      end
      teams[team][:header] = "Team #{team} - Quota #{tquota} Side #{tquota/2.0} Hole #{(tquota / 18.0).round(1)}"
    end
    teams
  end

  # def test_teams
  #   @teams =  {1=>{"players"=>[{:name=>"Ralph Dunn", :quota=>"T34", :initial=>"RD"}, {:name=>"Red Nix", :quota=>"T27", :initial=>"RN"}, {:name=>"Chicken Smith", :quota=>"T23", :initial=>"CS"}], "header"=>"Team 1 - Quota 84 Side 42.0 Hole 4.7"}, 2=>{"players"=>[{:name=>"Charles Carrell", :quota=>"W33", :initial=>"CC"}, {:name=>"Bo Savage", :quota=>"T27", :initial=>"BS"}, {:name=>"Rickey Young", :quota=>"T24", :initial=>"RY"}], "header"=>"Team 2 - Quota 84 Side 42.0 Hole 4.7"}, 3=>{"players"=>[{:name=>"Joe Cobb", :quota=>"T35", :initial=>"JC"}, {:name=>"Dale Denson", :quota=>"T27", :initial=>"DD"}, {:name=>"Randall Mountain", :quota=>"T24", :initial=>"RM"}, {:name=>"Bobby Mcculloch", :quota=>"T17", :initial=>"BM"}], "header"=>"Team 3 - Quota 103 Side 51.5 Hole 5.7"}, 4=>{"players"=>[{:name=>"Bud Keel", :quota=>"T31", :initial=>"BK"}, {:name=>"Ron Jensen", :quota=>"W29", :initial=>"RJ"}, {:name=>"Dennis Moyer", :quota=>"W27", :initial=>"DM"}, {:name=>"Lynn Naler", :quota=>"T6", :initial=>"LN"}], "header"=>"Team 4 - Quota 93 Side 46.5 Hole 5.2"}}
  # end

end