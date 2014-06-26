// Reference Number: PDC-025
// Query Title: Diabetics with HGBA1C in last 6 mo
// TODO: Add freetext definition search
function map(patient) {
    var targetLabCodes = {
        "pCLOCD": ["4548-4"]
    };

    var targetProblemCodes = {
        "ICD9": ["250*"]
    };

    var resultList = patient.results();
    var problemList = patient.conditions();

    var now = new Date(2013, 10, 30);
    var start = addDate(now, 0, -6, 0);
    var end = addDate(now, 0, 0, 0);

    // Shifts date by year, month, and date specified
    function addDate(date, y, m, d) {
        var n = new Date(date);
        n.setFullYear(date.getFullYear() + (y || 0));
        n.setMonth(date.getMonth() + (m || 0));
        n.setDate(date.getDate() + (d || 0));
        return n;
    }

    // Checks for HGBA1C labs performed within the last 6 months
    function hasLabCode() {
        return resultList.match(targetLabCodes, start, end).length;
    }

    // Checks for diabetic patients
    function hasProblemCode() {
        return problemList.regex_match(targetProblemCodes).length;
    }

    if (hasProblemCode()) {
        emit("denominator_diabetics", 1);
        if(hasLabCode()) {
            emit("numerator_has_hgba1c_result", 1);
        }
    }

    // Empty Case
    emit("numerator_has_hgba1c_result", 0);
    emit("denominator_diabetics", 0);
}
