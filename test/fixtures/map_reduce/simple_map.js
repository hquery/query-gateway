function map(patient) {
  emit(patient.gender(), 1);
};