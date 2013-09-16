// Reference Number: PDC-028
// Supports Query Title: Diabetes & BP <= 130/80 in last yr

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

    // Checks for diabetic patients
    function hasProblemCode() {
        return problemList.regex_match(targetProblemCodes).length;
    }

    function hasBloodPressureMatchingIndicators() {
        for (var i = 0; i < vitalSignList.length - 1; i++) {
            var bpSystolic = 0;
            var bpDiastolic = 0;
            if (vitalSignList[i].includesCodeFrom(targetBloodPressureSystolicCodes)) {
                if (vitalSignList[i].values()[0].units() == "mm[Hg]") {
                    bpSystolic = vitalSignList[i].values()[0].scalar();
                    //emit('systolic['+i+']: '+vitalSignList[i].values()[0].scalar(), 1);
                } // TODO - assumes diastolic is next vital sign after systolic!  Can we do better?
                if (vitalSignList[i+1].values()[0].units() == "mm[Hg]") {
                    bpDiastolic = vitalSignList[i+1].values()[0].scalar();
                    //emit('diastolic['+(i+1)+']: '+vitalSignList[i+1].values()[0].scalar(), 1);
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

    if (population(patient)) {
        //emit("senior_pop: " + patient.given() + " " + patient.last(), 1);
        emit("pop", 1);

        if (hasProblemCode()) {
            emit("diabetics", 1); //+patient.given()+" "+patient.last(), 1);
            if (hasBloodPressureMatchingIndicators()) {
                emit("diabetics_bp", 1); //+patient.given()+" "+patient.last(), 1);
            } else {
                emit("diabetics_bp", 0);
            }
        }
    }
}