module CalendarHelper
  class CalendarBuilder < TableHelper::TableBuilder

    def day(*args)
      raise ArgumentError, "Missing block" unless block_given?
      options = options_from_hash(args)
      day_method = options.delete(:day_method) || :date
      id_pattern = options.delete(:id)
      tbody do
        @calendar.objects_for_days(@objects, day_method).to_a.sort{|a1, a2| a1.first <=> a2.first }.each do |o|
          key, array = o
          day, objects = array
          concat(tag(:tr, options, true)) if(day.wday == @calendar.first_weekday)
          if @row_header && day.wday == @calendar.first_weekday
            row_header_options = td_options(day, id_pattern, objects)
            row_header_options[:class] ||= ""
            row_header_options[:class] << " row_header"
            concat(tag(:td, row_header_options, true))
            yield(day, nil)
            concat("</td>")
          end
          concat(tag(:td, td_options(day, id_pattern, objects), true))
          yield(day, objects)
          concat('</td>')
          concat('</tr>') if(day.wday == @calendar.last_weekday)
        end
      end
    end

    def td_options(day, id_pattern, objects)
      options = {}
      css_classes = []
      css_classes << 'today' if day.strftime("%Y-%m-%d") ==
@today.strftime("%Y-%m-%d")
      css_classes << 'notmonth' if day.month != @calendar.month
      css_classes << 'weekend' if day.wday == 0 or day.wday == 6
      css_classes << 'future' if day > @today.to_date
      css_classes << 'event' unless objects.empty?
      options[:class] = css_classes.join(' ') unless css_classes.empty?
      options[:id] = day.strftime(id_pattern) if id_pattern
      options
    end

  end
end
