namespace :doc do
  task :generate_js do
    patient_coffee = File.read(Rails.root + 'lib/patient.coffee')
    patient_api = CoffeeScript.compile(patient_coffee, bare: true)
    File.open(Rails.root + 'tmp/patient.js', 'w+') do |js_file|
      js_file.write patient_api
    end
  end
  
  task :js => :generate_js do
    system 'java -jar ./doc/jsdoc-toolkit/jsrun.jar ./doc/jsdoc-toolkit/app/run.js -t=doc/jsdoc-toolkit/templates/jsdoc -a tmp/patient.js -d=doc/patient-api'
  end
end
