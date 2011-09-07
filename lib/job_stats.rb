class JobStats

   MAP = %{
   function () {
     var timeToCompleteJob = null;
     if(this.job_logs && this.job_logs.length > 1) {
       timeToCompleteJob = this.job_logs[this.job_logs.length - 1].created_at - this.job_logs[0].created_at;
     }
     emit(this.status, {count: 1, avg: timeToCompleteJob});
   }
  }

  REDUCE = %{
    function reduce(k,v){
      if(k == "complete"){
        var t = 0;
        var count = 0;
        for(var i=0; i< v.length; i++){
          t += v[i].avg;
          count += v[i].count;
        }
        var avg = (count>0) ? t/count : 0;
        return {count: count, avg: avg};
      }
      return v.length;
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
    result = Query.collection().map_reduce(MAP, REDUCE, {out: {inline: 1}, raw: true})
    result["results"].each do |res|
      type = res["_id"]
      val = res["value"]

      if(type == "complete")
        s[type] = val["count"]
        s["avg_runtime"] = val["avg"]
      else
        s[type] = val
      end
    end
    return s
  end

end





