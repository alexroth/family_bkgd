require 'date'
require 'parsedate'
#  move this constant to ancestors controller for tree_show there: EMPTY_CELL = { "npr" => "", "nname" => "", "ncoun" => "", "id" => "", "entrant_id" => "", "nyr" => "", "ncen" => "", "ncolor" => "", "ngend" => "", "n3gen" => "" }
#
# require 'criteria_constants'
# ---------------------------------
# general_helpers201109.rb
#
# general ruby support methods, second part
#
# As of 08/16/2012:
#   [ def field_type( s_in ) ]
#   def convert_array_to_line( input_array )
#   def convert_hash_to_line( input_hash )
#   def convert_hash_ordered_to_line( col_order, input_hash )
#   def class_method?( obj, method_name )
#   def convert_record_to_line( input_record )
#   def convert_record_array_to_lines( input_array )
#   def prep_tree_info( record, generation_count = 5, debug_flag = false )
#   def get_created_on
#   def fmt_yr_cen_to_yyyy(yr, cen)
#   def show_field_if_populated( field, label )
#   def set_up_repeat_counts( input_array, heads, debug_flag = false )
#   def prep_report( input_array, detail_col_heads, heads_array, action = [ "normal" ], debug_flag = false )
#   def exists_nonblank_hash_element?( hash, key )
#
# Written 09/02/2011-08/16/2012 A. D. Roth
# ------------------------------------
# method field_type
#
# This method determines whether the input string
# is an integer, string, or date.
#
# Written 04/24/2010 A. D. Roth from Pickaxe p. 360
# -----------------------------------------
def field_type( s_in )
end  #  field_type
    # -----------------------------------
    # convert_array_to_line
    # 
    # Written 09/26/2011 A. D. Roth
    # Rev. 08/06/2012 to add debugging statement
    # Rev. 08/07/2012 to attempt replacement of h.to_s with #{ h.inspect }
    # Rev. 08/08/2012 to simplify
    # Rev. 08/09/2012 to add member count at end
    # -----------------------------------
    def convert_array_to_line( input_array )
      #  puts "entering convert_array_to_line" if @debug_flag
      result_string = ""
      limit = ( input_array.class == Array ? 
          input_array.length - 1 : input_array.class.length )
      input_array.each_with_index { | h, index | result_string += "#{ h.inspect }, " }
      case input_array.length
      when 0 : str_len = "No"
      when 1 : str_len = "one"
      else
        str_len = input_array.length.to_s
      end
      result_string += str_len + " member" + ( str_len == "one" ? "." : "s." )
      return result_string
    end  #  convert_array_to_line
    # -----------------------------------
    # convert_hash_to_line
    # 
    # Written 09/26-10/13/2011 A. D. Roth
    # Edited 02/16/2012 to change "=" to "=>"
    # -----------------------------------
    def convert_hash_to_line( input_hash )
      result_string = ""
      prec_comma = ", "
      limit = input_hash.length - 2
      index = 0
      input_hash.each do | key, h |
        # puts "Next item is #{ key.inspect } => #{ h.inspect }"
        result_string += "#{ key } => #{ h }" + prec_comma
        prec_comma = "" if index == limit
        index += 1
      end
      return result_string
    end  #  convert_hash_to_line
    # -----------------------------------
    # convert_hash_ordered_to_line
    # 
    # Written 01/30/2012 A. D. Roth based on convert_hash_to_line
    # Edited 02/16/2012 to change "=" to "=>"
    # -----------------------------------
    def convert_hash_ordered_to_line( col_order, input_hash )
      result_string = ""
      prec_comma = ", "
      # limit = input_hash.length - 2
      index = 0
      #  input_hash.each do | key, h |
      col_order.each do | key |
        # puts "Next item is #{ key.inspect } => #{ h.inspect }"
        unless input_hash[ key ].nil?
          result_string += prec_comma if result_string.length > 0
          result_string += "#{ key } => " + input_hash[ key ]
          # prec_comma = "" if index == limit
        end
        index += 1
      end
      return result_string
    end  #  convert_hash_ordered_to_line
    # -----------------------------------
    # class_method?
    # 
    # Return true if class class_name has method method_name defined.
    #
    # Written 07/31/2011 A. D. Roth
    # Rev. 08/02-07/2012 this didn't work!
    # -----------------------------------
    def class_method?( obj, method_name )
      #  puts "class_method? method checking for '#{ method_name }' for class '#{ obj.inspect }'" if @debug_flag
      #  puts "Result will be " + ms_flag_tf( obj.methods.include?( method_name ) )
      return obj.methods.include?( method_name )
    end  #  class_method?
    # -----------------------------------
    # convert_record_to_line
    # 
    # Written 10/13/2011 A. D. Roth
    # Rev. 07/30-08/07/2012 to permit change of location of schema -- and debug!!
    # Rev. 08/19/2012 to add class String and to simplify
    # -----------------------------------
    def convert_record_to_line( input_record )
      #  puts "entering convert_record_to_line with input_record of class #{ input_record.class }" if @debug_flag
      result_string = ""
      prec_comma = ", "
      index = 0
      if input_record.class == Array
        result_string = convert_array_to_line( input_record )
      elsif input_record.class ==  Hash
        result_string = convert_hash_ordered_to_line( input_record.keys.sort, input_record )
      elsif input_record.class ==  String
        result_string = input_record
      elsif class_method?( input_record.class, "columns" )
        limit = input_record.class.columns.length - 2
        col_heads = Array.new
        input_record.class.columns.each_with_index { | one_col, one_idx | col_heads << one_col.name }
        #  puts "col_heads is " + convert_array_to_line( col_heads ) + 
        #      " and col_heads.sort is " + convert_array_to_line( col_heads.sort )
        #  puts; puts "In convert_record_to_line, limit will be #{ limit }, because " + 
        #      "input_record.class.columns.length - 2 is #{ input_record.class.columns.length - 2 }"
        col_heads.sort.each do | one_col |
          h = input_record[ one_col ]
          #  puts "Next item is #{ one_col.inspect } => #{ h.inspect }"
          result_string += "#{ one_col } => '#{ h }'" + prec_comma
          prec_comma = "" if index == limit
          index += 1
         end
      end
      return result_string
    end  #  convert_record_to_line
    # -----------------------------------
    # convert_record_array_to_lines
    # 
    # Written 08/05-07/2012 A. D. Roth
    # -----------------------------------
    def convert_record_array_to_lines( input_array )
      result_string = ""
      input_array.each_with_index { | h, index | 
          result_string += convert_record_to_line( h ) + "\n" } if input_array.length > 0
      return result_string
    end  #  convert_record_array_to_lines
  # -----------------------------------------------------------
  # prep_tree_info
  #
  # entrant is an instance of the class.
  #
  # Written 10/05-06/2011 based on do_tree_show in ancestors_helper.rb
  # -----------------------------------------------------------
  def prep_tree_info( record, generation_count = 5, debug_flag = false )
    # -----------------------------------------------------------
    # extract_cells
    #
    # Adapted 10/05/2011 from do_tree_show in ancestors_helper.rb
    # -----------------------------------------------------------
    def extract_cells( this_entrant, gen_limit = 5, orientation = "horizontal", 
        debug_flag = false )  # entrant, no. of generations
# = extract_cells( record, generation_count, "vertical" )
      # -----------------------------------------------------------
      # load_cell
      #
      # Adapted 10/05/2011 from do_tree_show in ancestors_helper.rb
      # -----------------------------------------------------------
      def load_cell( curr_entrant, debug_flag = false )
        cell_hash = Hash.new
        if curr_entrant.nil? || curr_entrant["id"].nil? || curr_entrant["id"] == ""
          cell_hash = EMPTY_CELL
        else   # if adding any field names, also add them to EMPTY_CELL constant above
          # [ "npr", "nname", "ncoun", "id", "entrant_id", "nyr", "ncen", "ncolor", 
          #       "ngend", "n3gen" ].each { | key | 
          EMPTY_CELL.keys.each { | key | 
                cell_hash[ key ] = ( curr_entrant[ key ].nil? ? "" : curr_entrant[ key ]) }
        end
        #  puts "cell_hash " + cell_hash.inspect + " in load_cell" if debug_flag
        return cell_hash
      end  # load_cell
      # -----------------------------------------------------------
      # set_up_one_gen
      #
      # Adapted 10/05/2011 from do_tree_show in ancestors_helper.rb
      # -----------------------------------------------------------
      def set_up_one_gen( n, cell_array )
        # -----------------------------------------------------------
        # set_up_one_parent
        #
        # Example:  cell_array[ 2 * n + 1 ] = set_up_one_parent( "ns_id" ) 
        #
        # Adapted 10/05/2011 from do_tree_show in ancestors_helper.rb
        # -----------------------------------------------------------
        def set_up_one_parent( fld )  #  fld is "ns_id" or "nd_id"
          #  also uses @curr_entrant
          curr_parent = EMPTY_CELL
          curr_parent = Ancestor.find_by_id(@curr_entrant[ fld ] ) unless 
              ( @curr_entrant.nil? ) || ( @curr_entrant[ fld ].nil? ) || 
              ( @curr_entrant[ fld ].to_s.strip.length == 0 )  || ( @curr_entrant[ fld ] == "" )
          # @show_obj.show_array("#{ fld } in extract_cells#set_up_one_gen#set_up_one_parent now", 
          #     curr_parent )
          # puts "curr_parent now " + curr_parent.inspect + 
          #     " in extract_cells#set_up_one_gen#set_up_one_parent"
          return_hash = load_cell( curr_parent ) unless curr_parent.nil?
          return return_hash
        end  #  set_up_one_parent
        # ------------ set_up_one_gen MAIN ----------------------------
        #  puts; puts "---------------- processing n = #{n} -----------"
        @curr_entrant = ( ( cell_array[ n ][ "id" ].nil?) || ( cell_array[ n ][ "id" ] == "" ) ? 
            EMPTY_CELL : Ancestor.find( :first, :conditions => ["id = ?", cell_array[ n ][ "id" ]] ) )
        # @show_obj.show_array("curr_entrant", @curr_entrant, "Item") 
        # puts "curr_entrant now " + @curr_entrant.inspect + " in extract_cells"
        return [ set_up_one_parent( "ns_id" ), set_up_one_parent( "nd_id" ) ]
      end  # set_up_one_gen
      # ------------ extract_cells MAIN ----------------------------
      puts "record on entry to extract_cells: " + record.inspect + 
          " of class #{ record.class }" if debug_flag
      puts "record has the following keys: " + convert_array_to_line( record.keys ) if debug_flag
exit
#    curr_class = record.class
      # generate vertical table (top row, then second generation on second row, etc.)
      max_cell = 2**gen_limit
      cell_array = Array.new
      cell_array[0] = load_cell( this_entrant )
      0.upto( gen_limit ) do | gen |  # for each generation
        ((2**gen) - 1).upto((2**(gen + 1)) - 2) do | n |  
          puts; puts "---------------- processing n = #{n} -----------"
          result_array = set_up_one_gen( n, cell_array )
          cell_array[ 2 * n + 1 ] = result_array[ 0 ]
          cell_array[ 2 * n + 2 ] = result_array[ 1 ]
        end  # upto    n
        puts "cell_array :" + cell_array.inspect + " in extract_cells" if debug_flag
      end  #  upto    gen
      return cell_array
    end  # extract_cells
    # ------------ prep_tree_info MAIN ----------------------------
    curr_class = record.class
    @cell_array = extract_cells( record, generation_count, "vertical" )  #  array of [ type, gen_limit, tbl_array ]
    #  tbl_array is of [ n, gen, entry_seq, data_hash ]
    if record.name then  #  later fill in fields
      @name = record.nname
      @id = record.id.to_s
    else
      flash.now[:notice] = "This name not on file"
      @name = ""
    end
    puts "prep_tree_info returning @cell_array with " + ( @cell_array.nil? ? "nil" : @cell_array.length ) + " members."
  end  # prep_tree_info
# -----------------------------
def get_created_on
  require 'date'
  require 'parsedate'
  return DateTime.now.to_s[0,10]
end
#---------------------------
# fmt_yr_cen_to_yyyy
#
# Written 11/10/2010 A. D. Roth
# ------------------------------
def fmt_yr_cen_to_yyyy(yr, cen)
  return_str = ( (cen.class == Fixnum) ? pad_digit_to_str2( cen ) : "--" ) + ( (yr.class == Fixnum) ? pad_digit_to_str2( yr ) : "--" )
end  #  fmt_yr_cen_to_yyyy
#---------------------------
# show_field_if_populated
#
# Written 04/08/2012 A. D. Roth
# Rev. 08/16/2012 to make 'label' optional
# ------------------------------
def show_field_if_populated( field, label = '' )
  return_str = ( ( field.nil? || field.to_s == '' ) ? '' : label.to_s + field.to_s )
end  #  show_field_if_populated
#---------------------------
# set_up_repeat_counts
#
#    This method takes an input array (probably a record) and determines how
# many times each header is repeated.  Header fields are identified by the heads
# array of strings. The method analyzes the input array backwards and develops
# an array of arrays.  Each entry in the output array has a count for each 
# header, in the order given in heads array. So the output array entry says
# whether this header in this record is repeated immediately after in the next
# record.
#    Input array is an array of hashes.  Heads is an array of hash keys for each
# record, in descending order for the count.
#    Based on set_up_use_counts in multiple_header_analyze.rb for inventory
# database. This method was written to support combining headers for a report
# when there is only one item beneath.
#
# Written 05/02-03/2012 A. D. Roth based on set_up_use_counts (inventory db).  Count of
#                       headers generalized from 5 to head_count.
# Rev. 05/08-09/2012 to return the array of counts (separately from the headers) and to debug
# Rev. 05/31/2012 to ensure header is treated as string, not another class
# ------------------------------
def set_up_repeat_counts( input_array, heads, debug_flag = false )
  inputs_count = input_array.length
  head_count = heads.length
  puts "On entry to set_up_repeat_counts, head_count is #{ head_count } and " + 
      "input_array length is #{ inputs_count }" if debug_flag
  output_array = Array.new  # Output array, one entry per record in the order of the records in input_array
  temp_titles = Array.new( head_count ) { | i | "" }  #  initialize to empty strings
  puts "temp_titles initialized to: " + convert_array_to_line( temp_titles ) if debug_flag
  repeats_array = Array.new( head_count ) { | i | 0 }  #  initialize to zeroes
  puts "repeats_array initialized to: " + convert_array_to_line( repeats_array ) if debug_flag
  input_rcd_idx = 1
  input_array.reverse_each do | input_rcd |  # for each record, working backwards
    a_hdrs = Array.new
    puts "#{ inputs_count - input_rcd_idx }: Starting to process this input_rcd: " + convert_hash_to_line( input_rcd ) if debug_flag
    # collect all the headers into one array and analyze backwards
    heads.reverse_each { | hd | a_hdrs << input_rcd[ hd ].to_s  }
    puts "a_hdrs now" + convert_array_to_line( a_hdrs ) if debug_flag
    a_hdrs.each_with_index do | curr_h, i_backward |
      i = head_count - i_backward - 1
      h = ( curr_h.nil? ? "" : curr_h.strip ) 
      puts "i for h of '#{ h }' will be #{ i }" if debug_flag 
      #  only test nonblanks
      if ( h.length > 0 )
        if ( h == temp_titles[ i ] )  
          repeats_array[ i ] += 1
          puts "repeats_array now: " + convert_array_to_line( repeats_array ) if debug_flag
         else  #  no match
          temp_titles[ i ] = h
          puts "temp_titles now: " + convert_array_to_line( temp_titles ) if debug_flag
          repeats_array[ i ] = 0
          puts "repeats_array now: " + convert_array_to_line( repeats_array ) if debug_flag
        end
      else
        repeats_array[ i ] = 0
      end        
      #  clear lower numbers
      ( i + 1 .. head_count - 1 ).each { | index | repeats_array[ index ] = 0 } if ( repeats_array[ i ] ) == 0 && ( i < ( head_count - 1 ) )
    end  # header.reverse_each
    output_array << repeats_array.dup
    input_rcd_idx += 1
  end  #  input_array.reverse_each
  puts "set_up_repeat_counts returning output_array of: " + convert_array_to_line( output_array ) if debug_flag
  return  output_array.reverse
end  #  set_up_repeat_counts
# ------------------------------------------
# prep_report
#
#    Input_array is an array of hashes.  Heads is array of hash keys for columns 
# that may be separated and/or consolidated as combination headers in the report.
#    This method runs through the input lines and produces a new array of hashes 
# (@lines_to_print), one for each line to "print."  "left_column" is a string 
# with all the headers to print on this line, otherwise empty string ("").
#
#    "detail_col_heads" are column headers for columns where the cell info is
# to be made available to the view, whether or not the view chooses to use it.
# So a header can be in both the heads_array and detail_col_heads, so the value
# is available for selections, etc.
#
#    The method needs to determine, starting with header 1, whether the header at this level
# has changed (if there is any header at this level).  If it has not changed (that is, has 
# already been printed), it is not to be repeated.  Move on to the next lower level header.
#    If the header at a level has changed, the new header and all lower headers must be printed. 
# Where a level of header is not repeated (there is only one record with this header at this
# level), the header(s) is (are) printed together, on the same line as the details.
#    That is, (1) does the higher level header change at the next record, or (2) if the higher 
# level header does not change, is this the only record with the new header at this level?  
# You can answer (1) and (2) with the repeat_count for this header.  The repeat_count will tell 
# if the headers that go together print alone or with the record details.
#
# The following obsoleted by 5/30/2012 rewrite.
#
# So, for each input record, for each header:
#   (1) is there a header at this level?  If not, no lower headers count and done.
#   (2) Has this header changed? (If higher level header changed, the answer is automatically 
#       'yes'.)  If so, does this header have a repeat_count > 0?  Then if repeat count is 
#       same as higher level, merge this header to the higher level header's line.  If repeat 
#       count is less than higher level (but > 0), need a new header line for this header.  
#       If a new header and repeat_count of zero, put this header and all lower headers on 
#       detail line.
#   (3) To next header.
#
#    The call to set_up_repeat_counts establishes which headers are used for more than one line
# (and therefore are listed on a separate line from the details).  The call to det_heads_to_print
# tells which headers to print for this line.  det_heads_to_print returns two integers, highest 
# level of header print (header 1 the highest) and the number of headers to print.  If the lowest 
# level header to print has a repeat_count of zero, also run the details.  If zero headers are 
# to print, the details are still to be run.
#    The "action" input argument permits testing of submethods.
#
# Written 05/02-30/2012 A. D. Roth based on prep_page (inventory db)
# ------------------------------------------
def prep_report( input_array, detail_col_heads, heads_array, action = [ "normal" ], debug_flag = false )
    # ------------------------------------------
    # actually_print_header_line
    #
    #    Adds header line to @lines_to_print.
    #
    # Written 05/24-30/2012 A. D. Roth
    # ------------------------------------------
    def actually_print_header_line( debug_flag )
      output_line = { "i_header" => @i_header, "details" => 
          ( @i_header == 0 ? "yes" : "no" ), "left_col" => ( @left_col > " " ? 
          @left_col : "" ) }
      # output_line[ "test_input_rcd" ] = line_no if ( line_no > 0 ) && debug_flag  #  ONLY if debug_flag true
      @lines_to_print << output_line
      puts "output_line added to @lines_to_print as " + convert_hash_to_line( output_line ) if debug_flag
      puts "@lines_to_print now has #{ @lines_to_print.length } lines." if debug_flag
      @left_col = ""
      # @i_header = head_ix + 1
      @i_header = 0
    end  #  actually_print_header_line
    # ------------------------------------------
    # process_1_head
    #
    #    Processes one head.
    #
    #    @prev_line          hash of previous line values
    #    @last_head_ix       head_ix for last header ( = heads_array.length )
    #
    # Written 05/30-31/2012 A. D. Roth
    # ------------------------------------------
    def process_1_head( curr_line, head_col, ix, repeat_count, debug_flag )
      puts "Processing #{ head_col }, ix = #{ ix }, @left_col = #{ @left_col }" if debug_flag
      head_ix = ix + 1
      b_headers_done_flag = false
      #  add to left_col if not prev. printed
      #  Is there a header at this level?
      if exists_nonblank_hash_element?( curr_line, head_col)
        i_repeats = repeat_count [ head_ix - 1 ]
        i_next_repeats = repeat_count [ head_ix ]
        if @prev_line.nil? || !( @prev_line[ head_col ] == curr_line [ head_col ] ) #  Has this header not yet run?
          #  Header has changed; all lower headers now automatically 'new'.
          puts "This is first encounter for header #{ (head_ix + 1).to_s } (\"#{ curr_line [ head_col ] }\")." if debug_flag
          @left_col += ( @left_col.length == 0 ? "" : " – " ) + curr_line[ head_col ].to_s
          @prev_line = nil  #  all subsequent headers now new
          @i_header = head_ix if @i_header == 0
          if !(head_ix == @last_head_ix)  #  not yet at last header
            puts "head_ix (#{ head_ix }) does not equal @last_head_ix (#{ @last_head_ix })" if debug_flag
            puts "compare i_repeats (#{ i_repeats }) to i_next_repeats (#{ i_next_repeats })" if debug_flag
            actually_print_header_line( debug_flag ) if i_repeats > i_next_repeats
          end
        else  #  Header has not changed
          puts "Header has not changed; @prev_line.nil? (#{ @prev_line.nil?.inspect }):" if debug_flag
          puts "OR @prev_line[ head_col ] (#{ @prev_line[ head_col ] }) equals " + 
              "curr_line [ head_col ] (#{ curr_line [ head_col ] })" if 
              ( !@prev_line.nil? ) && debug_flag
        end
        if head_ix == @last_head_ix  #  at last header 
          puts "head_ix (#{ head_ix }) equals @last_head_ix (#{ @last_head_ix })" if debug_flag
          b_headers_done_flag = true
          ( i_repeats > 0 ? actually_print_header_line( debug_flag ) : @i_header = 0 )
        end
      end
      return b_headers_done_flag
    end  #  process_1_head
  # ------------------------------------------
  # process_one_line
  #
  #    Returns an array of strings for the headers and details of one input line.
  #
  # Written 05/17-31/2012 A. D. Roth
  # ------------------------------------------
  def process_one_line( curr_line, detail_col_heads, line_no, repeat_count, 
      heads_array, debug_flag )
    puts "-----------start process_one_line--------------------" if debug_flag   
    puts "start process_one_line received repeat count of " + convert_array_to_line( repeat_count ) if debug_flag   
    header_line = Hash.new
    heads_array.each { | one_header | header_line[ one_header ] = 
        ( curr_line[ one_header ].nil? ? "" : curr_line[ one_header ] ) }
    # calculate what to display on this line
    @left_col, @i_header = [ "", 0 ]  #  initialize
    headers_done_flag = false  #  true = don't process any more headers.
    heads_array.each_with_index do | head_col, ix |
      headers_done_flag = process_1_head( curr_line, head_col, ix, 
          repeat_count, debug_flag ) if !headers_done_flag
    end
    # print details
    output_line = Hash.new
    #  build key_array from schema info.
    puts "output_line starts out as " + convert_hash_to_line( output_line ) if debug_flag
    detail_col_heads.each do | key | 
      output_line[ key ] = curr_line[ key ] if curr_line[ key ].to_s.length > 0
      puts "after adding value '#{ curr_line[ key ] }' for key '#{ key }', " + 
          "output_line now " + convert_hash_to_line( output_line ) if debug_flag
    end
    output_line[ "i_header" ] = 0
    output_line[ "details" ] = "yes"
    output_line[ "left_col" ] = @left_col
    # output_line[ "test_input_rcd" ] = line_no if ( line_no > 0 ) && debug_flag  #  ONLY if debug_flag true
    puts "output_line added to @lines_to_print as " + 
        convert_hash_to_line( output_line ) if debug_flag
    @lines_to_print << output_line
    puts "-----------end process_one_line--------------------" if debug_flag   
  end  #  process_one_line
  # ------------------------------ start prep_report MAIN -----------------------------------
  if action.length > 0 && action[0] == "normal"
    # debug_flag = true
    puts "On entry to prep_report, input_array has #{ input_array.count } members." if debug_flag
    head_count = heads_array.length
    @lines_to_print = Array.new
    puts "successfully into prep_report!" if debug_flag
    @show_obj = DisplayInfo.new if @show_obj.nil?
    repeats_array = set_up_repeat_counts( input_array, heads_array, false )  #  sets up filelist.repeats_array
    # prepare the actual lines to print
    @lines_to_print = Array.new
    @prev_line = Hash.new
    @last_head_ix = heads_array.length unless heads_array.nil?
    input_array.each_with_index do | curr_line, line_no |    # for each record
      process_one_line( curr_line, detail_col_heads, line_no, repeats_array[ line_no ], 
          heads_array, debug_flag )  # result of call are additional lines in @lines_to_print
      @prev_line = curr_line
    end  # input_array.each
  elsif ( action.length > 0 )
    case action[0]
    #    when "test print_heads"
    #      return_array = print_heads( action[1][ "curr_line" ], 
    #          action[1][ "first_display_head" ] , action[1][ "display_head_count" ], 
    #          action[1][ "repeat_count" ], action[1][ "heads_array" ], 
    #          action[1][ "debug_flag" ] )
    when "test process_one_line"
      return_array = process_one_line( action[1][ "curr_line" ], 
          action[1][ "display_head_count" ], action[1][ "repeat_count" ], 
          action[1][ "heads_array" ], action[1][ "debug_flag" ] )
    #  when "test det_heads_to_print"
    #    puts "action is " + action[0] + convert_hash_to_line( action[1] )
    #    #  def det_heads_to_print( curr_line, prev_line, heads_array, debug_flag )
    #    return_array = det_heads_to_print( action[1][ "curr_line" ], 
    #        # action[1][ "prev_line" ], 
    #        action[1][ "heads_array" ], action[1][ "debug_flag" ] )
    end
  end
  puts "When prep_report exits, @lines_to_print now has #{ @lines_to_print.length } lines." if debug_flag
  return @lines_to_print
end  #  prep_report
# ------------------------------------------
# exists_nonblank_hash_element?
#
# Written 05/15-17/2012 A. D. Roth
# Rev. 05/31/2012 to ensure element is treated as string, not another class
# ------------------------------------------
def exists_nonblank_hash_element?( hash, key )
  return !( hash[ key ].nil? || hash[ key ].to_s.length == 0 || hash[ key ].to_s == " " )
end  #  exists_nonblank_hash_element?

