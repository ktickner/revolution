module FeedHelper
    def genre_display(genres)
        count = genres.count
        
        case count
            when 0
                genre_display = '<p>There are no genres playing</p>'.html_safe
            when 1 
                genre_display = "<p><span class=\"highlight\">#{genres.first.name}</span> is playing</p>".html_safe
            else
                #tiny display
                genre_display = "<p class=\"tiny genres\">#{count} genres playing</p>".html_safe
                
                #small and medium display
                genre_display += "<p class=\"small genres\"><span class=\"highlight\">#{genres.first.name}</span> and <span class=\"highlight\">#{count - 1} other genres</span> are playing</p>".html_safe
                
                #large display
                genre_display += '<p class="large genres">'.html_safe
                genres[1..-2].each do |genre|
                   genre_display += "<span class=\"highlight\">#{genre.name}</span>, ".html_safe
                end
                genre_display += "and <span class=\"highlight\">#{genres[-1].name}</span> are playing</p>".html_safe
        end
    end
    
    def over_eighteen_display(over_eighteen)
       over_eighteen_display = '<span class="over-eighteen medium">18+</span>'.html_safe if over_eighteen == true
    end
end
