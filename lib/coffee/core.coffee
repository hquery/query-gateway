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
@class Address
###
class Address
  constructor: (@json) ->
  ###*
  @returns {String} the street address
  ###   
  streetAddress: -> @json['streetAddress']
  ###*
  @returns {String} the city
  ###
  city: -> @json['city']
  ###*
  @returns {String} the State or province
  ###
  stateOrProvince: -> @json['stateOrProvince']
  ###*
  @returns {String} the zip code
  ###
  zip: -> @json['zip']
  ###*
  @returns {String} the country
  ###
  country: -> @json['country']


###*
@class Telecom
###
class Telecom
  constructor: (@json) ->
  ###*
  @returns {String} the type of telecom entry
  ###  
  type: -> @json['type']
  ###*
  @returns {String} the value of the entry
  ###  
  value: -> @json['value']
  ###*
  @returns {String} the use of the entry
  ###  
  use: -> @json['use']
  ###*
  @returns {Boolean} is this a preferred form of contact
  ###  
  preferred: -> @json['preferred']


###*
@class Person
###
class Person
  constructor: (@json) ->
  ###*
   @returns {String} the given name of the person
  ###  
  given: -> @json['given']
  ###*
   @returns {String} the last/family name of the person
   ###
  last: -> @json['last']
  ###*
   @returns {Array} an array of {@link Address} objects associated with the person
   ###
  addresses: ->
    for address in @json['addresses']
      new Address address
  ###*
  @returns {Array} an array of {@link Telecom} objects associated with the person
  ###
  telecoms: ->
    for tel in @json['telecoms']
      new Telecom tel


###*
@class Actor
###
class Actor
  constructor: (@json) ->

###*
@class Organization
###
class Organization
  constructor: (@json) ->

###*
@private
###
createCodedValues = (jsonCodes) ->
  codedValues = []
  for codeSystem, codes of jsonCodes
    for code in codes
      codedValues.push new CodedValue code, codeSystem
  codedValues
