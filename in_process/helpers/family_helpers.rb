# family_helpers
#
# Written 08/22/2012 A.D. Roth gathering methods from family_data_controller
# ---------------------------------------------
# As of 08/22/2012:
#  Constants:
#   HORIZ_INDICES
#
#  Methods:
#   def do_parent_rcd( child_rcd, curr_gen, gender )  #  parent's gender is "m" or "f"
#   def show_cell_rcd( one_rcd, col_heads )
#   def show_cell_array( desc, cell_array )
#   def prep_cell_array( orientation, initial_record, gen_limit )
#   def build_name_list( curr_rcd )
#   def build_children_list( parent_rcd )
#   def setup_for_build( parent_rcd )
#   def sort_cand_list( child_cands, child_cands_by_parent_name )
#   def find_parent_cands( id, name, gender_included )
#   def find_affinity_cands( family_datum )
#   def prep_tree_info( record, generation_count = 5, debug_flag = false )
#   def setup_for_show( show_name )
# -----------------------------------------------------------------
HORIZ_INDICES = [ [ 0, 1 ], [ 1, 2 ], [ 2, 9 ], [ 3, 3 ], [ 4, 6 ], [ 5, 4 ], 
    [ 6, 5 ], [ 7, 7 ], [ 8, 8 ], [ 9, 10 ], [ 10, 13 ], [ 11, 11 ], [ 12, 12 ], 
    [ 13, 14 ], [ 14, 15 ] ]  #  for prep_cell_array
  # -----------------------------------  
  # do_parent_rcd
  #
  # Submethod for prep_cell_array to prepare rcd_entry.  curr_gen is generation 
  # level for parents, and on entry will be no greater than the caller's 
  # generation limit.
  #
  # Written 08/12-15/2012 A.D. Roth
  # -----------------------------------
  def do_parent_rcd( child_rcd, curr_gen, gender )  #  parent's gender is "m" or "f"
    require 'general_helpers_201109'
    debug_flag = false
    parent_type = ( gender == 'm' ? "father" : "mother"  )
    #  puts; puts 'parent_type is ' + parent_type if debug_flag
    parent_id_field = parent_type + "id"
    child_rcd = ' ' if child_rcd.nil?
    # determine rcd_entry (either a record or a string)
    # 1.  if child_rcd is a string, then there is no parent info. so generate dummy cell
    # 2.  otherwise, is parent_id provided, and is that a record?
    # 3.  otherwise, is parent name provided? 
    if child_rcd.class == FamilyDatum 
      #  puts; puts "child_rcd.class == FamilyDatum" if debug_flag
      if !(child_rcd[ parent_id_field ].nil?) &&   #  not nil and not blank
          !( child_rcd[ parent_id_field ].to_s.chomp.lstrip.rstrip == '' ) &&
          ( child_rcd[ parent_id_field ].to_i > 0 )  # also not zero
        rcd_entry = FamilyDatum.find( child_rcd[ parent_id_field ] )
      elsif !(child_rcd[ parent_type ].nil?) &&   #  not nil and not blank
          !( child_rcd[ parent_type ].to_s.chomp.lstrip.rstrip == '' )  
        #  puts; puts "!(child_rcd[ parent_type ].nil?" if debug_flag
        #  puts; puts 'child_rcd[ parent_type ] is ' + child_rcd[ parent_type ] if debug_flag
        rcd_entry = FamilyDatum.find_by_name( child_rcd[ parent_type ] )
        #  puts 'FamilyDatum.find_by_father( child_rcd[ parent_type ] ) is ' + FamilyDatum.find_by_father( child_rcd[ parent_type ] ).inspect if debug_flag
        #  is parent name supplied? Then create entry based on String name
        #  puts 'rcd_entry.nil? is ' + convert_boolean_to_string( rcd_entry.nil? ) if debug_flag
        rcd_entry = child_rcd[ parent_type ] if rcd_entry.nil?
      else        
        #  puts; puts "rcd_entry = ''" if debug_flag
        rcd_entry = ''
      end
    else  # it is a string; provide dummy record
      #  create dummy cell for parent
      #  puts "create dummy #{ parent_type } cell for gen #{ curr_gen }"
      rcd_entry = ''
    end
    #  puts "do_parent_rcd returning rcd_entry " + convert_record_to_line( rcd_entry )
    return rcd_entry
  end  #  do_parent_rcd
# -----------------------------------
# show_cell_rcd
#
# Prints formatted output of rcd.
#
# Written 07/31/2012 A.D. Roth based on convert_array_to_line and convert_record_to_line
# -----------------------------------
    def show_cell_rcd( one_rcd, col_heads )
      result_string = ""
      prec_comma = ", "
      index = 0
      limit = col_heads.length - 2
      out_string = ""
      col_heads.each_with_index do | head, head_ix |
        out_string += "#{ head_ix }. #{ head }: #{ one_rcd[ head ].inspect }" + prec_comma + " "
        prec_comma = "" if index == limit
        index += 1
      end
      puts; puts out_string
    end  #  show_cell_rcd
    # -----------------------------------
    # show_cell_array
    #
    # Each cell consists of record, generation level, and gender (for css).
    # This method prepares the line(s) for the record, then the last two strings
    #
    # Written 07/31/2012 A.D. Roth based on show_array
    # Rev. 08/02/2012 to debug
    # -----------------------------------
    def show_cell_array( desc, cell_array )
      #  determine col_heads for this record type.
      col_heads = Array.new
      FamilyDatum.columns.each { | one_col | col_heads <<  one_col.name }
      # @show_info = DisplayInfo.new if @show_info.nil?
      # @show_info.show_array( "col_heads in show_cell_array will be", col_heads )
      #  print out records
      temp_array = Array.new
      cell_array.each { | cell | temp_array << cell }
      dummycell = temp_array.shift
      puts "#{ temp_array[ 1 ].class } #{desc}:"
      temp_array.each_with_index do | curr_cell, cell_ix | 
        if curr_cell.length == 0
          puts "#{ cell_ix }. Empty cell."  
        else
          curr_rcd, gen_level, gender = curr_cell
          # puts; puts "curr_rcd, class #{ curr_rcd.class }, is "
          puts "#{ cell_ix }.  Record of class #{ curr_rcd.class }:"
          result_string = ""
          prec_comma = ", "
          index = 0
          limit = col_heads.length - 2
          col_heads.each do | one_col |
            h = curr_rcd[ one_col ]
            #  puts "Next item is #{ one_col.inspect } => #{ h.inspect }"
            result_string += "#{ one_col } => '#{ h }'" + prec_comma
            prec_comma = "" if index == limit
            index += 1
          end
          #  print out generation level and gender, as if an array of 2.
          puts "#{ curr_rcd.class }: #{ result_string }"
          puts "Generation level: #{ curr_cell[ 1 ] }"
          puts "Gender: #{ curr_cell[ 2 ] }"
        end
      end  #  cell_array.each_with_index
    end  #  show_cell_array
# ---------------------------------------------
# prep_cell_array
#
#    Set up cell_array for table display.  Horizontal to start with.
#
#    One cell consists of record, generation level, and gender (for css).
#
#    Cell_array consists of cells, in table-writing order based on "vertical"
# or "horizontal."  Only horizontal is implemented at first.  Assumed: a 
# horizontal table will be built using rowspan based on gen_level.
# 
# Element 0: "horizontal" or "vertical"
#            4. great-grandfather (gen 3)
#        3. grandfather (gen 2)
#            5. great_grandmother (gen 3)
#    2. father (gen 1)
#            7. great-grandfather (gen 3)
#        6. grandmother (gen 2)
#            8. great_grandmother (gen 3)
# [ 1. entry (gen 0) ]
#            11. great-grandfather (gen 3)
#        10. grandfather (gen 2)
#            12. great_grandmother (gen 3)
#    9. mother (gen 1)
#            14. great-grandfather (gen 3)
#        13. grandmother (gen 2)
#            15. great_grandmother (gen 3)
#
#    So run off a queue, shifting next member after last gen. hit and filled in.
#
#    Returns @cell_array, for which first member is a string showing orientation 
# and each subsequent member is an array of [ curr_rcd, curr_gen, curr_gender ].
#
# Written 07/15-08/03/2012 A.D. Roth
# Rev. 08/11-16/2012 to debug why empty cells are created for extra generation
# ---------------------------------------------
def prep_cell_array( orientation, initial_record, gen_limit )
  # ---------------Begin prep_cell_array MAIN ---------------------------
  debug_flag = true
  #  set up cell_array

  # mor far far has mother 2ce, incl once for father.

  return_array = [ "horizontal" ]  # initialize with first member
  # gender doesn't matter for first record
  process_q = [ [ initial_record, 0, initial_record.gender ] ]
  until process_q.nil? || ( process_q.length <= 0 )  #  work through @process_q
    #  puts; puts "in prep_cell_array at the first 'until', process_q is " + 
    #      convert_record_array_to_lines( process_q ) if debug_flag
    curr_rcd, curr_gen, curr_gender = process_q.pop
    #  save cell for curr_rcd
    return_array << [ ( curr_rcd.nil? ? '' : curr_rcd ), curr_gen, curr_gender ]
    #  puts; puts "curr_rcd is #{ curr_rcd.inspect }"
    curr_gen += 1  #  move up for parents' cells
    #  process father line
    until ( curr_gen > gen_limit )
      #  puts; puts "in prep_cell_array at the second 'until' with curr_gen = " + 
      #      "#{ curr_gen }, process_q is " + convert_record_array_to_lines( process_q ) if debug_flag
      #  show_cell_array( "return_array so far is ", return_array) if debug_flag
      #  puts "curr_gen is now #{ curr_gen } and gen_limit is #{ gen_limit }"
      father_rcd = do_parent_rcd( curr_rcd, curr_gen, 'm' )
      #  puts; puts "father_rcd is " + convert_record_to_line( father_rcd ) if debug_flag
      mother_rcd = do_parent_rcd( curr_rcd, curr_gen, 'f' )
      #  puts; puts "mother_rcd is " + convert_record_to_line( mother_rcd ) if debug_flag
      return_array << [ father_rcd, curr_gen, 'm' ]
      if curr_gen < gen_limit
        #  add mother to process_q if curr_gen < gen_limit
        #  puts "mother_rcd going to q" if debug_flag
        process_q << [ mother_rcd, curr_gen, 'f' ]
        curr_rcd = father_rcd
        curr_gender = 'm'
      elsif curr_gen == gen_limit
        #  process mother
        #  puts "processing mother_rcd, curr_gen = #{ curr_gen }" if debug_flag
        return_array << [ ( mother_rcd.nil? ? '' : mother_rcd ), curr_gen, 'f' ]
      end
      curr_gen += 1  #  move up for parents' cells
    end  #  until
  end  #  until b_done
  return return_array
end  #  prep_cell_array
# -----------------------------------
# build_name_list_from_name
#
#    Builds array of alternate names from the alias file based on name input, 
# returning the values sorted in @name_list.  First member of name_list will be name, if any hits.
#    Unlike build_name_list, this method does not search for alias by membid.
#
# Written 09/10-11/2012 A.D. Roth based on build_name_list
# -----------------------------------
def build_name_list_from_name( name_in )
  #  puts; puts "Entering build_name_list_from_name, name_in is #{ name_in.inspect }"
  cands_by_name_with_alias = FamilyAlias.find_all_by_alias_name( name_in, :order => 'name' )
  #  puts; puts "cands_by_name_with_alias is " + convert_record_array_to_lines( cands_by_name_with_alias ) +
  #      ", length #{ cands_by_name_with_alias.length }" if @debug_flag
  #  build name_cands by analyzing cands_by_alias_id and cands_by_name_with_alias
  if cands_by_name_with_alias && cands_by_name_with_alias.length > 0
    name_cands = [ name_in ] 
    cands_by_name_with_alias.each { | cand | ( name_cands << cand.name ) unless 
        name_cands.include?( cand.name ) }
    #  puts; puts "after incorporating cands_by_name_with_alias, name_cands is " + 
    #      convert_array_to_line( name_cands ) if @debug_flag
  end
  #  sort cand list and build @name_list
  #  puts; puts "build_name_list_from_name returning name_list as " + 
  #     convert_array_to_line( name_cands ) if @debug_flag
  @name_list = ( name_cands.nil? ? [ name_in ] : name_cands )
end  #  build_name_list_from_name
# -----------------------------------
# build_full_name_list
#
#    Builds array of alternate names from the alias file based on name or hash5 input, 
# returning the values sorted in @name_list.  First member of name_list will be 
# the input name.
#    Unlike build_name_list, this method does not search for alias by membid.
# Unlike build_name_list_from_name, the list includes all record names for this
# name as an alias, and all alias names for those record names.
#
# Written 09/15-18/2012 A.D. Roth based on build_name_list
# -----------------------------------
def build_full_name_list( name_in )
  #  puts "Entering build_full_name_list, name_in is #{ name_in }" if @debug_flag
  #  puts; puts "Entering build_full_name_list, name_in is #{ name_in.inspect }"
  first_names = [ name_in ]
  #  puts; puts "There are " + FamilyAlias.find( :all ).length.to_s + " records for alias."
  #  puts "There are these records for alias:"
  #  puts convert_record_array_to_lines( FamilyAlias.find( :all ) )
  #  puts; puts "There are " + FamilyAlias.find_all_by_alias_name( name_in, 
  #      :order => 'name' ).length.to_s + " records for pull by alias_name."
  #  puts "There are " + FamilyAlias.find_all_by_alias_hash5( name_in.upcase, 
  #      :order => 'name' ).length.to_s + " records for pull by alias_hash5 of '#{ name_in.upcase }'."
  #  puts "There are " + FamilyAlias.find_all_by_name( name_in, 
  #      :order => 'name' ).length.to_s + " records for pull by name."
  cand_rcds = FamilyAlias.find_all_by_alias_name( name_in, :order => 'name' ) +
      FamilyAlias.find_all_by_name( name_in, :order => 'name' ) + 
      FamilyAlias.find_all_by_alias_hash5( name_in.upcase, :order => 'name' )
  #  puts "After initial pull, cand_rcds has #{ cand_rcds.length } rcds."
  cand_rcds.each { | one_rcd | cand_rcds += FamilyAlias.find_all_by_name( one_rcd.name, :order => 'name' ) }
  #  puts "After second pull, cand_rcds has #{ cand_rcds.length } rcds."
  cand_rcds.each do | rcd | 
    first_names << rcd.alias_name unless first_names.include?( rcd.alias_name )
    first_names << rcd.name  unless first_names.include?( rcd.name )
  end if cand_rcds && cand_rcds.length > 0
  #  puts; puts "names gathered so far are " + convert_array_to_line( first_names ) +
  #      ", length #{ first_names.length }" if @debug_flag
  #  sort cand list and build @name_list
  name_list = first_names.sort.uniq
  #  puts 'Exiting build_full_name_list, returning name_list of ' +
  #      convert_array_to_line( name_list ) if @debug_flag
  return name_list
end  #  build_full_name_list
# -----------------------------------
# build_name_list
#
#    Builds array of alternate names for a family_data record, returning the values in 
# @name_list from family_aliases.
#
# Written 08/08/2012 A.D. Roth based on build_children_list
# Rev. 09/08/2012 to edit comment
# -----------------------------------
def build_name_list( curr_rcd )
  #  puts; puts "Entering build_name_list, curr_rcd is #{ curr_rcd.inspect }"
  cands_by_alias_id = FamilyAlias.find_all_by_membid( curr_rcd.membid, :order => 'name' )
  #  puts; puts "cands_by_alias_id is " + convert_record_array_to_lines( cands_by_alias_id ) +
  #       ", length #{ cands_by_alias_id.length }" if @debug_flag
  cands_by_name_with_alias = FamilyAlias.find_all_by_name( curr_rcd.name, :order => 'name' )
  #  puts; puts "cands_by_name_with_alias is " + convert_record_array_to_lines( cands_by_name_with_alias ) +
  #      ", length #{ cands_by_name_with_alias.length }" if @debug_flag
  #  build name_cands by analyzing cands_by_alias_id and cands_by_name_with_alias
  name_cands = [ curr_rcd.name ]
  cands_by_alias_id.each { | cand | name_cands << cand.alias_name } if 
      cands_by_alias_id && cands_by_alias_id.length > 0
  #  puts; puts "after incorporating cands_by_alias_id, name_cands is " + 
  #      convert_array_to_line( name_cands ) if @debug_flag
  if cands_by_name_with_alias && cands_by_name_with_alias.length > 0
    cands_by_name_with_alias.each { | cand | ( name_cands << cand.alias_name ) unless 
        name_cands.include?( cand.alias_name ) }
    #  puts; puts "after incorporating cands_by_name_with_alias, name_cands is " + 
    #      convert_array_to_line( name_cands ) if @debug_flag
    end
    #  sort cand list and build @name_list
    #  puts; puts "build_name_list returning curr_rcd.name_list as " + 
    #     convert_array_to_line( name_cands ) if @debug_flag
    @name_list = name_cands.sort
end  #  build_name_list
# -----------------------------------
# build_children_list
#
# Builds array of person records for children of a parent in array @children.
#
# Written 08/05-07/2012 A.D. Roth
# Rev. 08/07/2012 to add search in alias for parent name
# Rev. 08/10/2012 to change reference to @name_list
# -----------------------------------
def build_children_list( parent_rcd )
  require 'general_helpers_201109'
  # -----------------------------------  
  # setup_for_build
  #
  # Written 08/08/2012 A.D. Roth
  # -----------------------------------
  def setup_for_build( parent_rcd )
    #  find candidate records for children of parent
    #  puts; puts "@name_list has #{ @name_list.length } entries. "
    child_cands_by_parent_name = Array.new
    @name_list.each do | name_cand | 
        #  puts "Now processing name_cand '#{ name_cand }'"
        child_cands_by_parent_name += ( parent_rcd.gender == "m" ? 
            FamilyDatum.find( :all, :conditions => [ "father = ?", name_cand ], 
            :order => "birth_date, name" ) : 
            FamilyDatum.find( :all, :conditions => [ "mother = ?", name_cand ], 
            :order => "birth_date, name" ) ) 
        #  child_cands_by_parent_name = FamilyDatum.find( :all, :conditions => [ "father = ?", name_cand ], 
        #      :order => "birth_date, name" )  if parent_rcd.gender == "m"
        #  puts; puts " child_cands_by_parent_name is #{ child_cands_by_parent_name.inspect }, class " + 
            child_cands_by_parent_name.class.to_s  if @debug_flag
        #  puts; puts " child_cands_by_parent_name class is " + 
            child_cands_by_parent_name.class.to_s  if @debug_flag
    end  
    child_cands_by_parent_id = ( parent_rcd.gender == "m" ? 
        FamilyDatum.find_all_by_fatherid( parent_rcd.membid, 
            :order => "birth_date, name" ) : 
        FamilyDatum.find_all_by_motherid( parent_rcd.membid, 
            :order => "birth_date, name" ) ) 
    #  puts; puts " child_cands_by_parent_id is " + 
    #      convert_record_array_to_lines( child_cands_by_parent_id ) if @debug_flag
    child_cands = Array.new
    if child_cands_by_parent_id && child_cands_by_parent_id.length > 0
      child_cands_by_parent_id.each { | cand | child_cands << 
          [ ( cand.birth_date ? cand.birth_date : "" ), 
          cand.name, cand.membid, cand.id, cand ] }
      unless child_cands_by_parent_id.nil?
        cands_by_parent_id_names = child_cands.transpose[ 1 ]
        cands_by_parent_id_membids = child_cands.transpose[ 2 ]
        cands_by_parent_id_rcd_ids = child_cands.transpose[ 3 ]
      end
    end
    #  add to child_cands by analyzing child_cands_by_parent_name
    if child_cands_by_parent_name && child_cands_by_parent_name.length > 0
      child_cands_by_parent_name.each do | cand |
        #  is this name's membid already picked?
        if child_cands_by_parent_id.nil?
          child_cands << [ ( cand.birth_date ? cand.birth_date : "" ), 
              cand.name, cand.membid, cand.id, cand ] 
        else
          unless ( !cands_by_parent_id_membids.nil? && 
              cands_by_parent_id_membids.include?( cand.membid ) ) ||
              #  is this name's name and record id already picked?
              ( !cands_by_parent_id_rcd_ids.nil? && 
              cands_by_parent_id_rcd_ids.include?( cand.id ) ) ||
              ( !cands_by_parent_id_names.nil? && 
              cands_by_parent_id_names.include?( cand.name ) )
            #  else, include  
            child_cands << [ ( cand.birth_date ? cand.birth_date : "" ), 
                cand.name, cand.membid, cand.id, cand ] 
          end
        end
      end  # child_cands_by_parent_name.each
    end
    return [ child_cands, child_cands_by_parent_name ]
  end  #  setup_for_build
  # -----------------------------------  
  # sort_cand_list
  #
  # Written 08/08/2012 A.D. Roth
  # -----------------------------------
  def sort_cand_list( child_cands, child_cands_by_parent_name )
  # sort cand list and build @children list
  @children = Array.new   
  #  puts; puts "child_cands is " + convert_record_array_to_lines( child_cands ) +
  #      ", length #{ child_cands.length }" if @debug_flag
  if child_cands.length > 1
    #  puts; puts "child_cands.length is #{ child_cands.length }, so > 1" if @debug_flag    
    children_full = child_cands.sort { | x, y | x[ 0 ].to_s <=> y[ 0 ].to_s }
    #  puts; puts "children_full is " + convert_record_array_to_lines( children_full ) if @debug_flag
    @children = children_full.transpose[ 4 ]
  elsif child_cands.length == 1
    #  puts; puts "child_cands is " + convert_record_array_to_lines( child_cands ) +
    #      ", length #{ child_cands.length }" if @debug_flag
    #  puts; puts "child_cands[ 4 ] is " + convert_record_to_line( child_cands[ 4 ] ) +
    #      ", class #{ child_cands[ 4 ].class }, that is, #{ child_cands[ 4 ].inspect }, " +
    #      "and child_cands is #{ child_cands.inspect }"  if @debug_flag    
    @children = [ child_cands[0][ 4 ] ]
  end
  #  puts ( @children ? 
  #      "At the end of build_children_list, @children is " + 
  #      convert_record_array_to_lines( @children ) : 
  #      "At the end of build_children_list, @children is empty." ) if @debug_flag
  end  #  sort_cand_list
  # ------------------- start build_children_list MAIN -----------------------
  puts; puts "On entry to build_children_list, parent_rcd ( the input object) is " + 
      convert_record_to_line( parent_rcd ) if @debug_flag
  #  find all alias names for parent
  build_name_list( parent_rcd )  #  returns @name_list; maybe eventually in model definition
  #  puts "@name_list is " + convert_array_to_line( @name_list )
  child_cands, child_cands_by_parent_name = setup_for_build( parent_rcd )
  #  check alias name
  sort_cand_list( child_cands, child_cands_by_parent_name )
end  #  build_children_list
# ---------------------------------------------
    # find_parent_cands
    #
    # Written 08/21/2012 A.D. Roth
    # -----------------------------------------
    def find_parent_cands( id, name, gender_included )
      #  puts "Entering find_parent_cands for id = '#{ id.inspect }', " +
      #      "name = '#{ name }', and for gender of '#{ gender_included }'."
      parent_cands = ( ( !id.nil? ) && id > 0 ?  
          FamilyDatum.find_all_by_membid( id, :order => "birth_date, name" ) : 
          FamilyDatum.find_all_by_name( name, :order => "birth_date, name" ) )
      #  puts "parent_cands has #{ parent_cands.length.to_s } records."
      parents = Array.new
      parent_cands.each { | cand | parents << cand if cand.gender.downcase == gender_included }
      #  puts "find_parent_cands returning #{ parents.length.to_s } records."
      return parents
    end  #  find_parent_cands
    # -----------------------------------------
# weed_dup_rcds_btn_rcd_arrays
#
#    Returns array of records from rcd_array_proposed whose ids are not already in 
# the key list. (Unique values within an array can be isolated with .uniq or .uniq!)
#
# Written 08/23/2012 A.D. Roth
# -----------------------------------------
def weed_dup_rcds_btn_rcd_arrays( key_list, rcd_array_proposed )
  selecteds = Array.new
  rcd_array_proposed.each { | one_rcd | selecteds << one_rcd unless 
      key_list.include?(one_rcd.id ) }
  return selecteds
end  #  weed_dup_rcds_btn_rcd_arrays
# -----------------------------------------
# weed_dup_rcds_by_id
#
#    Returns array of indices of the unique records in rcd_array.  Records
# must have an 'id' field that in the database table is unique for each record.
#
#    This method will be unnecessary if .uniq does the job.
# Written 08/23/2012 A.D. Roth
# -----------------------------------------
def weed_dup_rcds_by_id( rcd_array )
  pick_list = Array.new
  rcd_array.sort! { | x, y | y.id <=> x.id }
  cands_count = rcd_array.length
  rcd_array.each_with_index do | cand, cand_ix |
    puts; puts "Checking cand_ix #{ cand_ix } " + 
        "('#{ cand.name }' with '#{ cand.connection_name }'), " + 
        "cands_count is #{ cands_count }"
    puts 'rcd_array[ cand_ix + 1 ] is ' + 
        convert_boolean_to_string( rcd_array[ cand_ix + 1 ] )
    puts 'The condition "( ( cand_ix + 1 ) == cands_count ) || 
    !( cand.id == rcd_array[ cand_ix + 1 ].id ) ", ' + 
        'required to add to pick_list, is ' + 
        convert_boolean_to_string( ( ( cand_ix + 1 ) == cands_count ) || 
    !( cand.id == rcd_array[ cand_ix + 1 ].id )  )
    puts 'The condition "( cand_ix + 1 ) == cands_count" is ' + 
        convert_boolean_to_string( ( cand_ix + 1 ) == cands_count ) 
    puts 'The condition "!( cand.id == rcd_array[ cand_ix + 1 ].id )" is ' + 
        convert_boolean_to_string( !( cand.id == rcd_array[ cand_ix + 1 ].id ) )
    #  puts 'The condition "!( cand.id == rcd_array[ cand_ix + 1 ].id )" is ' + 
    #      convert_boolean_to_string( ( !( cand.id == rcd_array[ cand_ix + 1 ].id ) ) )
    pick_list << cand_ix if ( ( cand_ix + 1 ) == cands_count ) || 
    !( cand.id == rcd_array[ cand_ix + 1 ].id ) 
  end  #  rcd_array.each_with_index
  return pick_list
end  #  weed_dup_rcds_by_id
# -----------------------------------------
# find_affinity_cands
#
# Returns affinities, records tied by membid, and possible_affinities, 
# suggested by name or hash5
#
# 1.  Make a list of affinity rcds with input membid either the principal membid
#     or the connection membid.
# 2.  Make a list of possible additional affinity records, based on the input
#     name and any aliases of that name.
#
# Written 08/21-23/2012 A.D. Roth
# Rev. 09/28/2012 to base alias processing on build_full_name_list instead of build_name_list
# -----------------------------------------
def find_affinity_cands( family_datum )
  # -----------------------------------------
  # process_one_alias
  #
  # Process one alias
  #
  # Written 08/24/2012 A.D. Roth
  # Rev. 09/19/2012 to condition puts statements
  # -----------------------------------------
  def process_one_alias( one_alias )
    more_cands = Array.new
    #  Build array of family_datum records from affinities, using all the curr_rcd aliases.
    puts; puts '-----------'; puts "Searching for records for name = '#{ one_alias.inspect }'." if @debug_flag
    curr_hash5 = one_alias.my_string_hash( 5 )
    puts; puts "Searching for records for hash5 = '#{ curr_hash5.inspect }'." if @debug_flag
    all_affinities = FamilyAffinity.find( :all )
    all_affinities.each do | one_rcd | 
      puts "one_rcd.name ['#{ one_rcd.name }'] == one_alias ['#{ one_alias }'] ? " + 
          convert_boolean_to_string( one_rcd.name == one_alias ) if @debug_flag
      puts "one_rcd.name.my_string_hash( 5 ) " + 
          "['#{ one_rcd.name.my_string_hash( 5 ) }'] == curr_hash5 ['#{ curr_hash5 }'] ? " + 
          convert_boolean_to_string( one_rcd.name.my_string_hash( 5 ) == curr_hash5 ) if @debug_flag
      puts "one_rcd.connection_name == one_alias" + 
          "['#{ one_rcd.connection_name }'] == one_alias ['#{ one_alias }'] ? " + 
          convert_boolean_to_string( one_rcd.connection_name == one_alias ) if @debug_flag
      puts "one_rcd.connection_name.my_string_hash( 5 ) " + 
          "['#{ one_rcd.connection_name.my_string_hash( 5 ) }'] == curr_hash5 ['#{ curr_hash5 }'] ? " + 
          convert_boolean_to_string( one_rcd.connection_name.my_string_hash( 5 ) == curr_hash5 ) if @debug_flag
      if one_rcd.name == one_alias ||
        one_rcd.name.my_string_hash( 5 ) == curr_hash5 ||
        one_rcd.connection_name == one_alias ||
        one_rcd.connection_name.my_string_hash( 5 ) == curr_hash5 
          more_cands << one_rcd 
      end
    end
    puts; puts ( more_cands.nil? ? "No" : "#{ more_cands.length }" ) + 
        " possible records found for '#{ one_alias.inspect }'." if @debug_flag
    ( @affinity_cands.nil? ? affinity_cands = more_cands : 
        @affinity_cands += more_cands ) if !more_cands.nil?
    puts; puts "Now #{ @affinity_cands.length } @affinity_cands records." if @debug_flag
    #  more_cands = FamilyAffinity.find_all_by_connection_name( one_alias ) # , 
    #      :order => "relationship, other_type_value" ) 
    #  puts; puts "#{ more_cands.length } connection_name records found for '#{ one_alias.inspect }'.."
    #  ( @affinity_cands.nil? ? @affinity_cands = more_cands : 
    #      @affinity_cands += more_cands ) if !more_cands.nil?
    puts; puts "Now #{ @affinity_cands.length } affinity_cands records." if @debug_flag
  end   #  process_one_alias
  # --------------- Begin find_affinity_cands MAIN -----------------------------------------
  @debug_flag = true
  affinity_ids = Array.new
  name = family_datum.name
  puts; puts "Entering find_affinity_cands for name = '#{ name.inspect }'." if @debug_flag
  affinities = FamilyAffinity.find_all_by_membid( family_datum.membid )
  more_affinities = FamilyAffinity.find_all_by_connection_membid( family_datum.membid )
  affinities += more_affinities unless more_affinities.nil?
  affinities.sort! { | x, y | y.name <=> x.name }
  affinities.each { | one_rcd | affinity_ids << one_rcd.id }
  possible_affinities = Array.new
  @affinity_cands = Array.new
  #  First find confirmed affinities (confirmed by membid)
  #  Then find possibilities based on name or hash5
  name_list = build_full_name_list( family_datum.name )
  #  name_list is an array of alias names
  name_list.each { | one_alias | process_one_alias( one_alias ) }  #  output is to @affinities_cands  
  puts "At the end of the searches, there are #{ @affinity_cands.length } @affinity_cands:" if @debug_flag
  puts convert_record_array_to_lines( @affinity_cands ) unless @affinity_cands.nil? || !@debug_flag
  #  Then weed duplicates with same id
  possible_affinities = @affinity_cands.uniq unless @affinity_cands.nil?
  puts "After weeding out duplicates among the possibles, there are " + 
      "#{ @affinity_cands.length } @affinity_cands:" if @debug_flag
  puts convert_record_array_to_lines( @affinity_cands ) unless @affinity_cands.nil? || !@debug_flag
  #  Weed duplicates in possible_affinities that are already in affinities.
  possible_affinities = weed_dup_rcds_btn_rcd_arrays( affinity_ids, possible_affinities )
  puts "After weeding out duplicates with the affinity list, there are " + 
      "#{ @affinity_cands.length } @affinity_cands:" if @debug_flag
  puts convert_record_array_to_lines( @affinity_cands ) unless @affinity_cands.nil? || !@debug_flag
    #  pick_list = weed_dup_rcds_by_id( affinity_cands )
    #  puts; puts "pick_list will be " + convert_array_to_line( pick_list )
    #  pick_list.each { | picked | possible_affinities << affinity_cands[ picked ] }
  #  end  #  unless
  puts "find_affinity_cands returning #{ affinities.length } affinity records and " +
      "#{ possible_affinities.length } possible records." if @debug_flag
  @debug_flag = false
  return [ affinities, possible_affinities ]
end  #  find_affinity_cands
# -----------------------------------------
# srch_for_name
#
#    Using input name, prepares list of candidate records as array of 
# [ [ membid, rcd, result_type], ...  ]
#
# Written 09/03-04/2012 A.D. Roth based on show_list in family_data_controller.rb
# Rev. 09/06-19/2012 to redesign search and also limit no. of records retrieved
# Rev. 11/11/2012 to tweak comment
# -----------------------------------------
SEARCH_RESULT_TYPES = [ "0. dummy, so numbers start with one", 
          "1. name match", 
          "2. alternate name match", 
          # Then only add records if there are fewer than 5
          "3. first & last match", 
          "4. alias first & last match", 
          "5. hash5 match",
          "6. alternate name hash5 match",
          "7. one word match"
    ]
def srch_for_name( name_in )  #  output is array of cand_rcds
  require 'general_helpers_201207'
  # -----------------------------------------
  # find_1st_n_last_words
  #
  # Written 07/03-05/2012 A.D. Roth
  # -----------------------------------------
  def find_1st_n_last_words( phrase )
    # test_regexp(0, phrase, /^(\w+)/ )
    pos = phrase =~ /^(\w+)/
    first_word = $1
    if phrase.split(' ').length > 1  #  word count in the string
      pos = phrase =~ /(\w+)$/
      last_word = $1
      return_str = check_for_nil( first_word ) + 
          ( last_word && last_word.length > 0 ? " " : "") + 
          check_for_nil( last_word )
      #  puts "find_1st_n_last_words returning '#{ return_str }' for '#{ phrase }', " + 
      #      "length #{ %w( phrase ).length.to_s }"
    else
      return_str = first_word
    end
    return return_str
  end  #  find_1st_n_last_words
  # -----------------------------------------
  # do_one_word_matches
  #
  # Search for type 7.
  #
  # Written 09/09-18/2012 A.D. Roth
  # -----------------------------------------
  def do_one_word_matches( srch_str )
    puts "Entering do_one_word_matches for '#{ srch_str }'"
    srch_rcds = FamilyDatum.find( :all, :order => "name, father, mother" ) 
    puts "There are #{ srch_rcds.length } srch_rcds for '#{ srch_str }'"
    srch_rcds.each_with_index do | srch_rcd, rcd_ix | 
      puts "Now checking record for '#{ srch_str }'"
      srch_str.split(' ').each do | input_word |
        puts; puts "Starting one-word search for '#{ input_word }' from " + 
             "'#{ srch_str }' in #{ srch_rcd.name }" if @debug_flag
        srch_rcd.name.split(' ').each { | rcd_word | 
          @cand_rcds << [ srch_rcd.membid, srch_rcd, SEARCH_RESULT_TYPES[ 7 ] ] if 
              rcd_word.upcase == input_word.upcase  } #  "7. one word match"
      end #  if ( srch_rcd.name.split(' ').length > 1 )
    end if srch_rcds
  end  #  do_one_word_matches
  # -----------------------------------------
  # try_for_cands
  #
  # Retrieve one or more datum records and save in @cand_rcds
  #
  # Written 09/12-18/2012 A. D. Roth
  # -----------------------------------------
  def try_for_cands( col_head, comparison, result_type )  #  outputs to @cand_rcds
    if ( @cand_rcds.length < 5 )
      try_rcds = FamilyDatum.find( :all, :conditions => [ "#{ col_head } = ?", 
          comparison ], :order => "name, father, mother" ) 
      try_rcds.each { | one_cand | @cand_rcds << 
          [ one_cand.membid, one_cand, SEARCH_RESULT_TYPES[ result_type ] ] } if try_rcds
    end
  end  #  try_for_cands
  # -----------------------------------------
  # try_first_n_last
  #
  # Compare first_n_last words of comparison against name of datum.
  #
  # Written 09/12-18/2012 A. D. Roth
  # -----------------------------------------
  def try_first_n_last( comparison, result_type )  #  outputs to @cand_rcds
    all_datums = FamilyDatum.find( :all, :order => "name, father, mother" ) 
    all_datums.each { | one_cand | 
      @cand_rcds << [ one_cand.membid, one_cand, SEARCH_RESULT_TYPES[ result_type ] ] if 
          find_1st_n_last_words( one_cand.name ) == find_1st_n_last_words( comparison ) 
    } if all_datums
  end  #  try_first_n_last
  # ------------------- begin srch_for_name MAIN --------------------
  require 'general_helpers_201207'
  #  puts; puts "Entering srch_for_name for name '#{ name_in }'"
  @cand_rcds = Array.new  
  #  @result_type_max = 0  #  index of highest result type so far, to limit no. of rcds found
  #  array of array of records of class FamilyDatum: membid, then rcd, then result_type
  #  this eases weeding duplicates
  search_string = name_in.lstrip.rstrip
  srch_rcds = Array.new  #  array records of class FamilyDatum: rcd, then search_type
  #
  #  search among the family_data records
  #
  try_for_cands( 'name', search_string, 1 )  #  "1. name match", outputs to @cand_rcds
  name_list = build_full_name_list( search_string )  #  returns name_list
  #  build_name_list_from_name( search_string )  #  returns a new @name_list
  # puts; puts "back to srch_for_name, name_list is " + convert_array_to_line( name_list ) if @debug_flag
  #  ( name_list.nil? ? name_list = [ ] : name_list.shift ) #  drop the name itself
  name_list.each { | one_name | try_for_cands( 'name', one_name, 2 ) } if
      !name_list.nil? && ( @cand_rcds.length < 5 ) && 
      ( name_list.length > 0 )  #  "2. alternate name match"
  try_first_n_last( search_string, 3 ) if ( @cand_rcds.length < 5 )  #  "3. first & last match"
  name_list.each { | one_name | try_first_n_last( one_name, 4 ) if 
      ( @cand_rcds.length < 5 )  }  if ( name_list.length > 0 )  #  "4. alias first & last match"      
  try_for_cands( 'hash5', search_string.my_string_hash( 5 ), 5 )  #  "5. hash5 match"
  name_list.each { | one_name | try_for_cands( 'hash5', one_name.my_string_hash( 5 ), 6 ) if 
      ( @cand_rcds.length < 5 ) } if ( name_list.length > 0 )  #  "6. alternate name hash5 match"
  #  "7. one word match" and "8. one word hash5 match"
  #  srch_rcds = FamilyDatum.find( :all, :order => "name, father, mother" ) 
  name_list.each { | one_name | do_one_word_matches( one_name ) } if ( @cand_rcds.length < 5 )
  #
  #  return only unique values
  #
  #  Then weed duplicates with same id
  inner_ids_array = Array.new
  @cand_rcds.each_with_index { | outer_array, array_ix | 
      inner_ids_array << outer_array[ 0 ] unless outer_array.nil? }  #  pick up the ids.
  pick_list = inner_ids_array.uniq  #  have the ids to use
  #  puts; puts "pick_list will be " + convert_array_to_line( pick_list )
  #  require 'display_info'
  return_array = pick_rcds( pick_list, @cand_rcds )
  #  puts; puts "srch_for_name returning return_array of "  #  09/06/2012
  #  @show_obj = DisplayInfo.new if @show_obj.nil?
  #  @show_obj.show_array( "srch_for_name returning return_array of ", return_array )
  #  puts convert_record_array_to_lines( return_array )  #  09/06/2012
  #  puts "---------------"; puts
  return return_array
end  #  srch_for_name
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
    # Creates array cell_array for display of tree.
    #
    # Example:
    # = extract_cells( record, generation_count, "vertical" )
    #
    # Adapted 10/05/2011 from do_tree_show in ancestors_helper.rb
    # -----------------------------------------------------------
    def extract_cells( this_entrant, gen_limit = 5, orientation = "horizontal", 
        debug_flag = false )  # entrant, no. of generations
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
          #  puts; puts "---------------- processing n = #{n} -----------"
          result_array = set_up_one_gen( n, cell_array )
          cell_array[ 2 * n + 1 ] = result_array[ 0 ]
          cell_array[ 2 * n + 2 ] = result_array[ 1 ]
        end  # upto    n
        #  puts "cell_array :" + cell_array.inspect + " in extract_cells" if debug_flag
      end  #  upto    gen
      return cell_array
    end  # extract_cells
    # ------------ prep_tree_info MAIN ----------------------------
    curr_class = record.class
    return_array = extract_cells( record, generation_count, "vertical" )  #  array of [ type, gen_limit, tbl_array ]
    #  tbl_array is of [ n, gen, entry_seq, data_hash ]
    if record.name then  #  later fill in fields
      @name = record.name
      @id = record.id.to_s
    else
      flash.now[:notice] = "This name not on file"
      @name = ""
    end
    puts "prep_tree_info returning return_array with " + ( return_array.nil? ? "nil" : 
        return_array.length ) + " members."
    return return_array
  end  # prep_tree_info
  # ---------------------------------------------
  # setup_for_show
  #
  # Written 09/21/2012 based on show method
  # ---------------------------------------------
  def setup_for_show( show_name )
      @show_name = @family_datum.name  #  @show_name is for heading in layout
      @fathers = find_parent_cands( @family_datum.fatherid, @family_datum.father, 'm' ) if 
          ( !@family_datum.nil? ) && ( @family_datum.fatherid || @family_datum.father )
      #  puts "@fathers has #{ @fathers.length.to_s } records."
      @mothers = find_parent_cands( @family_datum.motherid, @family_datum.mother, 'f' ) if 
          ( !@family_datum.nil? ) && ( @family_datum.motherid || @family_datum.mother )
      build_children_list( @family_datum )
      @family_aliases = FamilyAlias.find_all_by_membid( @family_datum.membid, 
          :order => "type_of_name, alias_name" )
      @family_affinities, @possible_affinities = find_affinity_cands( @family_datum )
      @family_documents = FamilyDocument.find_all_by_name( @show_name, 
          :order => "event_date, doc_descrip" )
  end  #  setup_for_show
  # -----------------------------

