// Supports Query Title: BMI or WC documented in last 2 yrs age > 19
//
// Also illustrates detecting the presence of vital sign information for heart
// rate, blood pressure, temperature, height, weight and waist circumference.
function map(patient) {
    var targetHeartRateCodes = {
        "LOINC": ["8867-4"]
    };

    var targetBloodPressureCodes = {
        "LOINC": ["55284-4"]
    };

    var targetBloodPressureSystolicCodes = {
        "LOINC": ["8480-6"]
    };

    var targetBloodPressureDiastolicCodes = {
        "LOINC": ["8462-4"]
    };

    var targetTemperatureCodes = {
        "LOINC": ["8310-5"]
    };

    var targetHeightCodes = {
        "LOINC": ["8302-2"]
    };

    var targetWeightCodes = {
        "LOINC": ["3141-9"]
    };

    var targetWaistCircumferenceCodes = {
        "LOINC": ["56115-9"]
    };

    var ageLimit = 19;

    var vitalSignList = patient.vitalSigns();

    var now = new Date(2013, 10, 30);
    var start = addDate(now, -2, 0, 0);
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


    // Checks for existence of heart rate observation
    function hasHeartRate() {
        return vitalSignList.match(targetHeartRateCodes, start, end).length;
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

    // Checks for existence of temperature observation
    function hasTemperature() {
        return vitalSignList.match(targetTemperatureCodes, start, end).length;
    }

    // Checks for existence of height observation
    function hasHeight() {
        return vitalSignList.match(targetHeightCodes, start, end).length;
    }

    // Checks for existence of weight observation
    function hasWeight() {
        return vitalSignList.match(targetWeightCodes, start, end).length;
    }

    // Checks for existence of waist circumference observation
    function hasWC() {
        return vitalSignList.match(targetWaistCircumferenceCodes, start, end).length;
    }

    emit('total_pop', 1);

    if (population(patient)) {
        //emit("senior_pop: " + patient.given() + " " + patient.last(), 1);
        emit(">19_pop", 1);
        if (hasHeartRate()) {
            emit(">19_pop_heartrate", 1);
        }
        if (hasBloodPressure()) {
            emit(">19_pop_bp",1)
        }
        if (hasSystolicBloodPressure()) {
            emit(">19_pop_bp_systolic",1)
        }
        if (hasDiastolicBloodPressure()) {
            emit(">19_pop_bp_diastolic",1)
        }
        if (hasTemperature()) {
            emit(">19_pop_temperature", 1);
        }
        if (hasHeight()) {
            emit(">19_pop_height", 1);
        }
        if (hasWeight()) {
            emit(">19_pop_weight", 1);
        }
        if (hasWC()) {
            emit(">19_pop_wc", 1);
        }
    }
}