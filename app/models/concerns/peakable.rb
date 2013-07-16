module Peakable
  
  extend ActiveSupport::Concern
  
  module ClassMethods
    
    def min_hour_for_km(km_id)
      field = "MIN(#{self.table_peak_field}) as val"
      self.hour_for_km(km_id, field)
    end
    
    def max_hour_for_km(km_id)
      field = "MAX(#{self.table_peak_field}) as val"
      self.hour_for_km(km_id, field)
    end
    
    # TODO optimize for generic DBMS
    def peak_for_hour(hour, km_id, base=nil)
      starts = "TIME '#{hour}:00:00'"
      ends = "TIME '#{hour}:59:59'"
      self.peak_between(starts, ends, km_id, base)
    end
    
    def filter_between(starts, ends, km_id, timezone=nil)
      field = self.table_peak_field(timezone)
      self.filter_by_km(km_id).where("#{field} >= #{starts} AND #{field} <= #{ends}").order(nil)
    end
    
    def peak_between(starts, ends, km_id, base=nil, timezone=nil)
      base = self.base_count if base.nil?
      base.filter_between(starts, ends, km_id, timezone).first[:num].to_i
    end
    
    protected
    
    def hour_for_km(km_id, field)
      data = self.select("#{field}").filter_by_km(km_id).order(nil).first
      data[:val] unless data.nil?
    end
    
    def table_peak_field(timezone = nil)
      base = "(#{self.table_name}.#{self.peak_field}::time"
      base << " + INTERVAL '#{timezone.now.utc_offset} seconds'" unless timezone.nil?
      base << ")"
      base
    end
    
    def peak_field
      raise NotImplementedError
    end
    
  end
  
  
end