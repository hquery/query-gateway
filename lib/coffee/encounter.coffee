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
  


