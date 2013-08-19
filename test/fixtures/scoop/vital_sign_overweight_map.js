function map(patient) {
    var targetWaistCircumferenceCodes = {
        "LOINC": ["8302-2"]
    };

    var wcLOINC = { "LOINC" : [ "56115-9" ] }

    var targetHeightCodes = {
        "LOINC": ["8302-2"]
    }

    var targetWeightCodes = {
        "LOINC": ["3141-9"]
    }

    var ageLimit = 20;

    var wcLimit = 169;

    var vitalSignList = patient.vitalSigns();

    var now = new Date(2013, 6, 20);
    var start = new Date(2000, 6, 1);
    var end = addDate(now, 0, 1, 0);

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


    // Checks for existence of waist circumference observation
    function hasWaistCircumference() {
        return vitalSignList.match(targetWaistCircumferenceCodes, start, end).length;
    }

    function hasMatchingIndicator() {
        for (var i = 0; i < vitalSignList.length; i++) {
            //if (vitalSignList[i].values()[0].units() == "cm") {
                if (vitalSignList[i].includesCodeFrom(targetWaistCircumferenceCodes) &&
                    vitalSignList[i].values()[0].scalar() > wcLimit) {
                    emit("vital sign: "+vitalSignList[i].values()[0].scalar(), 1)
                    return true;
                }
            //}
        }
        return false;
    }

    emit('total_pop', 1);

    if (hasWaistCircumference()) {
        emit("total_overweight", 1);
    }

    if (population(patient)) {
        //emit("senior_pop: " + patient.given() + " " + patient.last(), 1);
        emit(">19_pop", 1);
        if (hasWaistCircumference() && hasMatchingIndicator()) {
            emit(">19_pop_overweight", 1);
        } else {
            emit(">19_pop_overweight", 0);
        }
    }
}