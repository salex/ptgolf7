class Pdf::IndvScoreCard < Prawn::Document
  attr_accessor  :teams, :group

  def initialize(game)
    super(page_layout: :landscape, top_margin:0, left_margin:10, right_margin:6,bottom_margin:0)
    @group = game.group
    @game = game
    @teams = @game.current_players_name

    make_pdf
  end

  def make_pdf
    font_size(14)
    stroke_color "aaaaaa"
    last_team = @teams.last
    define_grid(:columns => 1, :rows => 1, :gutter => 0)
    i = 0
    # @teams.each do |p|
    #   team_card(1,p,i)
    #   i += 1
    #   start_new_page if (i % 10).zero? && team != last_team
    team_card(1,@teams,i)
    

  end

  def blank_row
    Array.new(25,' ')
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
    fl = p.full_name.split
    initial = fl.count > 1 ? fl[0][0..0] + fl[1][0..0] : fl[0][0..1]
    quota = "#{p.tee[0..0]}#{p.limited.present? ? (p.quota.to_s+'*') : p.quota}"

    row = Array.new(25)
    row[0] = p.name[0..18]
    row[1] = "#{quota}  #{(p.quota/2.0).round(1)}"
    row[12]= initial
    row
  end

  def team_card(team,val,i)
    rows = []
    rows << ['Name','TQ SQ',1,2,3,4,5,6,7,8,9,'in','I',10,11,12,13,14,15,16,17,18,'out','tot','+-']
    # pcount = val.size
    val.each do |p|
      rows << player_row(p)
    end
    # (4 - pcount).times do
    #   rows << blank_row
    # end
    rows << blank_row
    rows << par_row

    # rows << blank_row
    # rows << blank_row
    # horizontal_line 0,792, at: 306
    j = i % 3
    grid(j,0).bounding_box do
      transparent(0.5) { dash(1); stroke_bounds; undash }
      # stroke_bounds
      move_down 40
      font_size 12
      text "Tee Time #{(i + 1).to_s}"
      # move_down 4
      draw_table(rows)
      # font_size(13)
      move_down 2
      font_size 12

      # text @teams[team]
    end
  end

  def draw_table(rows)
    font_size(10)
    e = make_table rows,
      :cell_style => {:padding => [4, 0, 4, 3],border_color:"999999"},
      :column_widths => [115,55,25,25,25,25,25,25,25,25,25,30,25,25,25,25,25,25,25,25,25,25,30,30,30] do
        row(0).font_style = :bold
        row(-1).font_style = :bold
        row(0).background_color = 'e0e0e0'
        row(-1).background_color = 'e0e0e0'
        values = cells.columns(1).rows(1..4)
        limited_cells = values.filter do |cell|
          cell.content.include?('*')
        end
        limited_cells.font_style = :bold
        limited_cells.background_color = 'ffdddd'
    end
    e.draw
  end

  def indv_teams
    group = @game.group
    indv = @game.current_players_name
    opt = Games::Teams::Form.new(indv.count).get_options
    teams = {}
    if opt["threesomes"].present?
      opt["threesomes"]["threesome"].times do |c|
        teams[c] = indv.pop(3)
      end
      puts teams
    elsif opt["foursomes"].present?
      opt["foursomes"]["foursome"].times do |c|
        teams[c] = indv.pop(4)
      end
    elsif opt["mixed34"].present?
      n = 0
      opt["mixed34"]["threesome"].times do |c|
        teams[c] = indv.pop(3)
        n = c+1
      end
      opt["mixed34"]["foursome"].times do |c|
        teams[c+n] = indv.pop(4)
      end
    elsif opt["mixed23"].present?
      n = 0
      opt["mixed23"]["twosome"].times do |c|
        teams[c] = indv.pop(2)
        n = c+1
      end
      opt["mixed34"]["threesome"].times do |c|
        teams[c+1] = indv.pop(3)
      end
    else
      puts opt
    end
    teams
  end
end