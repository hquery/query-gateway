// Reference Number: PDC-027
// Query Title: Diabetics with LDL in last yr <= 2.5
// TODO: Add freetext definition search
function map(patient) {
    var targetLabCodes = {
        "pCLOCD": ["39469-2"]
    };

    var targetProblemCodes = {
        "ICD9": ["250*"]
    };

    var ldlLimit = 2.5;

    var resultList = patient.results();
    var problemList = patient.conditions();

    var now = new Date(2013, 10, 30);
    var start = addDate(now, -1, 0, 0);
    var end = addDate(now, 0, 0, 0);

    // Shifts date by year, month, and date specified
    function addDate(date, y, m, d) {
        var n = new Date(date);
        n.setFullYear(date.getFullYear() + (y || 0));
        n.setMonth(date.getMonth() + (m || 0));
        n.setDate(date.getDate() + (d || 0));
        return n;
    }

    // Checks for ldl labs performed within the last year
    function hasLabCode() {
        return resultList.match(targetLabCodes, start, end).length;
    }

    // Checks for diabetic patients
    function hasProblemCode() {
        return problemList.regex_match(targetProblemCodes).length;
    }

    // Checks if ldl meets parameters
    function hasMatchingLabValue() {
        for (var i = 0; i < resultList.length; i++) {
            if (resultList[i].includesCodeFrom(targetLabCodes) && resultList[i].timeStamp() > start) {
                if (resultList[i].values()[0].units() !== null &&
                    resultList[i].values()[0].units().toLowerCase() === "mmol/L".toLowerCase()) {
                    if (resultList[i].values()[0].scalar() <= ldlLimit) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    if (hasProblemCode()) {
        emit("denominator_diabetics", 1);
        if(hasLabCode()) {
            emit("has_ldl_result", 1);
            if(hasMatchingLabValue()) {
                emit("numerator_has_matching_ldl_value", 1);
            }
        }
    }

    // Empty Case
    emit("numerator_has_matching_ldl_value", 0);
    emit("denominator_diabetics", 0);
}
