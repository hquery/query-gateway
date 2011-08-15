function map(patient) {
  var gender = _.isNull(patient.gender()) ? 'M' : patient.gender();
  emit(gender, 1);
};
