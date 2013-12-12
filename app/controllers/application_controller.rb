class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # +++++++++++++++++++++++++++++
  # prep_nav_values
  #
  # Written 06/27/2012 A. D. Roth
  # Rev. 06/28/2012 to parameterize max_rows
  # Rev. 07/17/2012 to correct typo
  # Rev. 12/09/2013 to revise case statement for Ruby 2.0.0
  # +++++++++++++++++++++++++++++
  def prep_nav_values( params, max_rows = 15 )
    @offset = (params[:curr_offset] ? params[:curr_offset].to_i : 0 )
    @max_rows = (params[:max_rows] ? params[:max_rows].to_i : max_rows )
    case params[:next_offset]
    when 'First'
      @offset = 0
    when 'Prev'
      @offset = [ @offset - @max_rows, 0 ].max
    when 'Next'
      @offset += ( @offset + @max_rows < @table_count ? @max_rows : 0 )
    when 'Last'
      @offset = @table_count - (@max_rows/2).to_i 
    end # case params[:next_offset]
  end  # prep_nav_values
end  #  ApplicationController
