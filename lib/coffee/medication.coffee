###*
@class MedicationInformation
###

###*
@class Dose - a medications dose information  , unit and value
###
class Dose
  constructor: (@json) ->
  unit: -> @json['unit']
  value: -> @json['value']
  
  
###*
@class DoseRestriction -  restrictions on the medications dose, represented by a upper and lower dose
###
class DoseRestriction
  constructor: (@json) ->
  numerator: -> new Dose @json['numerator']
  denominator: -> new Dose @json['denominator']
  

###*
@class FulFillment -  Thie information about when and who fulfilled an order for the medication
###
class FulFillment
 constructor: (@json) ->

 dispenseDate: -> dateFromUtcSeconds @json['dispenseDate']

 provider:-> new Actor @json['provider']

 quantity: -> new Dose @json['quantity']

 prescriptionNumber: -> @json['prescriptionNumber']

 repeatNumber: -> @json['repeatNumber']



###*
This class represents a medication entry for a patient.  
@class 
### 
class Medication 
  ###*
  @param {Object} A hash representing the Medication
  @constructs
  ###
  constructor: (@json) ->
  ###*
  @returns {CodedValue} how is the medication administered into the patient, injeection, pills, ....
  ###
  route: -> new CodedValue @json['route'].codeSystem, @json['route'].code 
  ###*
  @returns {Dose} the dose 
  ###
  dose: -> new Dose @json['dose']
  ###*
  @returns {CodedValue}
  ###
  site: -> new CodedValue @json['site'].codeSystem, @json['site'].code 

  doseRestriction: -> new DoseRestriction @json['doseRestriction']
  ###*
  @returns {CodedValue}
  ###
  productForm: -> new CodedValue @json['productForm'].codeSystem, @json['productForm'].code 
  ###*
  @returns {CodedValue}
  ###
  deliveryMethod: -> new CodedValue @json['deliveryMethod'].codeSystem, @json['deliveryMethod'].code 

  medicationInformation: -> @json['medicationInformation']
  ###*
  @returns {CodedValue}
  ###
  medicationType: -> new CodedValue @json['medicationType'].codeSystem, @json['medicationType'].code 
  ###*
  @returns {CodedValue}
  ###
  statusOfMedication: -> new CodedValue @json['statusOfMedication'].codeSystem, @json['statusOfMedication'].code 
  ###*
  @returns {String} free text instructions to the patient
  ###
  patientInstructions: -> @json['patientInstructions']
  ###*
  @returns {Person,Organization} either a patient or organization object for who provided the medication prescription
  ###
  provider: -> new Actor @json['provider']
  ###*
  @return {String} free text narrative
  ###
  narrative: -> @json['narrative']
  ###*
  @returns {Array} an array of {@link FulFillment} objects 
  ###
  fulfillmentHistory: -> 
    for order in @json['fulfillmentHistory']
      new FulFillment order
