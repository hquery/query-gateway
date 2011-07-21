class LibraryFunctionsController < ApplicationController
  
# =================================================================
# = creates a user function that is stored in the system.js table =
# =
# = TODO: aq - NEED TO AUTHORIZE USERNAME FROM QUERY COMPOSER IS VALID
# = TODO: aq - MAY NEED TO CLEAN ANY POTENTIALLY HOSTILE CODE
# =
# =================================================================
  def create
    functions=params[:functions].read
    username=params[:username]
    
    storePreparedFunctions(functions, username)
    
    render text: "user functions added"
  end
  
private  
  
  def storePreparedFunctions(functions, username)
    db = Mongoid::Config.master
    #user_namespace = "#{username} = #{username} || {};"
    user_namespace = "#{username} = {};"
    db.eval(user_namespace)
    db.eval(functions)
    db.eval("db.system.js.save({_id:'"+username+"', value : "+username+" })")
  end
  
end
