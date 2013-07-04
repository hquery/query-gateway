require 'readline'

class PatientConsole

  def self.run

    init

    val = ''
    while (val != 'exit')
      begin
        
        linein = Readline.readline( "patient > ", true )
        
        line = linein.chomp unless linein.nil?

        if linein.nil? || line == 'exit' ## Checks for CTRL-D and exits if it is caught
          puts
          val = 'exit'
        elsif line.empty? ## Checks to see if the user just hit RETURN and skips to the next loop
          next
        else
          parts = line.split(' ')
          if (parts[0] == 'load_patient')
            if (parts.length < 2) 
              puts "need to specify index"
              next
            elsif (parts[1].to_i >= @@patients.length)
              puts "index exceeds loaded patient count"
            end
            load_patient parts[1].to_i
          elsif (parts[0] == 'help' || parts[0] == '?')
            puts "the first patient has been bound to the 'patient' javascript object
            type 'patient' or patient.given() to explore data
            by default all patients are loaded, use find patients to load a different set of patients
            use load_patient to redefine the patient object
            COMMANDS
              help - this message
              load_patient <index> - loads a patient into the patient object by index from loaded list
              find_patients <query> - loads patients list. eg: find_patients {\"first\":\"Angela\"} or find_patients {} 
              patients - number of loaded patients "
              
          elsif (parts[0] == 'patients')
            puts @@patients.length
          elsif (parts[0] == 'find_patients')
            if (parts.length < 2) 
              puts "need to specify a query"
              next
            end
            query = JSON.parse(parts[1..parts.length].join(' '))
            #db = Mongoid.master
            db = Mongoid.default_session
            
            @@patients = []
            
            db['records'].find(query).each {|p| @@patients << p}
            load_patient 0
            puts @@patients.length.to_s + " loaded"
          else
          
            val = linein.chomp
            retval = @@context.eval(val)
            puts retval
          
          end


        end
        
      rescue Exception => ex
        puts ex.to_s
      end
    end
  end
  
  def self.load_patient(index)
    fixture_json = "thatguy = " + @@patients[index].to_json
    initialize_patient = 'patient = new hQuery.Patient(thatguy)'
    @@context.eval(fixture_json) 
    @@context.eval(initialize_patient)
  end

  def self.init
    @@patient_index = 0
    #db = Mongoid.master
    db = Mongoid.default_session
    patient_api = QueryExecutor.patient_api_javascript.to_s
    @@patients = []
    db['records'].find().each {|p| @@patients << p}
    fixture_json = "var thatguy = " + @@patients[0].to_json
    initialize_patient = 'var patient = new hQuery.Patient(thatguy);'
    date = Time.new(2010,1,1)
    initialize_date = "var sampleDate = new Date(#{date.to_i*1000});"
    @@context = ExecJS.compile(patient_api + "\n" + fixture_json + "\n" + initialize_patient + "\n" + initialize_date)

  end

end