// Reference Number: PDC-028
// Query Title: Diabetes & BP <= 130/80 in last yr

function map(patient) {

    var targetBloodPressureSystolicCodes = {
        "LOINC": ["8480-6"]
    };

    var targetBloodPressureDiastolicCodes = {
        "LOINC": ["8462-4"]
    };

    var targetProblemCodes = {
        "ICD9": ["250*"]
    };

    var bpSystolicLimit = 130;
    var bpDiastolicLimit = 80;

    var problemList = patient.conditions();
    var vitalSignList = patient.vitalSigns();

    var now = new Date(2013, 10, 30);
    var start = addDate(now, -1, 0, 0);  // last 12 months
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
    function population() {
        return true;
    }

    // Checks for existence of systolic blood pressure observation
    function hasSystolicBloodPressure() {
        return vitalSignList.match(targetBloodPressureSystolicCodes, start, end).length;
    }

    // Checks for existence of diastolic blood pressure observation
    function hasDiastolicBloodPressure() {
        return vitalSignList.match(targetBloodPressureDiastolicCodes, start, end).length;
    }

    function hasBloodPressure() {
        return hasSystolicBloodPressure() && hasDiastolicBloodPressure();
    }

    // Checks for diabetic patients
    function hasProblemCode() {
        return problemList.regex_match(targetProblemCodes).length;
    }

    // Checks for Blood Pressure value matching conditions
    // Systolic and diastolic records do not need to be sequential to return true
    function hasBloodPressureMatchingIndicators() {
        var bpSystolic = Number.MAX_VALUE;
        var bpDiastolic = Number.MAX_VALUE;
        for (var i = 0; i < vitalSignList.length; i++) {
            if (vitalSignList[i].includesCodeFrom(targetBloodPressureSystolicCodes) &&
                vitalSignList[i].timeStamp() > start) {
                if (vitalSignList[i].values()[0].units() !== null &&
                    vitalSignList[i].values()[0].units().toLowerCase() === "mm[Hg]".toLowerCase()) {
                    if(vitalSignList[i].values()[0].scalar() < bpSystolic) {
                        bpSystolic = vitalSignList[i].values()[0].scalar();
                    }
                }
            } else if (vitalSignList[i].includesCodeFrom(targetBloodPressureDiastolicCodes) &&
                       vitalSignList[i].timeStamp() > start) {
                if (vitalSignList[i].values()[0].units() !== null &&
                    vitalSignList[i].values()[0].units().toLowerCase() === "mm[Hg]".toLowerCase()) {
                    if(vitalSignList[i].values()[0].scalar() < bpDiastolic) {
                        bpDiastolic = vitalSignList[i].values()[0].scalar();
                    }
                }
            }

            if (bpSystolic > 0 && bpDiastolic > 0 &&
                bpSystolic <= bpSystolicLimit && bpDiastolic <= bpDiastolicLimit) {
                return true
            }
        }
        return false;
    }

    emit('total_pop', 1);

    if (population()) {
        if (hasProblemCode()) {
            emit("denominator_diabetics", 1);
            if (hasBloodPressure() && hasBloodPressureMatchingIndicators()) {
                emit("numerator_diabetics_bp", 1);
            }
        }
    }

    // Empty Case
    emit("numerator_diabetics_bp", 0);
    emit("denominator_diabetics", 0);
}