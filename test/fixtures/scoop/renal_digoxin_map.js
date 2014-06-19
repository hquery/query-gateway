function map(patient) {
    var targetMedicationCodes = {
        "whoATC": ["C01AA05"],
        "HC-DIN": ["02281236", "02281228", "02281201", "02245428", "02245427",
            "02245426", "02048264", "02048272", "0021415", "00698296", "00647470"]
    };

    var targetLabCodes = {
        "pCLOCD": ["45066-8", "2160-0", "33914-3", "50044-7", "48642-3", "48643-1"]
    };

    var ageLimit = 65;

    var drugList = patient.medications();
    var resultList = patient.results();

    var now = new Date(2013, 10, 30);
    var start = new Date(2000, 6, 1);
    var end = addDate(now, 0, 1, 0);

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

    // Checks for Creatinine labs performed within the last year
    function hasLabCode() {
        return resultList.match(targetLabCodes, addDate(now, -1, 0, 0), end).length;
    }

    // Checks for existence of Digoxin
    function hasMedication() {
        return drugList.match(targetMedicationCodes, start, end).length;
    }

    function hasCurrentMedication() {
        for (var i = 0; i < drugList.length; i++) {
            var tmpArray = new hQuery.CodedEntryList();
            tmpArray[0] = drugList[i];
            if (tmpArray.match(targetMedicationCodes)) {
                var drugStart = drugList[i].indicateMedicationStart().getTime();
                var drugEnd = drugList[i].indicateMedicationStop().getTime();

                // Check if drug is within the right time
                if (drugEnd >= now && drugStart <= now) {
                    return true;
                }
            }
        }
        return false;
    }

    emit('total_pop', 1);

    if (population(patient)) {
        //emit("senior_pop: " + patient.given() + " " + patient.last(), 1);
        emit("senior_pop", 1);
        if (hasLabCode()) {
            if (hasMedication() && hasCurrentMedication()) {
                //emit("Digoxin: " + patient.given() + " " + patient.last(), 1);
                //emit("Creatinine: " + patient.given() + " " + patient.last(), 1);
                var c = patient.results();
                for (var i = 0; i < c.length; i++) {
                    if (c[i].interpretation().code() == "A") {
                        //emit("Abnormal Creatinine: " + patient.given() + " " + patient.last(), 1);
                        emit("senior_pop_digoxin_creatinine_abnormal", 1);
                    }
                }
            }
        }
    }
}
