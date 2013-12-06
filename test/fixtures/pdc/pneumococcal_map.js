// Reference Number: PDC-014
// Query Title: Pneumococcal vaccination age 65+
// TODO: Add freetext definition search
function map(patient) {
    var targetImmunizationCodes = {
        "whoATC": ["J07AL02"],
        "SNOMED-CT": ["12866006", "394678003"]
    };

    var ageLimit = 64;
    var immunizationList = patient.immunizations();

    var now = new Date(2013, 10, 30);

    // Checks if patient is older than ageLimit
    function population(patient) {
        return (patient.age(now) > ageLimit);
    }

    // Checks for existence of Pneumovax
    function hasImmunization() {
        return immunizationList.match(targetImmunizationCodes).length;
    }

    if (hasImmunization()) {
        emit("total_pneumovax", 1);
    }

    if (population(patient)) {
        emit("denominator_patients_>64", 1);
        if (hasImmunization()) {
            emit("numerator_senior_pop_pneumovax", 1);
        }
    }

    // Empty Case
    emit("numerator_senior_pop_pneumovax", 0);
    emit("denominator_patients_>64", 0);
}
