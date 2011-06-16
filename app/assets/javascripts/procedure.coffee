# =require core.coffee
###*
This represents all interventional, surgical, diagnostic, or therapeutic procedures or 
treatments pertinent to the patient.
@class
@augments CodedEntry
###
class Procedure extends CodedEntry
  
  ###*
  @returns {Person} The entity that performed the procedure
  ###
  performer: -> new Actor @json['performer']