// Reference Number: PDC-022
// Query Title: Fasting blood sugar in last 3 yrs age > 45
// TODO: Add freetext definition search
function map(patient) {
    var targetLabCodes = {
        "pCLOCD": ["14771-0"]
    };

    var ageLimit = 45;
    var resultList = patient.results();

    var now = new Date(2013, 10, 30);
    var start = addDate(now, -3, 0, 0);
    var end = addDate(now, 0, 0, 0);

    // Shifts date by year, month, and date specified
    function addDate(date, y, m, d) {
        var n = new Date(date);
        n.setFullYear(date.getFullYear() + (y || 0));
        n.setMonth(date.getMonth() + (m || 0));
        n.setDate(date.getDate() + (d || 0));
        return n;
    }

    // Checks if patient is older than ageLimit
    function population(patient) {
        return (patient.age(now) > ageLimit);
    }

    // Checks for Fasting Blood Sugar labs performed within the last 3 years
    function hasLabCode() {
        return resultList.match(targetLabCodes, start, end).length;
    }

    if (population(patient)) {
        emit("denominator_patients_>45", 1);
        if (hasLabCode()) {
            emit("numerator_has_blood_sugar_result", 1);
        }
    }

    // Empty Case
    emit("numerator_has_blood_sugar_result", 0);
    emit("denominator_patients_>45", 0);
}
