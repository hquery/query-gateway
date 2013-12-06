// Reference Number: PDC-058
// Query Title: Statins for secondary prevention
// TODO: Add freetext definition search
function map(patient) {
    var targetProblemCodes = {
        "ICD9": ["410..*", "411..*", "412..*", "429.7", "410", "411", "412",
                 "V17.1", "438", "433.1", "434.1", "438..*"]
    };

    var targetDrugCodes = {
        "whoATC": ["C10AA", "C10BX"]
    };

    var drugList = patient.medications();
    var problemList = patient.conditions();

    var now = new Date(2013, 10, 30);

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

    // Checks for diabetic patients
    function hasProblemCode() {
        return problemList.regex_match(targetProblemCodes).length;
    }

    // Checks for active statin prescription
    function hasCurrentDrugCode() {
        var targetDrugList = targetDrugCodes["whoATC"];

        for(var i = 0; i < drugList.length; i++) {
            // Get all represented codes for each drug
            var codes = drugList[i].medicationInformation().codedProduct();

            // Filter out only ATC codes
            for(var j = 0; j < codes.length; j++) {
                if(codes[j].codeSystemName().toLowerCase() !== null &&
                   codes[j].codeSystemName().toLowerCase() === "whoATC".toLowerCase()) {
                    if(targetDrugList.indexOf(codes[j].code().substring(0, 5)) > -1) {
                        emit("had_statins", 1);
                        if(isCurrentDrug(drugList[i])) {
                            return true;
                        }
                    }
                }
            }
        }

        return false;
    }

    if (hasCurrentDrugCode()) {
        emit("denominator_has_current_statin", 1);
        if(hasProblemCode()) {
            emit("numerator_mi_or_stroke", 1);
        }
    }

    // Empty Case
    emit("numerator_mi_or_stroke", 0);
    emit("denominator_has_current_statin", 0);
}
