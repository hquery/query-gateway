#require 'cover_me'
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'
require 'mocha'

Factory.find_definitions


class ActiveSupport::TestCase
  setup { load "#{Rails.root}/db/seeds.rb" }
end

class ImporterApiTest < ActiveSupport::TestCase
  def setup    
    doc = Nokogiri::XML(File.new('test/fixtures/NISTExampleC32.xml'))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    pi = HealthDataStandards::Import::C32::PatientImporter.instance
    patient = pi.parse_c32(doc)
    patient.save!
    patient_json = Mongoid.master['records'].find_one(patient.id).to_json
    patient_api = QueryUtilities.patient_api_javascript.to_s
    initialize_patient = 'var patient = new hQuery.Patient(barry);'
    date = Time.new(2010,1,1)
    initialize_date = "var sampleDate = new Date(#{date.to_i*1000});"
    @context = ExecJS.compile(patient_api + "\nvar barry = " + patient_json + ";\n" + initialize_patient + "\n" + initialize_date)
  end
end

def dump_database
  db = Mongoid.master

  db.collection('job_logs').remove({}) if db['job_log_events']
  db.collection('results').remove({}) if db['results']
  db.collection('queries').remove({}) if db['queries']
  db.collection('pmn_requests').remove({}) if db['pmn_requests']
end

def dump_jobs
  Delayed::Job.destroy_all
end

def create_query
  mf = File.read('test/fixtures/map_reduce/simple_map.js')
  rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
  Query.create(format: 'js', map: mf, reduce: rf)
end

def create_job_params
  map = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/map_reduce/simple_map.js'), 'application/javascript')
  reduce = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/map_reduce/simple_reduce.js'), 'application/javascript')
  functions = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/library_function/simple_function.js'), 'application/javascript')
  {format: 'js', map: map, reduce: reduce, functions: functions}
end


