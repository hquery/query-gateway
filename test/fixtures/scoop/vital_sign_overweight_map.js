function map(patient) {
    var targetWaistCircumferenceCodes = {
        "LOINC": ["56115-9"]
    };

    var targetHeightCodes = {
        "LOINC": ["8302-2"]
    }

    var targetWeightCodes = {
        "LOINC": ["3141-9"]
    }

    var ageLimit = 19;

    var wcLimit = 80;

    var vitalSignList = patient.vitalSigns();

    var now = new Date(2013, 7, 19);
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


    // Checks for existence of waist circumference observation
    function hasWaistCircumference() {
        return vitalSignList.match(targetWaistCircumferenceCodes, start, end).length;
    }

    function hasHeight() {
        return vitalSignList.match(targetHeightCodes, start, end).length;
    }

    function hasWeight() {
        return vitalSignList.match(targetWeightCodes, start, end).length;
    }

    function hasMatchingIndicator() {
        for (var i = 0; i < vitalSignList.length; i++) {
            //if (vitalSignList[i].values()[0].units() == "cm") {
            if (vitalSignList[i].includesCodeFrom(targetWaistCircumferenceCodes) &&
                vitalSignList[i].values()[0].scalar() > wcLimit) {
                return true;
            }
            //}
        }
        return false;
    }

    // http://en.wikipedia.org/wiki/Body_mass_index
    function getBMI(height, weight, metric) {
        if (metric) {
            bmi = weight/(height/100.0)^2; // assume cm and kg
        } else {
            bmi = 703 * weight /height^2;  // assume in and lb
        }
        return bmi;
    }

    function hasHWMatchingIndicator() {
        var height = 0;
        var weight = 0;
        var bmi = 0;
        for (var i = 0; i < vitalSignList.length; i++) {
            //if (vitalSignList[i].values()[0].units() == "cm") {
            if (vitalSignList[i].includesCodeFrom(targetHeightCodes)) {
                height = vitalSignList[i].values()[0].scalar();
                //emit("height="+height,1);
            }
            if (vitalSignList[i].includesCodeFrom(targetWeightCodes)) {
                weight = vitalSignList[i].values()[0].scalar();
                //emit("weight="+weight,1);
            }
            if (height != 0 && weight != 0) {
                bmi = getBMI(height,weight,true);
                //emit("bmi="+bmi,1);
                return bmi > 30;
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
            emit(">19_pop_overweight", 0)
        };
        if (hasHWMatchingIndicator()) {
            emit(">19_pop_bmi>30",1);
        } else {
            emit(">19_pop_bmi>30",0);
        };
    }
}