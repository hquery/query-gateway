// Reference Number: PDC-056
// Query Title: Patients, 65 and older, with impaired renal function who are on digoxin >125 mcg/day
function map(patient) {
    var targetMedicationCodes = {
        "whoATC": ["C01AA*"],
        "HC-DIN": ["02281236", "02281228", "02281201", "02245428", "02245427",
            "02245426", "02048264", "02048272", "0021415", "00698296", "00647470"]
    };

    var targetCreatinineCodes = {
        "pCLOCD": ["45066-8", "14682-9", "2160-0", "33914-3", "50044-7", "48642-3", "48643-1"]
    };

    var targetEGFRCodes = {
        "pCLOCD": ["33914-3"]
    };

    var ageLimit = 65;
    var creatinineLimit = 150; // Measured in umol/L
    var egfrLimit = 50; // Measured in ml/min
    var digoxinLimit = 0.125; // Measured in MG

    var drugList = patient.medications();
    var resultList = patient.results();

    var now = new Date(2013, 10, 30);
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

    // a and b are javascript Date objects
    // Returns a with the 1.2x calculated date offset added in
    function endDateOffset(a, b) {
        var start = new Date(a);
        var end = new Date(b);
        var diff = Math.floor((end-start) / (1000*3600*24));
        var offset = Math.floor(1.2 * diff);
        return addDate(start, 0, 0, offset);
    }

    function isCurrentDrug(drug) {
        var drugStart = drug.indicateMedicationStart().getTime();
        var drugEnd = drug.indicateMedicationStop().getTime();

        return (endDateOffset(drugStart, drugEnd) >= now && drugStart <= now);
    }

    // Checks if patient is older than ageLimit
    function population(patient) {
        return (patient.age(now) >= ageLimit);
    }

    // Checks for Creatinine labs performed within the last 10 years
    function hasCreatinineCode() {
        return resultList.match(targetCreatinineCodes, addDate(now, -10, 0, 0), end).length;
    }

    // Checks for eGFR labs performed within the last 10 years
    function hasEGFRCode() {
        return resultList.match(targetEGFRCodes, addDate(now, -10, 0, 0), end).length;
    }

    // Checks for existence of Digoxin
    function hasMedication() {
        return drugList.regex_match(targetMedicationCodes, start, end).length;
    }

    // Checks for impaired renal function
    function hasImpairedRenalFunctionCode() {
        return hasCreatinineCode() || hasEGFRCode();
    }

    // Checks if Creatinine meets parameters
    function hasMatchingCreatinineValue() {
        for (var i = 0; i < resultList.length; i++) {
            if (resultList[i].includesCodeFrom(targetCreatinineCodes) &&
                resultList[i].timeStamp() > start) {
                if (resultList[i].values()[0].units() !== null &&
                    resultList[i].values()[0].units().toLowerCase() === "umol/L".toLowerCase()) {
                    if (resultList[i].values()[0].scalar() > creatinineLimit) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    // Checks if eGFR meets parameters
    function hasMatchingEGFRValue() {
        for (var i = 0; i < resultList.length; i++) {
            if (resultList[i].includesCodeFrom(targetEGFRCodes) &&
                resultList[i].timeStamp() > start) {
                if (resultList[i].values()[0].units() !== null &&
                    resultList[i].values()[0].units().toLowerCase() === "mL/min".toLowerCase()) {
                    if (resultList[i].values()[0].scalar() > egfrLimit) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    // Checks if Lab values indicate impared renal function
    function hasImpairedRenalLabValues() {
        return hasMatchingCreatinineValue() || hasMatchingEGFRValue();
    }

    // Checks if existing Digoxin is current
    function hasCurrentMedication() {
        for (var i = 0; i < drugList.length; i++) {
            var tmpArray = new hQuery.CodedEntryList();
            tmpArray[0] = drugList[i];
            if (tmpArray.match(targetMedicationCodes)) {
                if(isCurrentDrug(drugList[i])) {
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
                    if (drugList[i].values()[0].units() !== null &&
                        drugList[i].values()[0].units().toLowerCase() === "MG".toLowerCase()) {
                        if (drugList[i].values()[0].scalar() > digoxinLimit) {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }

    if (population(patient)) {
        emit("senior_pop", 1);
        if(hasImpairedRenalFunctionCode() && hasImpairedRenalLabValues()) {
            emit("denominator_senior_pop_impaired_renal", 1);
            if(hasMedication() && hasCurrentMedication() && hasMatchingMedicationDose()) {
                emit("numerator_senior_pop_renal_digoxin", 1);
            }
        }
    }

    // Empty Case
    emit("numerator_senior_pop_renal_digoxin", 0);
    emit("denominator_senior_pop_impaired_renal", 0);
}
