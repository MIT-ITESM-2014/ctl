module MassInsertable
  
  extend ActiveSupport::Concern
  
  module ClassMethods
    
    def mass_insert(data, opts = {})
      errors = {}
      error_count = 0
      ActiveRecord::Base.transaction do
        unless data.blank? || !data.kind_of?(Hash)
          data.each_pair do |key, row|
            el = self.new(row)
            opts.each_pair do |name, val|
              p "#{name}=#{val}" # TODO remove comment
              el.send("#{name}=", val)
            end
            unless el.save
              error_count = error_count + 1
              errors[key] = el.errors
              p el.errors
            end
          end
        end
        p '==========='
        p "errors:#{errors}"
        p '==========='
        raise ActiveRecord::Rollback if error_count > 0
      end
      errors
    end
    
  end
  
  
end
