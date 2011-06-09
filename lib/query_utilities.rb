# module for utilities related to generation of map/reduce queries and pre-filteres
module QueryUtilities
  
  # parse json string to an equivolent hash
  # this will strip the string and throw an exception if the string is not valid JSON
  def parse_json_to_hash(json)
    if (json.nil? or json.strip.length == 0) 
      return {}
    else 
      return ActiveSupport::JSON.decode json.strip
    end
  end
  
  # currently a no-op method.  If a format other than mongo query format is used for pre-filters, this method would do the appropriate conversion
  def convert_filter_to_mongo_query(filter) 
    filter
  end
end