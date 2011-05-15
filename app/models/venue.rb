class Venue < ActiveRecord::Base
  has_many :events
  
  default_scope :order => 'name ASC' #sets default search order
  
  validates_presence_of :name, :area, :compass

  UNKNOWN_AREA = "Unknown Area"
  UNKNOWN_COMPASS = "?"
  
  def compass_text
    title = case compass
      when "C" then "Central Montréal" 
      when "N" then "North Montréal"
      when "S" then "South Montréal"
      when "E" then "East Montréal"
      when "W" then "West Montréal"
      when "NE" then "North East Montréal"
      when "NW" then "North West Montréal"
      when "SE" then "South East Montréal"
      when "SW" then "South West Montréal"
    else 
      UNKNOWN_AREA
    end  
    return title
  end
  
  def compass
    return UNKNOWN_COMPASS if self[:compass].nil? || self[:compass].empty?
      
    self[:compass]
  end
  
  def name_and_area
    name + ' - ' + area
  end 
  
  # Are there any active events associated with this venue?
  def all_events_out_of_date?
    events.each do |event|
      # not out of date means there is at least one event which has current dates...
      return false if !event.out_of_date
    end
    
    return true
  end
  
  def all_events_nearly_out_of_date?
    events.each do |event|
      return false if !event.near_out_of_date
    end
    
    return true
  end
  
end
