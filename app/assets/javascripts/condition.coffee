# =require core.coffee
###*
@class Provider
###
class Provider
  constructor: (@json) ->
  effectiveDate: -> new DateRange @json['effectiveDate'] 
  actor: -> new Actor @json['actor'] 
  informant: -> new Informant @json['informant'] 
  narrative: -> @json['narrative']

###*
@class Condition
###  
class Condition
###*
@param {Object} A hash representing the Condition
@constructs
###
constructor: (@json) ->
  type: -> new CodedValue @json['problemType'].codeSystem, @json['problemType'].code 
  name: -> @json['problemName']
  date: -> new DateRange(@json['problemDate'])
  code: ->  new CodedValue @json['problemCode'].codeSystem, @json['problemCode'].code 
  providers: ->    
    for  provider in @json['treatingProviders'] 
       new Provider provider 