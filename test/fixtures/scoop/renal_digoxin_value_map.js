// Reference Number: PDC-056
// Query Title: Patients, 65 and older, with impaired renal function who are on digoxin >125 mcg/day
function map(patient) {
    var targetMedicationCodes = {
        "whoATC": ["C01AA*"],
        "HC-DIN": ["02281236", "02281228", "02281201", "02245428", "02245427",
            "02245426", "02048264", "02048272", "0021415", "00698296", "00647470"]
    };

    var targetLabCodes = {
        "LOINC": ["45066-8", "2160-0", "33914-3", "50044-7", "48642-3", "48643-1"]
    };

    var ageLimit = 65;
    var creatinineLimit = 150; // Measured in umol/L
    var digoxinLimit = .125; // Measured in MG

    var drugList = patient.medications();
    var resultList = patient.results();

    var now = new Date(2013, 5, 12);
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

    // Checks for Creatinine labs performed within the last year
    function hasLabCode() {
        return resultList.match(targetLabCodes, addDate(now, -1, 0, 0), end).length;
    }

    // Checks for existence of Digoxin
    function hasMedication() {
        return drugList.regex_match(targetMedicationCodes, start, end).length;
    }

    // Checks if Creatinine meets parameters
    function hasMatchingLabValue() {
        for (var i = 0; i < resultList.length; i++) {
            if (resultList[i].values()[0].units() == "umol/L") {
                if (resultList[i].values()[0].scalar() > creatinineLimit) {
                    //emit("Abnormal Creatinine: " + patient.given() + " " + patient.last(), 1);
                    return true;
                }
            }
        }
        return false;
    }

    // Checks if existing Digoxin is current
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

    // Checks if Digoxin meets dosage parameters
    function hasMatchingMedicationDose() {
        for (var i = 0; i < drugList.length; i++) {
            var codes = drugList[i].medicationInformation().codedProduct();

            // If Digoxin, check for dose parameter
            for (var j = 0; j < codes.length; j++) {
                if (codes[j].includedIn(targetMedicationCodes)) {
                    if (drugList[i].values()[0].units() == "MG") {
                        if (drugList[i].values()[0].scalar() > digoxinLimit) {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }

    emit('total_pop', 1);

    if (population(patient)) {
        //emit("senior_pop: " + patient.given() + " " + patient.last(), 1);
        emit("senior_pop", 1);
        if (hasLabCode() && hasMedication()) {
            //emit("Digoxin: " + patient.given() + " " + patient.last(), 1);
            //emit("Creatinine: " + patient.given() + " " + patient.last(), 1);
            if (hasMatchingLabValue() && hasCurrentMedication() && hasMatchingMedicationDose()) {
                emit("senior_pop_digoxin_creatinine", 1);
            }
        }
    }
}
