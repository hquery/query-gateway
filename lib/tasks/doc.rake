namespace :doc do
  task :generate_js do
    patient_coffee = File.read(Rails.root + 'lib/patient.coffee')
    patient_api = CoffeeScript.compile(patient_coffee, bare: true)
    File.open(Rails.root + 'tmp/patient.js', 'w+') do |js_file|
      js_file.write patient_api
    end
  end
  
end
