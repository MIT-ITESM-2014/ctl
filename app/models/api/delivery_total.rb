class Api::DeliveryTotal < DeliveryTotal
  
  module Json
    Default = {}
    Chart = {
      only: [:total_sun, :total_mon, :total_tue, :total_wed, :total_thu, :total_fri, :total_sat],
      methods: [:hour_i]
    }
  end
  
  module Stats
    WorkStart = 7
    WorkEnd = 15
    IntensityRange = ((WorkStart)..(WorkEnd))
    PeakWorkStart = 9
    PeakWorkEnd = 12
    WorkDays = [:total_mon, :total_tue, :total_wed, :total_thu, :total_fri]
    WorkRange = ((PeakWorkStart)..(PeakWorkEnd))
  end
  
  scope :api_chart_base, ->{ select('delivery_totals.km_id, delivery_totals.hour, delivery_totals.total_sun, delivery_totals.total_mon, delivery_totals.total_tue, delivery_totals.total_wed, delivery_totals.total_thu, delivery_totals.total_fri, delivery_totals.total_sat').ascending }
  scope :api_stats_by_km, ->(km_id){ select('delivery_totals.hour, delivery_totals.total_mon, delivery_totals.total_tue, delivery_totals.total_wed, delivery_totals.total_thu, delivery_totals.total_fri').filter_by_km(km_id) }
  scope :api_stats_by_km_by_hour, ->(km_id){ api_stats_by_km(km_id).ascending }
  
  def self.json_display
    @@json_display ||= Json::Default
  end
  
  def self.json_display=(val)
    @@json_display = val
  end
  
  def as_json(opts = {})
    super(opts.merge(self.class.json_display))
  end
  
  def self.delivery_intensity(kms)
    result = { data: [],  kms: kms }
    i, j = 0, 0
    kms.each do |km|
      #start_time = km.chart_start_time.to_i
      #end_time = km.chart_end_time.to_i
      j = 0
      self.api_stats_by_km_by_hour(km.id).each do |delivery_row|
        hour_sum = 0
        hour_val = delivery_row.hour.advance(seconds: km.utc_offset).hour
        if(Stats::WorkRange.include?(hour_val))
          Stats::WorkDays.each do |day|
           hour_sum += delivery_row.send(day)
          end
          result[:data] << [j, i, hour_sum]
          j += 1
        end
      end
      i += 1
    end
    Api::Km.json_display = Api::Km::Json::Obstruction
    result
  end
  
  def self.peak_period_average(kms)
    result = { hour: [], peak: [], average: [], kms: kms }
    hour_total = 0
    kms.each do |km|
      hour = 0
      peak = 0
      delivery_totals = self.api_stats_by_km(km.id)
      delivery_totals.each do |delivery|
        hour_val = delivery.hour.advance(seconds: km.utc_offset).hour #localtime
        Stats::WorkDays.each do |day|
          value = delivery.send(day).to_i
          hour += value
          if Stats::WorkRange.include?(hour_val)
            peak += value
          end
        end
      end
      result[:hour] << hour
      result[:peak] << peak
      hour_total += hour
    end
    average = hour_total / kms.length
    kms.each do |km|
      result[:average] << average
    end
    Api::Km.json_display = Api::Km::Json::Obstruction
    result
  end
  
end
