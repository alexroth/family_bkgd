# ruby class for console display
#
# Extracted 11/24/2010 as show_info from general_subs_20101025.rb
# Rev. 11/30/2010 to rename as display_info and set up as class
# ------------------------------------
# class DisplayInfo
#
#  Ruby class to display information in command-line window.
#
#  this_display_info = DisplayInfo.new(obj_to_show, max_line_width, max_rows, debug_flag)
#
# Written 11/01-04/2010, 11/17-18/2010/ 11/22-30/2010 A. D. Roth as redesign of show_data
# Rev. 12/09/2010 to simplify initialize
#---------------------------
class DisplayInfo
  attr_reader :process_q, :output_q  # for debug testing
  #  Constants for ----
  EN_ACTION = 0
  EN_LEVEL = 1
  EN_DESC = 2
  EN_CLASS = 3
  CALLING_CLASS = 4
  EN_MEMBER = 5
  EN_VALUE = 6
  #  class variables
  @row_data = Array.new  # array of strings, each one cell
  @col_info = Hash.new    # information on columns
  #  @col_census  -- eventually
  @data_table_info = Hash.new  # general information about the table
  def initialize( # obj_to_show, 
    max_line_width = 80, max_rows = 20, 
    return_value_flag = FALSE, debug_flag = FALSE)
    # @input_obj = obj_to_show
    @return_value_flag = return_value_flag
    @debug_flag = debug_flag
    @display_info = { "max_line_width" => 80, "max_rows" => 20 }
    # 1. determine if this is a data table; if not skip to step 3
    # 2.  extract info from table_info
    #     a.  determine whether multiple sectors will be needed

    # 3.  prepare the data for view command

    # 4.  general initializations
    @debug_flag = debug_flag
    @process_q = Array.new  # used by show_array: action, level, desc, class, calling class, member, value
  end
  #---------------------------
  # function view
  #
  # function to prepare lines for display of a data table (or lesser object)
  #
  # Written 10/25/2010, 11/24-28/2010 A. D. Roth as ShowInfo#show_data
  # Rev. 11/30/2010 to rename to DisplayInfo#view and rewrite
  # Rev. 11/03/2011 to replace ":" with "when" in case ... statements
  #---------------------------
  def view(name = "")  # name is an optional label for the top level or table
    def show_scalar(name)
      obj_to_show = ( @input_obj == @input_obj.to_i.to_s ? @input_obj.to_i : @input_obj )
      return [ "#{obj_to_show.class.to_s} '#{name}': #{obj_to_show.to_s}" ]
    end  # show_scalar
    # ------------------
    return_array = Array.new
    case @input_obj.class
      when Array then return_array = show_array(name, @input_obj)
      when Hash  then return_array = show_data_table(name, @input_obj, 
        return_value_flag, debug_flag)  # show data table must handle simple hash too
      else         return_array = show_scalar(name)
    end
    return_array.each { | entry | puts entry } unless @return_value_flag
    return return_array
  end  # view
  def fmt_indent(level)
    return (level == 0 ? "" : "#{level.to_s}") + " "*(level*3)
  end
  def fmt_member(entry)
    # puts "fmt_member about to process #{entry.inspect}"
    return (entry[EN_MEMBER].nil? ? "" : 
      (entry[CALLING_CLASS] == Hash ? "['#{entry[EN_MEMBER].to_s}']" : 
      "[#{entry[EN_MEMBER].to_s}]" ) )
  end
  def fmt_print_line(entry, desc)
    # puts "fmt_print_line about to process #{entry.inspect}"
    return fmt_indent(entry[EN_LEVEL]) + "[#{desc.nil? ? "" : desc}] #{entry.class}: #{entry[EN_VALUE].to_s}"
  end
  def process_composite(entry)
    # puts; puts "process_composite about to process #{entry.inspect}"
    # process_q << [ "Print", " "] unless entry[EN_LEVEL] == 0 # line separation between elements
    @process_q << [ "Print", fmt_indent(entry[EN_LEVEL]) + fmt_member(entry) + 
      " #{entry[EN_VALUE].class}" + (entry[EN_DESC].nil? ? "" : " '" + entry[EN_DESC] + "'") + ": " ]
    entry[EN_LEVEL] += 1
    if entry[EN_CLASS] == Array
      entry[EN_VALUE].each_with_index do | this_entry, this_index | 
        # puts; puts "With array, this_entry will be #{this_entry.inspect}"
        process_q << ([ Array, Hash].include?(this_entry.class) ? 
          # action, level, desc, class, calling class, member, value
          [ "Process", entry[EN_LEVEL], nil, this_entry.class, Array, this_index.to_s, this_entry] : 
          [ "Print", fmt_indent(entry[EN_LEVEL]) + 
          "[#{this_index.to_s}] #{this_entry.class}: #{this_entry.to_s}" ] )
          # [ "Print", 
          # (entry[EN_LEVEL] == 0 ? "" : "#{entry[EN_LEVEL].to_s}") + " "*indent + 
          # "#{this_entry.class} #{entry[EN_DESC]} [#{this_index}]: #{this_entry.to_s}"] ) }
      end
    else  # hash
      entry[EN_VALUE].each do | this_key, this_entry | 
        # puts; puts "With not array, this_entry will be #{this_entry.inspect}"
        @process_q << ([ Array, Hash ].include?(this_entry.class) ? 
          # action, level, desc, class, calling_class, member, value
        [ "Process", entry[EN_LEVEL], nil, this_entry.class, Hash, this_key, this_entry] : 
        [ "Print", fmt_indent(entry[EN_LEVEL]) + 
          "['#{this_key}'] #{this_entry.class}: #{this_entry.to_s}" ] )
        #  [ "Print", (entry[EN_LEVEL] == 0 ? "" : "#{entry[EN_LEVEL].to_s}") + 
        #  " "*indent + "['#{this_key}'] #{this_entry.class}: #{this_entry.to_s}" ] ) }
      end
    end
  end
  def process_current(entry)
    # @process_q = Array.new  # action, level, desc, class, calling_class, member, value
    # puts; puts "process_current about to process entry: #{entry.inspect}"
    ( [ Array, Hash].include?(entry[EN_CLASS]) && (entry[EN_LEVEL] < 20) ? 
      process_composite(entry) :
      # else treat this item entirely as scalar; no further processing
      @process_q << [ "Print", fmt_print_line(entry, entry[EN_DESC]) ] )
        # [ "Print", (entry[EN_LEVEL] == 0 ? "" : entry[EN_LEVEL].to_s) + 
        # " "*indent + entry[EN_TYPE].to_s + " " + entry[EN_DESC] + ":  #{entry[6]}" ]
  end
  def show_array(desc, input_data, member="Item", return_value_flag=FALSE)
  #   calls process_current to build process_q and output_q, then outputs
    # build first process queue entry
    old_process_q = Array.new if old_process_q.nil?
    old_process_q.clear
    @process_q = Array.new if process_q.nil?
    @process_q.clear
    ( [ Array, Hash ].include?(input_data.class) ? 
      process_current(["Process", 0, desc, input_data.class, String, nil, input_data]) : 
      @process_q << [ "Print", "#{input_data.class} #{desc}: #{input_data}" ] 
    )
    # go through process q and rerun each "Process" entry
    until @process_q.assoc("Process").nil?
      # puts; puts "starting process_q run; process_q has #{@process_q.count} entries."; puts
      old_process_q.replace(@process_q)
      @process_q.clear
      old_process_q.each do | entry | 
        # puts "in show_array, current old_process_q entry is #{entry.inspect}" 
        entry[EN_ACTION] == "Process" ? process_current(entry) :  @process_q << entry 
      end
    end
    @process_q.each { | entry | puts entry[EN_LEVEL] if entry[0] == "Print" } unless return_value_flag
    old_process_q.clear
    return @process_q
  end  #  show_array
  # ------------------------------------
  # det_col_widths
  #
  # Ruby 1.8 method to create an array of the max. widths of each column
  #
  # Written 10/27/2010-11/27/2010 A. D. Roth
  # ------------------------------------
  def det_col_widths(input_array)
  # determine content longest col. widths for an array of hashes (for a table object, the
  # array of row hashes); returns hash keyed to colheads
    all_col_widths = Hash.new
    show_array("on entry to det_col_widths, input_array is", input_array)
    input_array.each do | record_hash | 
      show_array("record_hash", record_hash)
      record_hash.each do | key, col | 
        puts "key is #{key} and col is #{col}"
        all_col_widths[key] = 0 if all_col_widths[key].nil?
        all_col_widths[key] = col.length if col.length > all_col_widths[key]
      end
    end
    return all_col_widths
  end   # det_col_widths
  # -----------------------------------
  # make_sheets
  #
  # Ruby 1.8 method to create a sheet_array, showing the number and coordinates
  # of pieces ("sectors") needed to display the full table.
  #
  # sheet_array consists of: sequence, col_origin, row_origin, col_last, row_last
  #
  # Written 10/27/2010, 11/07/2010 A.D. Roth as make_sheets
  # Rev. 11/19-28/2010 to expand return array to include end points; also reorder
  #                 array to seq, col_origin, row_origin, col_last, row_last
  # ------------------------------------
  def make_sheets(table_info, debug_flag, max_line_width = 80, min_col_width = 6, 
    max_display_rows = 20, separation = 3)  
    # -----------------------------------
    def count_sections_allowing_fraction(integer, max_value)  
    # returns nil for zero max_value, otherwise smallest integer quotient + 1 for any remainder
      # puts "count_sections_allowing_fraction called with integer #{integer} and max_value of #{max_value}  "
      return (max_value.nil? ? nil : (integer / max_value) + ( ( integer % max_value ) > 0 ? 1 : 0))
    end
    # -----------------------------------
    def det_col_divs(table_info, all_col_widths, max_line_width, separation)
      # puts;puts "on entry to det_col_divs, max_line_width is #{max_line_width}"
      show_array("table_info", table_info)
      # max_col_width will default to about 1/2 of line_width
      max_col_width = (max_line_width - separation) / 2
      # determine longest col. widths for an array of hashes; returns array
      col_divs = Array.new
      col_div_seq = 0
      curr_col_origin = 0
      curr_sheet_width = 0
      curr_sheet_col_count = 0
      table_info["table_data"].each do | line_hash |   # for each line
        table_info["col_info"]["table_heads"].each do | col_head |  # for each header in order
          if line_hash.has_key?(col_head) 
            sheet_tbl_head_list << col_head
            # all_col_widths[col_head] = 0 if all_col_widths[col_head].nil?
            # all_col_widths[col_head] = line_hash[col_head].length if 
            #   line_hash[col_head].length > all_col_widths[col_head]
            if curr_sheet_width > max_col_width
              col_divs << [ col_div_seq, curr_col_origin, curr_col_origin + curr_sheet_col_count - 1 ]
              sheet_seq += 1
              curr_col_origin += curr_sheet_col_count
              curr_sheet_col_count = 0
            else
              curr_sheet_col_count += 1
            end
          end
        end
      end
      total_width = 0
      table_info["col_info"]["col_widths"].each { | width | total_width += width }
      col_divs = [ [ 0, 0, total_width - 1 ] ] if col_divs == []
      return col_divs
    end  # det_col_divs
    # -----------------------------------
    puts if debug_flag; puts "On entry to make_sheets:" if debug_flag
    sheet_array = Array.new
    # det. population col. count
    show_array( "table_info is of class #{table_info.class}", table_info) if debug_flag
    show_array( "col_info is", table_info["col_info"] ) if debug_flag
    unless table_info.nil? || !(table_info.instance_of? Hash)
      puts "table_info is class #{table_info.class} and table_info.has_key?(\"col_info\") is " +
        table_info.has_key?("col_info").inspect if debug_flag
      if((table_info.instance_of? Hash) && table_info.has_key?("col_info"))
        all_row_count = (table_info.has_key?("table_data") ? table_info["table_data"].count : 0 )
        puts "all_row_count is #{all_row_count.inspect}" if debug_flag
        # col_info includes has_header_line, tbl_heads, tbl_col_max  (eventually also 
        # column descrip. info and data dict. info)
        col_info = table_info["col_info"]
        show_array( "col_info is", table_info["col_info"] ) if debug_flag
        all_col_count = (col_info.has_key?("has_header_line") ? 
          [ table_info["col_info"]["col_widths"].count, 
          col_info["tbl_col_max"]].max : table_info["col_info"]["col_widths"].count)
        if debug_flag
          puts; puts "all_col_count is  #{all_col_count.inspect}, " + 
            "max_display_rows is  #{max_display_rows.inspect}, " + 
            "min_col_width is  #{min_col_width.inspect}" 
          puts "separation is  #{separation.inspect}, and max_line_width is #{max_line_width.inspect}"
        end
        col_divs = Array.new  # array of arrays: seq_for_cols, origin_col
        row_division_count = count_sections_allowing_fraction(all_row_count, max_display_rows)
        total_width = all_col_count * min_col_width + (all_col_count - 1) * separation
        if total_width > max_line_width 
          # multiple sheets needed for columns
          # puts "multiple sheets needed for columns"
          col_divs = det_col_divs(table_info["table_data"], 
            table_info["table_data"]["col_widths"], max_line_width, separation)
        else
          col_divs = [[ 0, 0, all_col_count - 1 ]]
        end
        show_array("col_divs", col_divs)
        row_origin = 0
        if all_row_count > max_display_rows
          # puts "multiple sheets needed for rows"
          # for each col. div., div. rows
          curr_last_row = 0
          # puts "curr_last_row initialized to #{curr_last_row}"
          col_divs.each do | one_col_div | 
            1.upto( row_division_count ) do | row_idx |
              # puts "row_origin is #{row_origin}, max_display_rows is #{max_display_rows}, " + 
                # "row_origin + max_display_rows is #{row_origin + max_display_rows}, " + 
                # "all_row_count is #{all_row_count}"
              curr_last_row = [ row_origin + max_display_rows, all_row_count ].min - 1
              # puts "curr_last_row now #{curr_last_row}"
              sheet_array << [ one_col_div[0]*row_division_count + row_idx - 1, 
                one_col_div[1], row_origin, one_col_div[2], curr_last_row ]
              row_origin = curr_last_row + 1
            end  
          end
        else  # one row_div; transfer the col_divs
          col_divs.each { | one_col_div | sheet_array << [ one_col_div[0], 
            one_col_div[1], 0, one_col_div[2], all_row_count - 1 ] }
        end
      end
    else
      sheet_array = [ 0, 0, 0, 0, 0 ]
    end
    return sheet_array
  end
  # ------------------------------------
  # col_calculate
  #
  #    Ruby 1.8 method to determine start points for columns in a table put out 
  # to the comand window, starting with position 0.
  # 
  #    The return value is nil if there are too many columns for the max width.
  #
  #    The returned array is start pos, starting with zero, of each column, plus
  # a final entry for the position after the last column.
  #
  # Written 10/26-27/2010 as col_calculate
  # Rev. 11/28/2010 to move into ShowInfo class
  # ------------------------------------
  def col_calculate(orig_col_widths, # input col widths
    hdr_widths, # input header widths for the same cols.
    debug_flag=FALSE,
    max_line_width=80, # max. width permitted for output line
    min_col_width=2,  # min. permitted col. width for output line
    min_separator=3 # min. col. separation for output line
  )
    return_array = Array.new
    show_obj = ShowInfo.new
    col_count = [orig_col_widths.count, hdr_widths.count].max
    puts "min_separator is #{min_separator}"
    if((col_count * min_col_width) + 
       ((col_count - 1) * min_separator) > max_line_width)
      # too many columns; return nil
      puts " too many columns; return nil" if debug_flag
      return_array = nil
    elsif [sum_integer_array(orig_col_widths), sum_integer_array(hdr_widths)].max <= 
      max_line_width  # calculate col positions
      # fine as is
      puts "fine as is; for max_line_width of #{max_line_width}, " + 
        "sum_integer_array(orig_col_widths) was " + 
        "#{sum_integer_array(orig_col_widths)} and " + 
        "sum_integer_array(hdr_widths) was #{sum_integer_array(hdr_widths)}" if debug_flag
      pos = 0
      orig_col_widths.each_with_index { | width, idx | 
        return_array[idx] = pos; pos += min_separator + 
        [[ width, hdr_widths[idx] ].max, min_col_width].max }
      return_array << max_line_width
    else  # calculate the squeezed positions
      # set up working_col_widths
      puts "calculate the squeezed positions" if debug_flag
      min_cols_count = 0  # count of cols. at min.width
      long_length = 0   # sum of widths of cols. longer than min.
      working_col_widths = Array.new
      orig_col_widths.each_with_index { | width, idx | 
        ([ width, hdr_widths[idx] ].max <= min_col_width ? 
        (working_col_widths[idx] = min_col_width; min_cols_count += 1) : 
        (working_col_widths[idx] = [ width, hdr_widths[idx] ].max; long_length += width)) }
      show_obj.show_array("working_col_widths", working_col_widths, "Item")
      # determine remaining space for cols with length > min.; how many cols
      # make initial determination based on raw mean 
      # adjust for shorter columns
      long_cols_count = col_count - min_cols_count
      min_space = min_cols_count * (min_col_width + min_separator)  # space taken by cols. of min. length
      puts "min_space is #{min_space}" if debug_flag
      allowed_long_space = ((max_line_width - min_space) - (min_separator * (long_cols_count - 1)))
      puts "allowed_long_space is #{allowed_long_space}" if debug_flag
      rough_max_col_width = allowed_long_space / long_cols_count
      allowed_max_col_width = rough_max_col_width
      puts "allowed_max_col_width starts out as #{allowed_max_col_width}" if debug_flag
      working_col_widths.each do | width | 
        if (width > min_col_width) && (width < rough_max_col_width)
          long_cols_count -= 1
          (long_cols_count > 0 ? 
            allowed_max_col_width += (rough_max_col_width - width)/long_cols_count : # reduce max
            allowed_max_col_width = max_line_width)  # squeezing no longer matters 
          puts "after width #{width}, allowed_max_col_width now #{allowed_max_col_width}" if debug_flag
        end
      end      
      # set result_array
      pos = 0
      working_col_widths.each_with_index do | width, idx | 
        increment = (width > allowed_max_col_width ? allowed_max_col_width : width)
        return_array[idx] = pos; pos += min_separator + increment
      end
      return_array << max_line_width
    end
    puts "col_calculate returning return_array of #{return_array.inspect}" if debug_flag
    return return_array
  end  # end col_calculate
  # ------------------------------------
  # method select_rows
  #
  # Ruby 1.8 method to convert table data in an array of hashes to an array 
  # of string arrays, one per row, based on display heads, beginning with line no.
  #
  # Written 05/23-26/2010 A. D. Roth as TableDisplay#convert_to_display
  # Rev. 10/27/2010-11/27/2010 to adapt to new design, as select_rows
  # ------------------------------------
  def select_rows(origin, offset, display_heads, table_data, debug_flag=FALSE)
    def set_up_one_display_row(display_heads, row_hash, line_no, debug_flag)
      display_row = Array.new
      display_row[0] = line_no.to_s
      # puts "display_heads is " + display_heads.inspect + 
      #   " row-hash is #{row_hash.inspect} and line_no is " + line_no.inspect if debug_flag
      display_heads.each { | head | (defined? row_hash[head] ? 
        display_row << row_hash[head] : display_row << "" ) }
      puts "individual row array is #{display_row.inspect}" if debug_flag
      return display_row
    end  #  set_up_one_display_row
    # puts "Entering select_rows, "
    # show_array("table_data is", table_data)
    display_data = Array.new
    line_no = origin
    table_data[origin, offset].each { | line | 
      display_data << set_up_one_display_row(display_heads, line, line_no, debug_flag); line_no += 1 }
    show_array("display data from select_rows", display_data, "Row") if debug_flag
    return display_data
  end # select_rows
# ------------------------------------
# draw_rule
#
# Draws a rule (to console).
#
# Written 05/07-08/2010 A. D. Roth
# Added to table_display include file 08-03-2010
# Rev. 11/29/2010 to include in ShowInfo class
# Rev. 11/03/2011 to replace "–" with "-" (hyphen)
# ------------------------------------
def draw_rule(width)
  return ["-"]*width
end # draw_rule
  # ------------------------------------
  # print_title_lines
  #
  # Ruby 1.8 method to display title line for a data table
  #
  # Rewritten from scratch 11/28-29/2010 A. D. Roth
  # ------------------------------------
  def print_title_lines(this_display)
    line_to_print = ( this_display["file_name"] ? this_display["file_name"] : "")
    if this_display["descrip"]
      displacement = " "*( this_display["line_size"] - line_to_print.length )
      line_to_print += displacement + this_display["descrip"]      
    end    
    result_array << draw_rule(this_display["line_size"])
    result_array << line_to_print
    result_array << draw_rule(this_display["line_size"])
    return result_array
  end  # print_title_lines
  # ------------------------------------
  # method squeeze_and_break_cell(cell, size) 
  #
  # Ruby 1.8 method to display one cell within the designated width, breaking
  # the string as needed.
  #   5/30/2010 holding off on further development at present.
  #
  # Written 05/28/2010 A. D. Roth
  # Rev. 11/28/2010 to move into class ShowInfo
  # ------------------------------------
  def squeeze_and_break_cell(cell, size)
    puts "on entry to squeeze_and_break_cell, cell is " + cell.inspect + 
      " and size is " + size.inspect if(@debug_flag)
    width = cell.length
    origin = 0
    if(width <= size)
      print cell.ljust(size)
    else
      while(width > size) do  # really need to save the pieces to show in parallel
        puts cell.slice(origin,size)
        origin += size
        width -= size
      end
      print cell.slice(origin,width).ljust(size) if(width > 0)
    end
  end #  squeeze_and_break_cell
  # ------------------------------------
  # method print_header_line 
  #
  # Ruby 1.8 method to display one line proportionately to the table, where
  # the cols array are the values only.
  #
  # Written 05/26-31/2010 A. D. Roth
  # Rewritten 11/28-29/2010 to move into class ShowInfo
  # ------------------------------------
  def print_header_lines(this_display, debug_flag)
    result_array = Array.new
    header_line = " "*this_display["col_info"]["col_starts"][1]
    this_display["col_info"]["tbl_heads"].each_with_index { | head, index | 
      # squeeze_and_break_cell(head, start_points[index + 2] - start_points[index + 1] - separation) }
      header_line += head.ljust(this_display["col_info"]["col_starts"][index + 2] - 
        this_display["col_info"]["col_starts"][index + 1]) }
    return_array << header_line
    return_array << " "
    return_array << draw_rule(this_display["line_size"])
    return header_line
  end #  print_header_line
  # ------------------------------------
  # method print_table_line(cols, start_points) 
  #
  # Ruby 1.8 method to display one line proportionately to the table, where
  # the cols array are the values only.
  #
  # Written 05/26/2010 A. D. Roth
  # Rev. 10/26/2010 to simplify
  # Rev. 11/28-29/2010 to move into class ShowInfo
  # ------------------------------------
  def print_table_line(cols, start_points)
    this_line = ""
    cols.each_with_index { |col, index| this_line += (col.nil? ? 
      "" : col).ljust(start_points[index + 1] - start_points[index]) }
    return this_line
  end #  print_table_line
  # ------------------------------------
  # show_one_sheet
  #
  # Ruby 1.8 method to display one sheet of a table.
  #
  # Written 11/25-29/2010 from show_data_table
  # ------------------------------------
  def show_one_sheet( this_display, debug_flag = FALSE )
    show_array("On entry to show_one_sheet, this_display is ", this_display) if debug_flag
    result_array = Array.new
    header_widths = this_display["col_info"]["tbl_heads"].collect { | head | head.length  }
    this_display["col_info"]["col_starts"] = 
      col_calculate( this_display["col_info"]["col_widths"], header_widths, 
      debug_flag, max_line_width, min_col_width, separation)
    this_display["line_size"] = this_display["col_info"]["col_starts"].last + 
      this_display["col_info"]["col_starts"].last.length
    # draw title line
    title_lines = print_title_line( this_display )
    result_array.concat( title_lines )
    # draw col. headers
    result_array.concat( print_header_lines( this_display, return_value_flag, debug_flag ) )
    # (return_value_flag ? return_array << " " : puts)
    #   now draw each line in table
    this_display["display_rows"].each { |row| result_array << print_table_line(row, 
      this_display["col_info"]["col_starts"]) }
    # puts "line is " + row.inspect
    result_array << draw_rule(this_display["line_width"])
    # draw finish up of table
    puts "returning from show_one_sheet" if debug_flag
    return result_array
  end  # show_one_sheet
  # ------------------------------------
  # show_data_table
  #
  # Ruby 1.8 method to display table.
  #
  # Written 05/26/2010 A. D. Roth
  # Rev. 06/04/2010 to add selection menu after table display 
  # Rev. 10/25-26/2010 TableDisplay#view method revised for use with show_data
  # Rev. 11/19/2010 to improve comments; then development to continue
  # Rev. 11/24-29/2010 to continue development
  # ------------------------------------
  def show_data_table(name, # name and title of table
    table_info, # hash of table info
    return_value_flag=FALSE, # TRUE = return string array of results as well as printing them
    debug_flag=FALSE,  # TRUE = print debugging statements
    max_line_width = 80, # max. width of a line
    default_display_row_max = 20, # default max. no. of rows to display
    min_col_width = 6, # min. col. width
    max_display_rows = 20, # max. rows to display
    separation = 3 # no. of spaces between columns
  )
    def prep_sheet( this_sheet, this_display_info, max_line_width, debug_flag )
        show_array("this_sheet now", this_sheet) if debug_flag
        this_display_info["sheet_info"] = this_sheet
        curr_heads = table_info["col_info"]["tbl_heads"][this_sheet[1], this_sheet[3] + 1]
        show_array("display heads will be ", curr_heads) if debug_flag
        display_col_widths = table_info["col_info"]["col_widths"][this_sheet[1], this_sheet[3] + 1]
        show_array("curr_heads will be:", curr_heads) if debug_flag
        this_display_info["col_info"]["tbl_heads"] = curr_heads
        this_display_info["col_info"]["tbl_col_max"] = curr_heads.count
        this_display_info["col_info"]["col_widths"] = display_col_widths
        this_display_info["max_line_width"] = max_line_width
        this_display_info["display_rows"] = select_rows(this_sheet[2], 
          this_sheet[4] + 1, curr_heads, table_info["table_data"])
        show_array("rows will be", this_display_info["display_rows"]) if debug_flag
    end
    puts "Entering 'show_data_table,'"
    show_array("table_info on entry", table_info) if debug_flag
    return_array = Array.new
    # det. whether "table_info" is only a simple hash and not a data table
    show_array( "col_info is", table_info["col_info"] ) if debug_flag
    puts "debug_flag is #{debug_flag.inspect}"
    if table_info.has_key?("col_info")
      # det. how many sheets are needed 
      # (a sheet is a horiz and vertical piece of the full table)
      col_widths = Array.new
      col_widths = det_col_widths(table_info["table_data"])
      table_info["col_info"]["col_widths"] = col_widths
      show_array( "col_widths are", table_info["col_info"]["col_widths"] ) if debug_flag
      sheet_list = make_sheets(table_info, debug_flag, max_line_width, 
        min_col_width, max_display_rows, separation)  # returns array of integer arrays: sequence (of sheet), col. origin, row origin, last col, last row
      # table_info = {"file_name" => f, "col_info" => @col_info, 
      #   "col_descrips_file" => @col_descrips_file, 
      #   "data_dict_file" => @data_dict_file, "table_data" => @table_data }
      # col_info = { "has_header_line" => @has_header_line, 
      #   "tbl_col_max" => tbl_col_max, "tbl_heads" => @tbl_heads } "tbl_col_max" is tbl_col_count
      this_display_info = { "descrip" => table_info["descrip"], 
        "col_info" => {"has_header_line" => table_info["col_info"]["has_header_line"],
          "col_widths" => table_info["col_info"]["col_widths"] }
      }
      sheet_list.each do | this_sheet |
        this_display_info.merge( prep_sheet( this_sheet, this_display_info, 
          max_line_width, debug_flag ) )
        return_array.concat( show_one_sheet( this_display_info, debug_flag ) )
      end
    else  # treat as simple hash
      puts "treating as simple hash because no key of 'col_info'" if debug_flag
      return_array = show_array(name, table_info, "Item", return_value_flag)      
    end
    result_array << draw_rule(col_starts.last, return_value_flag)
    return result_array
  end # method show_data_table
end # class ShowInfo

