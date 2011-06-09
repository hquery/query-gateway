###*
Converts a a number in UTS Seconds since the epoch to a date.
@param {number} utcSeconds seconds since the epoch in UTC
@returns {Date}
###
dateFromUtcSeconds = (utcSeconds) ->
  new Date utcSeconds * 1000

###*
@class A code with its corresponding code system
###
class CodedValue
  ###*
  @param {String} code value of the code
  @param {String} codeSystemName name of the code system that the code belongs to
  @constructs
  ###
  constructor: (@code, @codeSystemName) ->

  ###*
  @returns {String} the code
  ###
  code: -> @code

  ###*
  @returns {String} the code system name
  ###
  codeSystemName: -> @codeSystemName

###*
@private
###
createCodedValues = (jsonCodes) ->
  codedValues = []
  for codeSystem, codes of jsonCodes
    for code in codes
      codedValues.push new CodedValue code, codeSystem
  codedValues

###*
An Encounter is an interaction, regardless of the setting, between a patient and a
practitioner who is vested with primary responsibility for diagnosing, evaluating,
or treating the patient’s condition. It may include visits, appointments, as well
as non face-to-face interactions. It is also a contact between a patient and a
practitioner who has primary responsibility for assessing and treating the
patient at a given contact, exercising independent judgment.
@class An Encounter is an interaction, regardless of the setting, between a patient and a
practitioner
###
class Encounter
  ###*
  @param {Object} A hash representing the encounter
  @constructs
  ###
  constructor: (@json) ->

  ###*
  Date and time at which the encounter took place
  @returns {Date}
  ###
  date: -> dateFromUtcSeconds: @json['time']

  ###*
  An Array of CodedValues which describe what kind of encounter took place
  @returns {Array}
  ###
  type: -> createCodedValues @json['codes']
  
  ###*
  A free text description of the type of encounter
  @returns {String}
  ###
  freeTextType: -> @json['description']

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
    