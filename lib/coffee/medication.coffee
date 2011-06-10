###*
@class MedicationInformation
###

###*
@class Dose
###
class Dose
  constructor: (@json) ->

  unit: -> @json['unit']
  value: -> @json['value']
  
  
###*
@class DoseRestriction
###
class DoseRestriction
  constructor: (@json) ->

  numerator: -> new Dose @json['numerator']
  
  denominator: -> new Dose @json['denominator']
  
  

  

###*
@class FulFillment
###
class FulFillment
 constructor: (@json) ->

 dispenseDate: -> dateFromUtcSeconds @json['dispenseDate']

 provider:-> new Actor @json['provider']

 quantity: -> new Dose @json['quantity']

 prescriptionNumber: -> @json['prescriptionNumber']

 repeatNumber: -> @json['repeatNumber']



###*
@class Medication
### 
class Medication 
  ###*
  @param {Object} A hash representing the Medication
  @constructs
  ###
  constructor: (@json) ->

  route: -> new CodedValue @json['route'].codeSystem, @json['route'].code 

  dose: -> new Dose @json['dose']

  site: -> new CodedValue @json['site'].codeSystem, @json['site'].code 

  doseRestriction: -> new DoseRestriction @json['doseRestriction']

  productForm: -> new CodedValue @json['productForm'].codeSystem, @json['productForm'].code 

  deliveryMethod: -> new CodedValue @json['deliveryMethod'].codeSystem, @json['deliveryMethod'].code 

  medicationInformation: -> @json['medicationInformation']

  medicationType: -> new CodedValue @json['medicationType'].codeSystem, @json['medicationType'].code 

  statusOfMedication: -> new CodedValue @json['statusOfMedication'].codeSystem, @json['statusOfMedication'].code 

  patientInstructions: -> @json['patientInstructions']

  provider: -> new Actor @json['provider']

  narrative: -> @json['narrative']

  fulfillmentHistory: -> 
    for order in @json['fulfillmentHistory']
      new FulFillment order
