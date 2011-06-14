require 'query_executor'

namespace :doc do
  task :generate_js do
    api = QueryExecutor.patient_api_javascript
    
    Dir.mkdir(Rails.root + 'tmp') unless Dir.exists?(Rails.root + 'tmp')
    
    File.open(Rails.root + 'tmp/patient.js', 'w+') do |js_file|
      js_file.write api
    end
  end
  
  task :js => :generate_js do
    system 'java -jar ./doc/jsdoc-toolkit/jsrun.jar ./doc/jsdoc-toolkit/app/run.js -t=doc/jsdoc-toolkit/templates/jsdoc -a tmp/patient.js -d=doc/patient-api'
  end
end
