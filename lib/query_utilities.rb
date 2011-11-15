# module for utilities related to generation of map/reduce queries
module QueryUtilities
  require 'sprockets'
  require 'tilt'
  
  def self.stringify_key(key)
    if (key.is_a? BSON::OrderedHash)
      key = (key.map {|val| stringify_key(val)}).join('_')
    end
    if (key.is_a? Array)
      key = (key.map {|val| stringify_key(val)}).join('_')
    end
    key.to_s
  end
  
  def self.patient_api_javascript
    Tilt::CoffeeScriptTemplate.default_bare=true
    Rails.application.assets.find_asset("patient")
  end
  
  
end
