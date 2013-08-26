// Query Title: Statins for primary prevention
// TODO: Add freetext definition search
function map(patient) {
    var targetProblemCodes = {
        "ICD9": ["410.0", "410.1", "410.2", "410.3", "410.4", "410.5", "410.6", "410.7", "410.8", "410.9",
                 "411.0", "411.1", "411.2", "411.3", "411.4", "411.5", "411.6", "411.7", "411.8", "411.9",
                 "412.0", "412.1", "412.2", "412.3", "412.4", "412.5", "412.6", "412.7", "412.8", "412.9",
                 "429.7,", "410", "411", "412", "V17.1", "438",
                 "43301", "43311", "43321", "43331", "43341", "43351", "43361", "43371", "43381", "43391",
                 "43401", "43411", "43421", "43431", "43441", "43451", "43461", "43471", "43481", "43491",
                 "438.0", "438.1", "438.2", "438.3", "438.4", "438.5", "438.6", "438.7", "438.8", "438.9"]
    };

    var targetDrugCodes = {
        "whoATC": ["C10AA", "C10BX"]
    };

    var drugList = patient.medications();
    var problemList = patient.conditions();

    var now = new Date(2013, 2, 10);

    // Checks for diabetic patients
    function hasProblemCode() {
        return problemList.match(targetProblemCodes).length;
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
