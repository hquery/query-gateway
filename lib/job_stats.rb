class JobStats
  
  # Reduce counts the number of items if key is != success,  if successful need to count the number of entries and 
  # calculate the average time that it takes for a job to run.
   REDUCE = %{
   function reduce(k,v){                                                                                           
     if(k == "success"){
       var t = 0;
       var count = 0;
       for(var i=0; i< v.length; i++){
         var val = v[i];
         if(!val.messages){
           continue;
         }
         if(val.messages.length > 1){
           var time = val.messages[val.messages.length-1].time - val.messages[0].time;
           if(!isNaN(time) &&  time != Infinity){
              t += time;
              count++;
           }

         }
       } 
       var avg = (count>0) ? t/count : 0;
       return {count: v.length, avg:avg,  v:v};
       }
     return v.length;
   }
  }
   
  # the finalize function is here to deal with the corner case of there only being 1  entry for a 
  # key.  This would bypass the reduce phase so we capture it here.
  FINALIZE = %{  
    function(k,v){
     if(k == "success"){
       if(v["count"] == null){
         return {count:1, avg:v.messages[v.messages.length-1].time - v.messages[0].time};
       }else{
         return v;
       }
     } 
     else if(!isNumber(v)){
       return 1;
     }else{
       return v;
     }
   }
 }

    
  def self.stats
    # check to see if we have a working connection to mongo
    begin
      Mongoid.master.stats
    rescue
      return {error: "Backend Down"}
    end

    s = {backend_status: :good}
    result =  JobLog.collection().map_reduce("function(){emit(this.status, this);}", REDUCE,{finalize:FINALIZE, out:{inline:1}, raw: true})
    result["results"].each do |res| 
      type = res["_id"]
      val = res["value"]
    
      if(type == "success")
        s[type] = val["count"]
        s["avg_runtime"] = val["avg"]
      else
        s[type] = val
      end
    end
    return s
  end
  
end





