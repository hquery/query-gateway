// Supports Query Title: Diabetes & BP <= 130/80 in last yr

// Warning: Still work in progress.
function map(patient) {

    var targetBloodPressureCodes = {
        "LOINC": ["55284-4"]
    };

    var targetBloodPressureSystolicCodes = {
        "LOINC": ["8480-6"]
    };

    var targetBloodPressureDiastolicCodes = {
        "LOINC": ["8462-4"]
    };

    var targetLabCodes = {
        "LOINC": ["4548-4"]
    };

    var targetProblemCodes = {
        "ICD9": ["250"]
    };

    var ageLimit = 18;
    var bpSystolicLimit = 130
    var bpDiastolicLimit = 80

    var resultList = patient.results();
    var problemList = patient.conditions();
    var vitalSignList = patient.vitalSigns();

    var now = new Date(2013, 7, 19);
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
    function population(patient) {
        return (patient.age(now) >= ageLimit);
    }

    // Checks for existence of blood pressure observation
    function hasBloodPressure() {
        return vitalSignList.match(targetBloodPressureCodes, start, end).length;
    }

    // Checks for existence of systolic blood pressure observation
    function hasSystolicBloodPressure() {
        return vitalSignList.match(targetBloodPressureSystolicCodes, start, end).length;
    }

    // Checks for existence of diastolic blood pressure observation
    function hasDiastolicBloodPressure() {
        return vitalSignList.match(targetBloodPressureDiastolicCodes, start, end).length;
    }

    // Checks for HGBA1C labs performed within the last 12 months
    function hasLabCode() {
        return resultList.match(targetLabCodes, start, end).length;
    }

    // Checks for diabetic patients
    function hasProblemCode() {
        return problemList.match(targetProblemCodes).length;
    }


    function hasBloodPressureMatchingIndicator() {
        for (var i = 0; i < vitalSignList.length; i++) {
            if (vitalSignList[i].includesCodeFrom(targetBloodPressureCodes) &&
                vitalSignList[i].values()[0].scalar() < bpSystolicLimit) {
                //emit('systolic_dystolic['+i+']: '+vitalSignList[i].values()[0].scalar(), 1);
                return true;
            } else {
                //emit('systolic_dystolic['+i+']: '+vitalSignList[i].values()[0].scalar(), 0);
            }
        }
        return false;
    }

    emit('total_pop', 1);

    if (population(patient)) {
        //emit("senior_pop: " + patient.given() + " " + patient.last(), 1);
        emit(">=18_pop", 1);

        if (hasProblemCode()) {
            emit(">=18_diabetics", 1);
            if(hasLabCode()) {
                emit(">=18_diabetics_has_hgba1c_result", 1);
                if (hasBloodPressure()) {
                    emit(">=18_diabetics_bp",1)
                    //if (hasBloodPressureMatchingIndicator()) {
                    //    emit(">=18_diabetics_bp130",1)
                    //}
                } else {
                    emit(">=18_diabetics_bp",0)
                }
            } else {
                emit(">=18_diabetics_has_hgba1c_result", 0);
            }
        } else {
            emit(">=18_diabetics", 0);
        }
    }
}