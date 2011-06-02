dateFromUtcSeconds = (utcSeconds) ->
  new Date utcSeconds * 1000

class CodedValue
  constructor: (@code, @codeSystemName) ->
  code: -> @code
  codeSystemName: -> @codeSystemName

createCodedValues = (jsonCodes) ->
  codedValues = []
  for codeSystem, codes of jsonCodes
    for code in codes
      codedValues.push new CodedValue code, codeSystem
  codedValues

class Encounter
  constructor: (@json) ->
  date: -> dateFromUtcSeconds: @json['time']
  type: -> createCodedValues @json['codes']
  freeTextType: -> @json['description']

class Patient
  constructor: (@json) ->
  gender: -> @json['gender']
  given: -> @json['first']
  family: -> @json['last']

  birthtime: ->
    dateFromUtcSeconds @json['birthdate']

  encounters: ->
    for encounter in @json['encounters']
      new Encounter encounter
    