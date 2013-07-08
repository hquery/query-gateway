require 'cover_me'
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'
require 'mocha/setup'

FactoryGirl.find_definitions


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
    db = Mongoid.default_session
    #patient_json = Mongoid.master['records'].find_one(patient.id).to_json
    patient_json = db['records'].find(_id: patient.id).first.to_json
    patient_api = QueryUtilities.patient_api_javascript.to_s
    initialize_patient = 'var patient = new hQuery.Patient(barry);'
    date = Time.new(2010,1,1)
    initialize_date = "var sampleDate = new Date(#{date.to_i*1000});"
    @context = ExecJS.compile(patient_api + "\nvar barry = " + patient_json + ";\n" + initialize_patient + "\n" + initialize_date)
  end
end

def dump_database
  #db = Mongoid.master
  db = Mongoid.default_session

  #db.collection('job_logs').remove({}) if db['job_log_events']
  #db.collection('results').remove({}) if db['results']
  #db.collection('queries').remove({}) if db['queries']
  #db.collection('pmn_requests').remove({}) if db['pmn_requests']
  db['job_logs'].drop if db['job_log_events']
  db['results'].drop if db['results']
  db['queries'].drop if db['queries']
  db['pmn_requests'].drop if db['pmn_requests']
end

def load_scoop_database
  # Deletes any existing records and loads in scoop records
  #`mongoimport -d #{Mongoid.master.name} -h #{Mongoid.master.connection.host_to_try[0]} --drop -c records test/fixtures/scoop-records.json`

  #puts "#{Mongoid.default_session.inspect}"
  `mongoimport -d #{Mongoid.default_session.options[:database]} --drop -c records test/fixtures/scoop-records.json`
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
  map = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/map_reduce/simple_map.js'), 'application/hqmf+xml')
  reduce = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/map_reduce/simple_reduce.js'), 'application/javascript')
  functions = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/library_function/simple_function.js'), 'application/javascript')
  filter = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/filter/all.json'), 'application/json')
  {format: 'js', map: map, reduce: reduce, functions: functions, filter: filter}
end

def create_hqmf_job_params
  hqmf = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'fixtures', 'NQF59New.xml'), 'application/xml')
  {format: 'hqmf', hqmf: hqmf}
end

def create_hqmf_upload
  hqmf = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'fixtures', 'NQF59New.xml'), 'application/xml')
  # patch Uploaded file - for some reason the tempfile property isn't available like
  # it is for a real file upload
  class << hqmf
    attr_reader :tempfile
  end
  {query: {hqmf: hqmf}}
end

