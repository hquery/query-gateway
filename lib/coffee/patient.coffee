###*
@class Representation of a patient
###
class Patient
  ###*
  @constructs
  ###
  constructor: (@json) ->

  ###*
  @returns {String} containing M or F representing the gender of the patient
  ###
  gender: -> @json['gender']

  ###*
  @returns {String} containing the patient's given name
  ###
  given: -> @json['first']
  family: -> @json['last']

  ###*
  @returns {Date} containing the patient's birthdate
  ###
  birthtime: ->
    dateFromUtcSeconds @json['birthdate']

  ###*
  @returns {Array} A list of {@link Encounter} objects
  ###
  encounters: ->
    for encounter in @json['encounters']
      new Encounter encounter
    
  ###*
  @returns {Array} A list of {@link Medication} objects
  ###
  medications: ->
    for medication in @json['medications']
      new Medication medication
      
      
  ###*
  @returns {Array} A list of {@link Condition} objects
  ###
  conditions: ->
    for condition in @json['conditions']
      new Condition condition