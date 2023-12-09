module Things
  class ConvertSettings
    attr_accessor :groups, :prefs
    # include Things::Utilities

    def initialize()
      @prefs = {
        3=> "{\"par_in\":\"443455434\",\"par_out\":\"453445344\",\"welcome\":\"Welcome!\",\"alert\":\"\",\"notice\":\"\",\"tee_time\":\"8:30am\",\"play_days\":\"\",\"dues\":6,\"skins_dues\":2,\"par3_dues\":2,\"other_dues\":0,\"truncate_quota\":true,\"pay\":\"sides\",\"limit_new_player\":false,\"limit_rounds\":0,\"limit_points\":2,\"limit_new_tee\":false,\"limit_new_tee_rounds\":1,\"limit_new_tee_points\":2,\"limit_frozen_player\":false,\"limit_frozen_points\":2,\"limit_inactive_player\":false,\"limit_inactive_days\":180,\"limit_inactive_rounds\":1,\"limit_inactive_points\":2,\"sanitize_first_round\":false,\"trim_months\":15,\"rounds_used\":10,\"use_hi_lo_rule\":false,\"default_stats_rounds\":100,\"use_keyboard_scoring\":false,\"default_in_sidegames\":true,\"use_autoscroll\":true}",
        4=> "{\"par_in\":\"434443455\",\"par_out\":\"443534445\",\"welcome\":\"Welcome to The Gaggle \\u003cbr/\\u003e Play on Mon, Wed, Fri and Sat at 8:00am\",\"alert\":\"\",\"notice\":\"\",\"tee_time\":\"8:00am\",\"play_days\":\"Mon, Wed, Fri, Sat\",\"dues\":8,\"skins_dues\":2,\"par3_dues\":0,\"other_dues\":0,\"truncate_quota\":false,\"pay\":\"places\",\"limit_new_player\":true,\"limit_rounds\":2,\"limit_points\":4,\"limit_new_tee\":false,\"limit_new_tee_rounds\":1,\"limit_new_tee_points\":2,\"limit_frozen_player\":false,\"limit_frozen_points\":2,\"limit_inactive_player\":false,\"limit_inactive_days\":180,\"limit_inactive_rounds\":1,\"limit_inactive_points\":2,\"sanitize_first_round\":true,\"trim_months\":18,\"rounds_used\":7,\"use_hi_lo_rule\":true,\"default_stats_rounds\":100,\"use_keyboard_scoring\":false,\"default_in_sidegames\":true,\"use_autoscroll\":true}",
        2=> "{\"par_in\":\"443455434\",\"par_out\":\"453445344\",\"welcome\":\"\",\"alert\":\"\",\"notice\":\"\",\"tee_time\":\"9:30am\",\"play_days\":\"\",\"dues\":6,\"skins_dues\":0,\"par3_dues\":4,\"other_dues\":0,\"truncate_quota\":false,\"pay\":\"sides\",\"limit_new_player\":true,\"limit_rounds\":1,\"limit_points\":2,\"limit_new_tee\":false,\"limit_new_tee_rounds\":1,\"limit_new_tee_points\":2,\"limit_frozen_player\":true,\"limit_frozen_points\":2,\"limit_inactive_player\":true,\"limit_inactive_days\":180,\"limit_inactive_rounds\":1,\"limit_inactive_points\":2,\"sanitize_first_round\":true,\"trim_months\":18,\"rounds_used\":10,\"use_hi_lo_rule\":false,\"default_stats_rounds\":200,\"use_keyboard_scoring\":false,\"default_in_sidegames\":true,\"use_autoscroll\":true}",
        1=> "{\"par_in\":\"443455434\",\"par_out\":\"453445344\",\"welcome\":\"Welcome to the Sinners  A group that normally plays on Mon, Wed and Fri at 9:30 am with 4 or 5 tee times\",\"alert\":\"\",\"notice\":\"\",\"tee_time\":\"9:30am\",\"play_days\":\"Mon, Wed, Fri\",\"dues\":6,\"skins_dues\":2,\"par3_dues\":2,\"other_dues\":0,\"truncate_quota\":true,\"pay\":\"sides\",\"limit_new_player\":true,\"limit_rounds\":2,\"limit_points\":2,\"limit_new_tee\":true,\"limit_new_tee_rounds\":1,\"limit_new_tee_points\":2,\"limit_frozen_player\":true,\"limit_frozen_points\":2,\"limit_inactive_player\":true,\"limit_inactive_days\":180,\"limit_inactive_rounds\":2,\"limit_inactive_points\":2,\"sanitize_first_round\":false,\"trim_months\":24,\"rounds_used\":10,\"use_hi_lo_rule\":false,\"default_stats_rounds\":100,\"use_keyboard_scoring\":true,\"default_in_sidegames\":true,\"use_autoscroll\":true}"
      }

      @groups = Group.all
      @groups.each do |g|
        g.preferences = nil
        g.preferences = g.settings.as_json
        g.save
      end
    end
  end
end
