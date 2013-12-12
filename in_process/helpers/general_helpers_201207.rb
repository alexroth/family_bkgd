# general_helpers_201207.rb
#
# general ruby support methods, 2012, first part
#
# As of 09/20/2012:
#  Constant:
#   MONTH_ABBREV
#  Methods:
# def prep_nav_values( params, max_rows = 15 )
# def check_for_nil( value )
# def convert_cell_array_names_to_array( cell_array )
# def convert_srch_names_to_array( srch_array )
# def fmt_date_format_to_string( date_in )
# def ms_flag_tf( flag )
# def count_file_lines(file_name)
# def add_to_file(file_name, file_desc, col_heads_array, values_array, debug_flag = false)
# def test_regexp(seq, string, string_regexp)
# def get_heads_fr_schema(tbl_name, schema_loc = "db/", debug_flag = false)
# def get_tables_fr_schema( schema_loc = "db/")
# def do_integer_division( length, denominator )
#  Constants:
#    ROMAN_NUMERAL    #  used by my_string_hash
#    WORD_INDEX       #  used by det_target_lengths
#    WORD_VALUE       #  used by det_target_lengths
#    WORD_LENGTH      # length of WORD_VALUE
#    WORD_CONS_COUNT  #  used by det_target_lengths
#    WORD_SHORTFALL   #  used by det_target_lengths
#    WORD_TARGET_LENGTH  #  used by det_target_lengths
#  Methods:
# def shrink_word(word, length, debug_flag = false)  #  returns result
# class String
#   def set_attribs_for_debug( debug_hash = { }, debug_flag = false )
#   def my_string_hash( output_length )
#   def process_input_array
#   def assign_spaces( a, i, quotient, remainder, b_use_vowels )  #  also uses @r_len, @input_array, @debug_flag
#   def update_new_first_remainder_ii( a, return_indexes, b_use_vowels )  #  also uses @input_array, @debug_flag
#   def assign_additional_spaces( indexes, b_use_vowels )  #  also uses @r_len, @input_array, @debug_flag
#   def det_target_lengths  #  uses @input_array, @output_len, @show_obj, @debug_flag
#   def assign_initial_lengths( b_use_vowels )  #  also uses @r_len, @input_array, @debug_flag
# def pick_rcds( pick_list, array_of_arrays )
# def put_pgm_headline( pgm_name, file_name, line_no, debug_flag = false )
#
# Written 06/27-08/16/2012 A. D. Roth
# ------------------------------------
MONTH_ABBREV = { 1 => "Jan.", 2 => "Feb.", 3 => "Mar.", 4 => "Apr.", 5 => "May", 
    6 => "June", 7 => "July", 8 => "Aug.", 9 => "Sep.", 10 => "Oct.", 11 => "Nov.", 
    12 => "Dec." }  # for fmt_date_format_to_string
# ----------------------------
# prep_nav_values
#
# Written 06/27/2012 A. D. Roth
# Rev. 06/28/2012 to parameterize max_rows
# Rev. 07/17/2012 to correct typo
# ----------------------------
def prep_nav_values( params, max_rows = 15 )
  @offset = (params[:curr_offset] ? params[:curr_offset].to_i : 0 )
  @max_rows = (params[:max_rows] ? params[:max_rows].to_i : max_rows )
  case params[:next_offset]
    when 'First' : @offset = 0 
    when 'Prev'  : @offset = [ @offset - @max_rows, 0 ].max
    when 'Next'  : @offset += ( @offset + @max_rows < @table_count ? @max_rows : 0 )
    when 'Last'  : @offset = @table_count - (@max_rows/2).to_i 
  end # case params[:next_offset]
end  # prep_nav_values
#---------------------------
# check_for_nil
#
# Return the input value if non-nil, otherwise an empty string.
#
# Written 03/27/2012 A. D. Roth
# ------------------------------
def check_for_nil( value )
  return ( value.nil? ? "" : value )
end  #  check_for_nil
# -----------------------------------
# convert_cell_array_names_to_array
#
# Prints a line of names in the cell array.
#
# Written 08/01/2012 A.D. Roth
# -----------------------------------
def convert_cell_array_names_to_array( cell_array )
  require 'general_helpers_201109'
  name_list = Array.new
  cell_array.each_with_index do | curr_cell, cell_ix | 
    curr_rcd, gen_level, gender = curr_cell
    puts; puts "curr_rcd, class #{ curr_rcd.class }, is " + convert_record_to_line( curr_rcd )
    name_list << ( curr_rcd.class == String || curr_rcd.name.nil? ? "None" : curr_rcd.name )
  end  #  cell_array.each_with_index
  return name_list.inspect
end  #  convert_cell_array_names_to_array
# -----------------------------------
# convert_srch_names_to_array
#
# Prints a line of names from an array with record in pos. [1], record has name field.
#
# Written 09/13/2012 A.D. Roth based on convert_cell_array_names_to_array
# -----------------------------------
def convert_srch_names_to_array( srch_array )
  require 'general_helpers_201109'
  name_list = Array.new
  srch_array.each_with_index do | curr_rcd, rcd_ix | 
    rcd_id, rcd, result_type = curr_rcd
    #  puts; puts "In convert_srch_names_to_array: rcd, class #{ rcd.class }, is " + convert_record_to_line( rcd )
    name_list << ( rcd.class == String || rcd.nil? || rcd.name.nil? ? "None" : "#{ rcd.name } for #{ result_type }"  )
  end  #  cell_array.each_with_index
  return name_list.inspect
end  #  convert_srch_names_to_array
# -----------------------------------
# fmt_date_format_to_string
#
# Format date string or date class field to Jan. 3, 1925
#
# Written 07/26-08/04/2012/2012 A.D. Roth
# ---------------------------------------------
def fmt_date_format_to_string( date_in )
  date_out_str = ""
  # if date_in.class == Date
    date_out_str = MONTH_ABBREV[ date_in.to_s[ 5, 2 ].to_i ] + " " + 
        date_in.to_s[ 8, 2 ].to_i.to_s + ", " + date_in.to_s[ 0, 4 ] 
    # 5 for month, 8 for day,0 for year
  # elsif date_in.class == String
  #   date_out_str = MONTH_ABBREV[ date_in[ 5, 2 ].to_i ] + ". " + 
  #       date_in[ 8, 2 ].to_i.to_s + ", " + date_in[ 0, 4 ] 
  # end
  return date_out_str
end  #  fmt_date_format_to_string
# ------------------------------------
# convert_boolean_to_string
#
# Ruby method to output string "TRUE" or "FALSE" for a binary flag value
#
# Written 07/31/2011 A. D. Roth
# Rev. 08/23/2012 to rename from ms_flag_tf to convert_boolean_to_string
# ------------------------------------
def convert_boolean_to_string( flag )
  return (flag ? "TRUE" : "FALSE" )
end  #  convert_boolean_to_string
#---------------------------
# count_file_lines
# 
# Written 07/29/2010 A. D. Roth
#---------------------------
def count_file_lines(file_name)
  return IO.readlines(file_name).count
end  # count_file_lines
#---------------------------
# add_to_file
#
# This method writes the values in values_array out to a bar-delimited file.
# If the file does not already exist, it is created and the first record 
# has the column heads (from col_heads_array).  Then the values are appended
# to the end of the file.  Values are selected from the values_array array of 
# hashes based on the col_heads_array columns.
#
# Written 07/28-29/2010 A. D. Roth
# Rev. 08/23/2010 to handle "id" (RAILS key)
# Rev. 12/26/2010 to add debugging statements
# Rev. 01/14/2011 to add debug_flag
# Rev. 02/02/2011 to add str#rstrip to strip trailing nulls and white space 
#                 from fields
# Rev. 04/06/2011 to edit comments
# Rev. 05/07/2011 to put basename only in filename part of first line
#---------------------------
def add_to_file(file_name, file_desc, col_heads_array, values_array, 
    debug_flag = false)
  value_count = values_array.count  # this only for this next "puts"
  puts "To file #{file_name}, there are #{col_heads_array.count} column " +
      "heads and #{value_count} row#{(value_count == 1 ? "" : "s")} to add." if debug_flag
  @show_obj.show_array( "entering add_to_file, values_array", values_array) if debug_flag
  existing_file_flag = File.exist?(file_name)
  # determine next line no.
  # transfer data to file
  string_out = ""
  File.open(file_name, "a") do |file|
    # "Column descriptions: "
    if !existing_file_flag
      col_heads_array.each { | head | string_out += (head + "|") } 
      string_out += File.basename( file_name ).rstrip + ": " + file_desc.rstrip
      file.puts string_out
      puts "File #{file_name} is new." if debug_flag
      next_id = 1
      puts string_out if debug_flag
      string_out = ""
    else
      line_count = count_file_lines(file_name)
      next_id = line_count
      # puts "Before the addition, file #{file_name} has #{line_count} line" +
      #   (line_count == 1 ? "" : "s") + "; adding the following lines: "
    end
    values_array.each do | row_hash |
      # puts if debug_flag
      # puts "row_hash is of class " + 
	  #    row_hash.class.to_s  # if debug_flag
      # @show_obj.show_array("col_heads_array", col_heads_array)
      # @show_obj.show_array("row_hash", row_hash) if debug_flag
      col_heads_array.each { | index | ( string_out = string_out +  
          ( row_hash[ index ].nil? ? "" : row_hash[ index ].to_s.rstrip ) + 
          "|" ) unless index == "id" }
      if string_out.length > 0
        file.puts next_id.to_s + "|" + string_out 
        puts next_id.to_s + "|" + string_out if debug_flag
        next_id += 1
      end
      string_out = ""
    end
  end  # closes file
  line_count = count_file_lines(file_name)
  puts "File " + file_name + " now has #{line_count} line" + (line_count == 1 ? "" : "s") if debug_flag
  # exit if debug_flag
end # add_to_file
#---------------------------
# test_regexp
#
# Rev. 01/02-04/2011 to move from TC_import_HTML.rb
# Rev. 06/14/2012 .new stmt changed to elim "flags ignored" message
# Rev. 07/03/2012 to expand puts message
#---------------------------
def test_regexp(seq, string, string_regexp)
  puts
  puts "#{seq}. test_regexp called with string #{string.inspect} and " + 
      "string_regexp (which could be either string or regexp) of " +
      "'#{string_regexp.inspect}', class #{string_regexp.class}."
  crit_regexp = Regexp.new( string_regexp )
  # puts "string_regexp '#{string_regexp}' became regexp #{crit_regexp.inspect}"
  puts "$~ is " + crit_regexp.match(string).inspect
end  # test_regexp
#---------------------------
# method get_heads_fr_schema.rb
#
# Returns an array of arrays: [ [ type, value ], ... ]
#
# Written 04/07/2011 A. D. Roth
# Rev. 08/24/2011 to move to general_helpers_201107; also debug
# Rev. 09/25/2011 to finish debugging !!
# Rev. 06/20/2012 to comment out debugging statements
#---------------------------
def get_heads_fr_schema(tbl_name, schema_loc = "db/", debug_flag = false)
# open schema
  result_array = Array.new
  done_flag = false
  in_tbl_flag = false
  # find table
  tbl_test = Regexp.new("create_table \"#{tbl_name}\"")
  extraction = Regexp.new('t\.(\w+)\s+\"(.+)"')
  File.open(schema_loc + "/schema.rb", "r").each_line do | line |
    unless done_flag  #  process one line if not done
      if !( in_tbl_flag ) && ( line =~ tbl_test )
        in_tbl_flag = true
        #  puts "in_tbl_flag status is now TRUE." if debug_flag
      end
      if in_tbl_flag
        if line =~ /^\s\send/
          #  puts "At end of table in schema" if debug_flag
          done_flag = true 
          in_tbl_flag = false
        else
          #  puts "Processing line '" + line + "'" if debug_flag
          if line =~ extraction
            # isolate datatypes and save in col_descrips type array
            #  puts "Type identified as '#{ $1 }' and col_name as '#{ $2 }'" if debug_flag
            result_array << [ $1, $2 ]
          else
            #  puts "Nothing pulled from line '" + line + "'" if debug_flag
          end
        end
      else  # not "create table" and not in table
        #  puts "get_heads_fr_schema rejecting line '" + line + "'" if debug_flag
        # if line[0, 6] == "    t."
        #   puts "Exiting."
        #   exit 
      end  # if in_tbl_flag
    end  #  unless
  end  #  end File.open
  #  puts "Table #{tbl_name} not found in schema or no \"end\" found." unless done_flag
  # @show_obj = DisplayInfo.new if @debug_flag && @show_obj.nil?
  # @show_obj.show_array("get_heads_fr_schema returning result_array", result_array) if @debug_flag
  return result_array
end  #  get_heads_fr_schema
#---------------------------
# method get_tables_fr_schema.rb
#
# Written 08/25/2011 A. D. Roth
#---------------------------
def get_tables_fr_schema( schema_loc = "db/")
# open schema
  result_array = Array.new
  done_flag = false
  # find "create table" statements
  tbl_test = Regexp.new("create_table \"(\.+)\"")
  File.open(schema_loc + "/schema.rb", "r").each_line { | line |
  result_array << $1  if line =~ tbl_test }
  return result_array
end  #  get_tables_fr_schema
  # ------------------------------------
  # do_integer_division
  #
  #  Returns quotient and denominator from dividing two integers
  # 
  # Written 06/02/2011 A. D. Roth
  # ------------------------------------
  def do_integer_division( length, denominator )
    return [ ( length.to_i / denominator.to_i ), ( length.to_i % denominator.to_i ) ]
  end  #  do_integer_division
# ------------------------------------
# CONSTANTS for my_string_hash
#
# Rev. 07/28/2011 to revise @input_array indices
# Rev. 08/03/2011 to add WORD_SHORTFALL for use by unit_det_target_lengths
# Rev. 08/18 to remove WORD_SHORTFALL
# ------------------------------------
ROMAN_NUMERAL = [ "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]  #  used by my_string_hash
WORD_INDEX = 0  #  used by det_target_lengths
WORD_VALUE = 1  #  used by det_target_lengths
WORD_LENGTH = 2  # length of WORD_VALUE
WORD_CONS_COUNT = 3  #  used by det_target_lengths
# WORD_SHORTFALL = 4  #  used by det_target_lengths
WORD_TARGET_LENGTH = 4  #  used by det_target_lengths
# ------------------------------------
# shrink_word
# 
# Function to shrink a word to i_length: working backwards, first remove vowels, 
# then consonants.  Used by my_string_hash
#
# 5/26/2011 initial vowel of each word is erroneously being dropped.
#
# Written 03/12-14/2010 A. D. Roth in PHP
# Rev. 08/24/2010, 12/14-16/2010 conversion to ruby
# Rev. 09/10/2010 rename to shrink_word from shrinkword
# Rev. 05/27/2011 to debug (initial letter of word not to be dropped even 
#                 if it is a vowel)
# Rev. 08/22/2011 to correct a debug statement
# -----------------------------------------------------------
def shrink_word(word, length, debug_flag = false)  #  returns result
  # debug_flag = true  
  #  puts "shrink_word using general_helpers in file " + File.dirname(__FILE__) + 
      "/" + File.basename(__FILE__) if debug_flag
  result = word
  initial_vowel = word[0] =~ /[AEIOUaeiou]/
  unless length < 2
    #  puts "On entry to shrink_word, input word is '#{word}'" +
    #      " and target length is #{length}." if debug_flag
    work = String.new(word.to_s.reverse)
    #  puts "work is '#{work}'" if debug_flag
    pos = work =~ /([AEIOUaeiou]).*$/
    until (work.length <= length) || # (index < 1) || 
	  (work[ 0, work.length - 1 ] =~ /[AEIOUaeiou]/).nil?
      # starting with last char. of word, squeeze out vowels
      pos = ( work =~ /([AEIOUaeiou]).*$/ )
      unless initial_vowel
        #  puts "shrink_word: searching for a vowel, $~ is #{$~.inspect}, " + 
        #      "pos = #{pos}" if debug_flag
        #  puts "pos for vowel to delete is #{pos} and work[pos, 1] is " + 
        #      "#{work[pos, 1]}" if debug_flag
        work.sub!(/[AEIOUaeiou]/, "")
        #  puts "Sliced a vowel out of the word, now have '#{work}', dropping " +
        #      "curr_length to #{ work.length } to fit into #{ length }." if debug_flag
      #  else
        #  puts "not dropping initial vowel '#{work [ 0, 1 ]}'" if debug_flag
      end  # unless
    end  #  until 
    # remove consonants
    result = work.reverse[0, length]
  else  # length 1 or 0
    result = word[0, length]
  end  # unless
  #  puts "will return " + result.ljust(length, "A") if debug_flag
  return result.ljust(length, "A")
end  # function shrink_word
# -------------------------
# hash_alpha
#
#   This routine hashes "name" to a NON-UNIQUE key that is "hash_len" char. long.
# It calculates the target length for each word (quotient plus 1 to some words, 
# depending on size of the remainder).  If a word is shorter than the target, 
# recalculate for the remaining words.
#  --------------------------------------------------
# Evolved from GENENTID   Written in Turbo Pascal 3/13/93 by A. D. Roth
# Adapted to PHP 10/31-11/4/2008 A. D. Roth from 3-13-1993 PASCAL pgm by A. D. Roth
#
# Rev. 12/30/2008-03/11/2009 to debug.
# Rev. 03/12-14/2010 to redesign and to omit Roman numeral suffixes (I-IX)
# Rev. 08/24/2010, 12/14-16/2010 to convert to ruby
# Rev. 05/26-06/02/2011 to debug
# Rev. 06/08/2011 replaced by class StringToHash
#  --------------------------------------------------
# def hash_alpha(input_string, hash_len, debug_flag = false )
# ------------------------------------
#  returns string with hashed value
#
# ------------------------------------
# my_string_hash
#
#  Ruby method for creating non-unique character hash of a word or phrase of words.
#  Example: hash_field = string.my_string_hash( 4 )
# 
# Written 06/08-12/2011 A. D. Roth, adapting from hash_alpha
# Rev. 07/26-31/2011 to debug and revise
# Rev. 08/19/2011 to create word breaks at .,:;
# Rev. 08/20-21/2011 to debug new version
# ------------------------------------
class String
  def set_attribs_for_debug( debug_hash = { }, debug_flag = false )
    # @debug_flag = debug_flag
    #  initialize instance variables for debugging
    if @debug_flag && ( debug_hash.length > 0 )
      debug_hash.each do | key, entry |
        case key
        when "r_len"
          @r_len = entry
          #  puts "@#{ key } now = #{ entry }" 
        when "r_word_count"
          @r_word_count = entry
          #  puts "@#{ key } now = #{ entry }" 
        end  #  case
      end  #  do  
    end   #  if
  end  #  set_attribs_for_debug
# ------------------------------------
  def my_string_hash( output_length )
    @input_array = Array.new
    @debug_flag = false if @debug_flag.nil?
    # @debug_flag = true
    # puts "@debug_flag is #{ ms_flag_tf( @debug_flag ) }"
    require 'display_info' if @debug_flag
    @show_obj = DisplayInfo.new if ( @debug_flag && @show_obj.nil? )
    # puts "@show_obj is #{ @show_obj.inspect }" if @debug_flag
    @output_len = output_length
    to_words = self.gsub(/[.,;:-]/, " ")
    interim = Array.new( to_words.upcase.split(/\s+/) )
    # drop any roman numeral suffix
    if interim.length > 1 && ROMAN_NUMERAL.include?( interim.last )
      #  puts "Removing roman numeral '" + interim.last + "', first word now '" + interim[ 0 ] + "'" if @debug_flag
      interim.pop
    end
    if interim.length < 2
      key_result = shrink_word( interim[ 0 ].gsub(/[^A-Za-z]/, ""), @output_len, @debug_flag ).upcase
    else
      interim.each_with_index do | w, ix |  #  build @input_array
        this_word = w.gsub(/[^A-Za-z]/, "")  #  clean up each word
        word_len = this_word.length 
        # set up an array for each word, consisting of sequence of the word (starting 
        # at zero, WORD_INDEX), the word (WORD_VALUE), the length of the word 
        # (WORD_LENGTH), the no. of consonants after the first letter (WORD_CONS_COUNT), 
        # and (eventually) the target length for that word (WORD_TARGET_LENGTH)
        @input_array << [ ix, this_word, word_len,  
            this_word[ 1, word_len - 1 ].gsub( /[AEIOUaeiou]/i, "" ).length, 0 ] if word_len > 0
      end
      if @debug_flag
        puts "@input_array initialized as follows:"
        @input_array.each { | i | puts "[ WORD_INDEX = #{ i[0] }, WORD_VALUE = " + 
            "#{ i[1] }, WORD_LENGTH = #{ i[2] }, WORD_CONS_COUNT = #{ i[3] }, " + 
            "WORD_TARGET_LENGTH = #{ i[4] } ], " }
      end
      # @show_obj.show_array( "@input_array initialized to", @input_array ) if @debug_flag
      #  is any processing needed?
      key_result = process_input_array
    end
    #  finish up
    key_result = key_result.upcase + "A"*( @output_len - key_result.length ) if key_result.length < @output_len
    puts "Returning key_result = '#{ key_result }'." if @debug_flag
    return key_result
  end  # my_string_hash
  # ------------------------------------
  # process_input_array
  #
  # Processes input string
  # 
  # Written 07/28/2011 A. D. Roth
  # Rev. 08/20-21/2011 to debug
  # ------------------------------------
  def process_input_array
    #  uses @input_array, @output_len, @show_obj, @debug_flag
    puts "Starting process_input_array, @output_len is #{ @output_len }" if @debug_flag
    total_length = 0
        if @debug_flag
          puts "On entry to process_input_array, @input_array:"
          @input_array.each { | i | puts "[ WORD_INDEX = #{ i[0] }, WORD_VALUE = " + 
              "#{ i[1] }, WORD_LENGTH = #{ i[2] }, WORD_CONS_COUNT = #{ i[3] }, " + 
              "WORD_TARGET_LENGTH = #{ i[4] } ], " }
        end
    @input_array.each { | w | total_length += w[ WORD_LENGTH ] }
    puts "total_length is #{ total_length }" if @debug_flag
    hashed_string = ''
    if @output_len >= total_length  #  no shrinking needed
      puts "no shrinking needed" if @debug_flag
      @input_array.each { | ia | hashed_string += ia[ WORD_VALUE ] }
    elsif @output_len <= @input_array.count  #  only use 1st char. of words
      puts "only use 1st char. of words" if @debug_flag
      # puts "@input_array is #{ @input_array } of class #{ @input_array.class }" if @debug_flag
      # puts "@input_array[ 0 ] is #{ @input_array[ 0 ] } of class #{ @input_array[ 0 ].class }" if @debug_flag
      # puts "@input_array[ 0 ][ WORD_VALUE ] is #{ @input_array[ 0 ][ WORD_VALUE ] } of class #{ @input_array[ 0 ][ WORD_VALUE ].class }" if @debug_flag
# exit
      [ 0 .. @output_len - 1 ].each do  | range |
        range.each do | i | 
          puts "i is #{ i } of class #{ i.class }" if @debug_flag
          word_value = String.new(@input_array[ i ][ WORD_VALUE ])
          hashed_string += word_value[ 0, 1 ] 
        end
      end
    else  #  some shrinking necessary
      puts "some shrinking necessary" if @debug_flag
      if @input_array.length == 1  #  only one word
        hashed_string = shrink_word( @input_array[ 0 ][ WORD_VALUE ], 
            @input_array[ 0 ][ WORD_TARGET_LENGTH ], @debug_flag )
      else
        if @debug_flag
          puts "@input_array on call to det_target_lengths; output_length " + 
              "is #{ @output_len }:"
          @input_array.each { | i | puts "[ WORD_INDEX = #{ i[0] }, WORD_VALUE = " + 
              "#{ i[1] }, WORD_LENGTH = #{ i[2] }, WORD_CONS_COUNT = #{ i[3] }, " + 
              "WORD_TARGET_LENGTH = #{ i[4] } ], " }
        end
        work_array = det_target_lengths  #  needs @input_array, @output_len, @debug_flag
        # @show_obj.show_array( "now shrinking words with work array (word index, " + 
        #     "word value, target length, no. of consonants after 1st letter) of ", 
        #     work_array ) if @debug_flag
        if @debug_flag
          puts "About to call shrink_word to shrink words with work array (word index, " + 
              "word value, no. of consonants after 1st letter, target length):"
          work_array.each { | i | puts "[ WORD_INDEX = #{ i[0] }, WORD_VALUE = " + 
              "#{ i[1] }, WORD_LENGTH = #{ i[2] }, WORD_CONS_COUNT = #{ i[3] }, " + 
              "WORD_TARGET_LENGTH = #{ i[4] } ], " }
        end
        work_array.each { | one_word | hashed_string += shrink_word(one_word[ WORD_VALUE ], 
            one_word[ WORD_TARGET_LENGTH ], @debug_flag ) }  if hashed_string == ""  #  shrink words
      end
    end  #  if
    #  finish up
    hashed_string += "A"*( @output_len - hashed_string.length ) if hashed_string.length < @output_len
    return hashed_string
  end  #  process_input_array
  # ------------------------------------
  # assign_spaces
  #
  #    Run a loop 
  #
  # Written 08/17-18/2011 A. D. Roth
  # ------------------------------------
  def assign_spaces( a, i, quotient, remainder, b_use_vowels )  #  also uses @r_len, @input_array, @debug_flag
    puts "Entering assign_spaces" if @debug_flag
    return_index = nil
    max_to_add = ( b_use_vowels ? a[ WORD_LENGTH ] : a[ WORD_CONS_COUNT ] )
    add_len = quotient
    puts "calc. add_len: quotient , result is #{ add_len }"  if @debug_flag
    # add remainder, if appropriate
    if ( remainder > 0 ) && ( i >= @first_remainder_ii )
      add_len += 1 
    end
    puts "calc. add_len: += 1 if ( remainder > 0 ) && ( i <= remainder - 1 ), result is #{ add_len }" if @debug_flag
    # cap add_len at @r_len ??
    puts "add_len is #{ add_len } "  if @debug_flag
    # calc. length_limit
    length_limit = ( b_use_vowels ? a[ WORD_LENGTH ] : a[ WORD_CONS_COUNT ] + 1 ) - 
        a[ WORD_TARGET_LENGTH ]
    puts "length_limit is #{ length_limit }" if @debug_flag
    #  calculate how much gets added
    actual_add = [ @r_len, add_len, length_limit ].min
    puts "actual_add is #{ actual_add }" if @debug_flag
    a[ WORD_TARGET_LENGTH ] += actual_add
    @r_len -= actual_add
    puts "@r_len is now #{ @r_len }" if @debug_flag
    # shortfall = add_len - actual_add if ( actual_add < add_len )  # didn't assign all spaces
    return_index = a[ WORD_INDEX ] if max_to_add > a[ WORD_TARGET_LENGTH ]
    puts "word is now: [ WORD_INDEX = #{ a[0] }, WORD_VALUE = #{ a[1] }, WORD_LENGTH = #{ a[2] }, " + 
        "WORD_CONS_COUNT = #{ a[3] }, WORD_TARGET_LENGTH = #{ a[4] } ]" if @debug_flag
    puts "assign_spaces returning return_index of #{ return_index }" if @debug_flag
    return return_index
  end  #  assign_spaces
  # ------------------------------------
  # update_new_first_remainder_ii
  #
  # Assign index number in the "indexes" array for the first word to receive a "one"
  # from the remainder.  If a has consonants left, and a_curr has longer target_length 
  # and a_curr is already using more consonants than a.
  #
  # Written 08/18-20/2011 A. D. Roth
  # ------------------------------------
  def update_new_first_remainder_ii( a, return_indexes, b_use_vowels )  #  also uses @input_array, @debug_flag
    puts "Entering update_new_first_remainder_ii, @new_first_remainder_ii " + 
        "is #{ @new_first_remainder_ii }" if @debug_flag
    if ( return_indexes.length > 1 )
        a_curr_i = return_indexes[ @new_first_remainder_ii ]
        puts "a_curr_i is #{ a_curr_i }" if @debug_flag
        a_curr = @input_array[ a_curr_i ]  #  the ii one
        @show_obj.show_array( "a_curr", a_curr ) if @debug_flag
        a_curr_used_cons = a_curr[ WORD_TARGET_LENGTH ] - 1  #  the ii one
        puts "a_curr_used_cons is #{ a_curr_used_cons }" if @debug_flag
        a_used_cons = a[ WORD_TARGET_LENGTH ] - 1  #  a
        puts "a_used_cons is #{ a_used_cons }" if @debug_flag
        puts "a[ WORD_CONS_COUNT ] is #{ a[ WORD_CONS_COUNT ] }, " + 
            "a[ WORD_TARGET_LENGTH ] is #{ a[ WORD_TARGET_LENGTH ] }, " + 
            "a_curr[ WORD_TARGET_LENGTH ] is #{ a_curr[ WORD_TARGET_LENGTH ] }" if @debug_flag
        puts "Condition ( a[ WORD_CONS_COUNT ] - a_used_cons > 0 ) is " + 
            "#{ ( a[ WORD_CONS_COUNT ] - a_curr_used_cons > 0 ).inspect }" if @debug_flag
        puts "Condition ( a[ WORD_TARGET_LENGTH ] < a_curr[ WORD_TARGET_LENGTH ] ) is " + 
            "#{ ( a[ WORD_TARGET_LENGTH ] < a_curr[ WORD_TARGET_LENGTH ] ).inspect }" if @debug_flag
        puts "Condition ( a_curr_used_cons > a_used_cons) is " + 
            "#{ ( a_curr_used_cons > a_used_cons).inspect }" if @debug_flag
        @new_first_remainder_ii = return_indexes.length - 1 if 
            ( a[ WORD_CONS_COUNT ] - a_used_cons > 0 ) &&  #  consonants still avail
            ( a[ WORD_TARGET_LENGTH ] < a_curr[ WORD_TARGET_LENGTH ] ) &&  # a has fewer spaces than a_curr
            ( a_curr_used_cons > a_used_cons)  # and consonants used fewer than those of ii
    end
    puts "Returning from update_new_first_remainder_ii with @new_first_remainder_ii = " + 
        "#{@new_first_remainder_ii }" if @debug_flag
  end  #  update_first_remainder_ii
  # ------------------------------------
  # assign_additional_spaces
  #
  # Assign surplus spaces to the words pointed to in "indexes."
  #
  # Written 08/17-18/2011 A. D. Roth
  # Rev. 12/15/2011 to discipline 'puts' statements
  # ------------------------------------
  def assign_additional_spaces( indexes, b_use_vowels )  #  also uses @r_len, @input_array, @debug_flag
    puts "Entering assign_additional_spaces" if @debug_flag
    i_done = 0
    current_indexes = Array.new
    new_indexes = Array.new
    until @r_len <= 0 || i_done > 5
      unless indexes.nil?  # use passed indexes first time only
        indexes.each { | ind | current_indexes << ind }
        indexes = nil
      else
        new_indexes.each { | ind | current_indexes << ind } unless new_indexes.nil?
      end
      unless current_indexes.length == 0
        new_indexes = nil
        new_indexes = Array.new
        puts "Starting main loop for assign_additional_spaces, @r_len is #{ @r_len } " + 
            "and i_done is #{ i_done }" if @debug_flag
        quotient, remainder = do_integer_division( @r_len, current_indexes.length )  # r_ for running
        @first_remainder_ii = @new_first_remainder_ii
        @new_first_remainder_ii = 0
        puts "quotient is #{ quotient } and remainder is #{ remainder }" if @debug_flag
        current_indexes.each_with_index do | index, ii |
          if @r_len > 0
            puts "----------------- "  if @debug_flag
            puts "Processing word #{ index } within '#{ current_indexes.to_s }'" if @debug_flag
            a = @input_array[ index ]
            return_index = assign_spaces( a, ii, quotient, remainder, b_use_vowels )
            unless return_index.nil?
              new_indexes << return_index 
              update_new_first_remainder_ii( a, new_indexes, b_use_vowels )
            end
  exit if new_indexes.length > 4
          end
        end
      end
  # exit if @output_len == 9
      i_done += 1
    end
    puts "#{ @r_len } characters left at end of assigning lengths." if @r_len > 0 && @debug_flag
    puts (i_done >= 5 ? "Breaking out of loop, @r_len is #{ @r_len }" :
        "Processing completed for det_target_lengths, i_done is #{ i_done }" ) if @debug_flag
    puts "assign_additional_spaces returning." if @debug_flag
  end  #  assign_additional_spaces
  # ------------------------------------
  # det_target_lengths
  #    @input_array is an array for each word, consisting of sequence of the word 
  # (starting at zero, WORD_INDEX), the word (WORD_VALUE), the length of the word 
  # (WORD_LENGTH), the no. of consonants after the first letter (WORD_CONS_COUNT), 
  # and (eventually) the target length for the word (WORD_TARGET_LENGTH), one for 
  # each word in the phrase to be hashed.  They've already been cleaned up of 
  # punctuation and converted to upper case.
  #
  #   This method prefers allocating spaces as follows: the first letter of each word; 
  # then first letters plus consonants spread evenly among the words, then with first 
  # letters plus all consonants, vowels spread evenly among the words.
  #
  #    This is a development version and is not primarily concerned with performance (speed
  # and simplicity).  It is intended to provide a nonexclusive hash of word phrases up to 25
  # letters; but it may work for longer ones.
  #
  #    First determine whether vowels are to be used (flag b_use_vowels).
  #    Then run a loop to assign 1st letter and establish list of indices of words "with
  # consonants."  (The first letter is not included among the "consonants.") (If use_vowels 
  # is true, assign 1st letter and consonants and establish a list of indices of words
  # "with vowels."  (The first letter is not included among the "vowels.")
  #    Then divide the remaining length by the number of remaining words and assign lengths
  # to the remaining words, accumulating a surplus when a word does not need that many
  # spaces and building a new index of the words that will still have vowels available.
  #    Then divide the remaining length by the number of remaining words and rerun the loop,
  # repeatedly if necessary.
  #
  #    use_vowels flag determines whether all consonants will be used.  Count excludes 
  # 1st char. of each word, which is always used if consonants or vowels are used.
  # Caller has determined that @output_len is shorter than input length and input 
  # has length > 0.
  #
  #    Returns hash string; not yet adjusted for final length.
  # 
  # Written 06/01-09/2011 A. D. Roth, adapting from hash_alpha
  # Rewritten 07/21-08/16/2011 to change calling sequence and fold  
  #           calc_multiple_word_lengths into det_target_lengths
  # Redesigned and rewritten 08/17/2011 because letters were not allocating correctly.
  # ------------------------------------
  def det_target_lengths  #  uses @input_array, @output_len, @show_obj, @debug_flag
    puts "Starting det_target_lengths" if @debug_flag
    @r_word_count = @input_array.length
    # det. total_cons and create full_indexes, array of indices of all words
    @total_cons, @r_len, @first_remainder_ii, @new_first_remainder_ii = 
        [ 0, 0, 0, 0 ]
    full_indexes = Array.new
    @input_array.each_with_index do | a, i | 
      @total_cons += a[ WORD_CONS_COUNT ]
      # full_indexes << i 
      # full_length += a[ WORD_LENGTH ]
    end
    b_use_vowels = ( @output_len > @r_word_count + @total_cons )
    puts "b_use_vowels set to " + ms_flag_tf( b_use_vowels ) if @debug_flag
    @r_len = @output_len  # r_ for "running . . ."
    # Assign initial lengths
    puts "Assigning initial lengths" if @debug_flag
    next_indexes = assign_initial_lengths( b_use_vowels )
    #  assign additional spaces
    assign_additional_spaces( next_indexes, b_use_vowels ) if @r_len > 0
    return @input_array
  end  #  det_target_lengths
  # ------------------------------------
  # assign_initial_lengths
  #
  #    Run a loop to assign 1st letter and establish list of indices of words "with
  # consonants."  (The first letter is not included among the "consonants.") (If use_vowels 
  # is true, assign 1st letter and consonants and establish a list of indices of words
  # "with vowels."  (The first letter is not included among the "vowels.")
  #
  #    Returns an array of the indexes of the words that have more room for spaces.
  #
  # Written 08/12-14/2011 A. D. Roth
  # Rewritten 08/17-20/2011 to correct design
  # Rev. 08/22/2011 to correct a debug statement
  # ------------------------------------
  def assign_initial_lengths( b_use_vowels )  #  also uses @r_len, @input_array, @debug_flag
    puts "Entering assign_initial_lengths, @r_len is #{ @r_len } and " + 
        "@r_word_count is #{ @r_word_count }." if @debug_flag
    return_indexes = Array.new
    puts "Initialized return_indexes has #{ return_indexes.length } members." if @debug_flag
    # i_max_length = 0
    @quotient, @remainder = do_integer_division( @r_len, @r_word_count ) 
    puts "@quotient for @r_len (#{ @r_len }) div. by @r_word_count (#{ @r_word_count }) " +
        "is #{ @quotient } and @remainder is #{ @remainder }" if @debug_flag
    @input_array.each_with_index do | a, i |
      puts "----------------- "  if @debug_flag
      puts "now processing word #{ i } "  if @debug_flag
      #  i_max_length = [ a[ WORD_LENGTH ], i_max_length ].max
      if a[ WORD_LENGTH ] > 0
        cand_len = @quotient 
        puts "calc. cand_len: @quotient, result is #{ cand_len }" if @debug_flag
        cand_len += 1 if ( @remainder > 0 ) && ( a[ WORD_INDEX ] <= @remainder - 1 )
        puts "calc. cand_len: += 1 if ( @remainder > 0 ) && " + 
            "( a[ WORD_INDEX ] <= @remainder - 1 ), result is #{ cand_len }" if @debug_flag
        # cand_len += a[ WORD_CONS_COUNT ] if b_use_vowels
        # puts "calc. cand_len: += a[ WORD_CONS_COUNT ] if b_use_vowels, result is #{ cand_len }"
        cand_len = [ @r_len, cand_len ].min
        puts "calc. cand_len: trim to @r_len if necessary; result is #{ cand_len }" if @debug_flag
        puts "cand_len is #{ cand_len } "  if @debug_flag
        # calc. length_limit
        length_limit = ( b_use_vowels ? a[ WORD_LENGTH ] : a[ WORD_CONS_COUNT ] + 1 )
        puts "length_limit is #{ length_limit }" if @debug_flag
        #  calculate how much gets added
        add_length = [ cand_len, length_limit ].min
        puts "add_length = #{ add_length }" if @debug_flag
        a[ WORD_TARGET_LENGTH ] = add_length
        puts "a[ WORD_TARGET_LENGTH ] = #{ a[ WORD_TARGET_LENGTH ] }" if @debug_flag
        shortfall = [ cand_len - a[ WORD_TARGET_LENGTH ], 0 ].max  #  shortfall from cand_len
        spaces_avail = ( b_use_vowels ? a[ WORD_LENGTH ] : 
            a[ WORD_CONS_COUNT ] + 1 ) - a[ WORD_TARGET_LENGTH ]
        puts "spaces_avail is now #{ spaces_avail }" if @debug_flag
        @r_len -= add_length
        puts "@r_len is now #{ @r_len }" if @debug_flag
        # @r_word_count -= 1
        if spaces_avail > 0
          return_indexes << a[ WORD_INDEX ]
          update_new_first_remainder_ii( a, return_indexes, b_use_vowels )
        end
        @show_obj.show_array( "return_indexes now", return_indexes ) if @debug_flag
        puts "word is now: [ WORD_INDEX = #{ a[0] }, WORD_VALUE = #{ a[1] }, WORD_LENGTH = #{ a[2] }, " + 
              "WORD_CONS_COUNT = #{ a[3] }, WORD_TARGET_LENGTH = #{ a[4] } ]" if @debug_flag
      end
    end
    puts "assign_initial_lengths returning array #{ return_indexes.to_s }" if @debug_flag
    return return_indexes
  end  #  assign_initial_lengths
end  #  class String
  # -----------------------------------------
  # pick_rcds
  #
  # Pick one record per item on pick_list, comparing to first element in array_of_arrays
  #
  # Written 09/07-12/2012 A.D. Roth
  # -----------------------------------------
  def pick_rcds( pick_list, array_of_arrays )
    #  puts; puts "Entering pick_rcds with pick_list of " + convert_array_to_line( pick_list )
    #  @show_obj = DisplayInfo.new if @show_obj.nil?
    #  @show_obj.show_array( "and array_of_arrays of ", array_of_arrays )  #  09/07/2012
    #  puts  #  09/06/2012
    return_array = Array.new
    until pick_list.length == 0
      pick_item = pick_list.shift
      #  puts; puts "pick_item is now #{ pick_item }"
      done_flag = false
      array_of_arrays.each do | cand | 
        #  puts "cand[ 0 ] is #{ cand[ 0 ] } and done_flag is " + 
        #      convert_boolean_to_string( done_flag )
        if pick_item == cand[ 0 ] && !done_flag
          return_array << cand
          done_flag = true
        end 
        #  puts "return_array now has #{ return_array.length } members."
      end
    end
    #  puts; puts "pick_list will be " + convert_array_to_line( pick_list )
    #  pick_list.each { | picked | possible_affinities << affinity_cands[ picked ] }
    return return_array
  end  #  pick_rcds
# ---------------------------------------
# put_pgm_headline
# 
# Ruby method to display a the initial line for a program.  Example:
#   put_pgm_headline( 'data_import', __FILE__, __LINE__ ) 
#
# Written 10/03/2012 A. D. Roth
# -----------------------------
def put_pgm_headline( pgm_name, file_name, line_no, debug_flag = false )
  require 'date'
  require 'parsedate'
  puts "-------Starting #{ pgm_name } at #{ DateTime.now } ( File #{ file_name } " + 
      "line #{ line_no } ) -----------" # if debug_flag
end  #  put_pgm_headline

