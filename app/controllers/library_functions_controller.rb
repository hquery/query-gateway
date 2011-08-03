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
    user_id=params[:user_id]
    composer_id=params[:composer_id]
    storePreparedFunctions(functions, composer_id, user_id)
    
    render text: "user functions added"
  end
  
private  
  
  def storePreparedFunctions(functions, composer_id, user_id)
    db = Mongoid::Config.master
    # need to add this if it is not there
    hquery = db['system.js'].find({_id: 'hquery_user_functions'});
    if (hquery.count == 1) 
      user_namespace = ''
      if (hquery.first['value']['f'+composer_id.to_s].nil?) 
        user_namespace += "hquery_user_functions['f#{composer_id}'] = {}; "
      end
    else
      user_namespace = "hquery_user_functions = {}; hquery_user_functions['f#{composer_id}'] = {}; "
    end
    user_namespace = user_namespace + "f#{user_id.to_s} = new function(){#{functions}}; "
    user_namespace = user_namespace + "hquery_user_functions['f#{composer_id}']['f#{user_id.to_s}'] = f#{user_id.to_s}; "
    db.eval(user_namespace)


    db.eval("db.system.js.save({_id:'hquery_user_functions', value : hquery_user_functions })")
  end
  
end
