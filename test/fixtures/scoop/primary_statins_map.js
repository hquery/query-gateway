// Reference Number: PDC-005
// Query Title: Statins for primary prevention
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

    var now = new Date(2013, 2, 10);

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
                if(codes[j].codeSystemName() == "whoATC") {
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

    function isCurrentDrug(drug) {
        var drugStart = drug.indicateMedicationStart().getTime();
        var drugEnd = drug.indicateMedicationStop().getTime();

        return (drugEnd >= now && drugStart <= now);
    }

    if (hasCurrentDrugCode()) {
        emit("has_current_statin", 1);
        if(!hasProblemCode()) {
            emit("no_mi_or_stroke", 1);
        }
    }
}
