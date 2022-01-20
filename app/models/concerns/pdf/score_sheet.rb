class Pdf::ScoreSheet < Prawn::Document

  def initialize
    super( top_margin:14, left_margin:14, right_margin:0,bottom_margin:0)
    make_pdf
  end

  def make_pdf
    define_grid(:columns => 32, :rows => 48, :gutter => 2)
    header
    font_size(16)
    team_scores
    par3
    signin
    skins
  end

  def header
    grid([0,0],[1,31]).bounding_box do
      font_size(20)

      text "Sign In                                        ScoreSheet", style: :bold
      # stroke_bounds
      stroke_color "888888"
    end
  end

  def teams
    grid([4,0],[16,9]).bounding_box do
      text "Team#        $Paid"
      c = cursor
      stroke{vertical_line 10,175, at:60}
      1.upto(7) do |i|
        draw_text i.to_s, at: [6,c-(i*24)] 
        stroke{horizontal_line 5,170, at: c-(i*24 + 2)}
      end
      # stroke_bounds
    end
  end

  def team_scores
    grid([2,12],[16,31]).bounding_box do
      text "Team#   $Paid     Front          Back          Total", style: :bold
      c = cursor
      stroke{horizontal_line 5,350, at: c}

      stroke do
       vertical_line 53,248, at:60
       vertical_line 53,248, at:120
       vertical_line 53,248, at:200
       vertical_line 53,248, at:280
      end
      1.upto(7) do |i|
       draw_text i.to_s, at: [6,c-(i*24)] 
       stroke{horizontal_line 5,350, at: c-(i*24 + 2)}
      end
      draw_text "#Players ______ $Pot ______ $Side ______", at: [0,26]
      move_down 230
      stroke{horizontal_line 0,350, at: cursor+27}
    end
  end
 
  def par3
    grid([36,12],[47,31]).bounding_box do
      text "Par3's #In ______ $Pot ______ $Each ______", style: :bold

      # text "Par3's"
      # move_down 6
      # text '#Players ________ '
      # text '$Pot ________'
      # text '$Each ________'
      # stroke_bounds
      move_down 20
      c = cursor
      [3,8,12,16].each_with_index do |p3,i|
        draw_text "##{p3}", at: [6,c-(i*30)]
        stroke do
          horizontal_line 40,170, at: c-(i*30 + 2)
          rectangle [170, c-(i*30)+6], 15, 15
        end
        font_size 8
        draw_text 'Pd', at: [172, c-(i*30) - 6]
        font_size 16
      end
    end
  end

  def signin
    grid([2,0],[47,12]).bounding_box do
      # text "Par3's"
      # move_down 6
      # text '#Players ________ '
      # text '$Pot ________'
      # text '$Each ________'
      # # stroke_bounds
      # move_down 40
      text " #      Name         Birdie  Par3", style: :bold
      move_down 16
      c = cursor
      1.upto(24) do |b|
        i = b -1
        draw_text "#{b}", at: [6,c-(i*24)]
        stroke do
          horizontal_line 30,200, at: c-(i*24 + 2)
          rectangle [144, c-(i*24) + 15], 15, 15 
          rectangle [184, c-(i*24) + 15], 15, 15 

        end

       end
    end
  end


  def skins
    grid([17,12],[34,30]).bounding_box do
      text "Birdies #Players ______ $Pot ______ ", style: :bold

      # text "Birdies"
      # move_down 6
      # text '#Players ________ '
      # text '$Pot ________'
      # stroke_bounds
      move_down 20
      c = cursor
      # stroke{horizontal_line 0,350, at: c}

      1.upto(9) do |b|
        i = b - 1
        draw_text "##{b}", at: [6,c-(i*26)]
        stroke do
          horizontal_line 40,130, at: c-(i*26 + 2)
          rectangle [130, c-(i*26)+8], 15, 15 
        end
        font_size 8
        draw_text 'Pd', at: [132, c-(i*26) - 4]
        font_size 16

        j = b + 9
        draw_text "##{j}", at: [176,c-(i*26)]
        stroke do
          horizontal_line 220,310, at: c-(i*26 + 2)
          rectangle [310, c-(i*26)+8], 15, 15 
        end
        font_size 8
        draw_text 'Pd', at: [312, c-(i*26) - 4]
        font_size 16

      end 
      move_down 230
      text '#Good ________  $Each ________'
      stroke{horizontal_line 0,350, at: cursor}

    end
  end

end