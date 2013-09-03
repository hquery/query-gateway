// Reference Number: PDC-055
// Query Title: Most commonly prescribed medication classes
function map(patient) {
    var atcLevel = 4; // Level definition based on definition found on Wikipedia

    var drugClasses = findATCDrugClasses(patient.medications(), atcLevel);

    for(var i = 0; i < drugClasses.length; i++) {
        emit(drugClasses[i], 1);
    }
}

// Returns list of all ATC medication codes
function findATCDrugClasses(drugs, level) {
    var list = [];
    var cutoff;

    // Define ATC cutoff levels
    switch(level) {
        case 1:
            cutoff = 1;
            break;
        case 2:
            cutoff = 3;
            break;
        case 3:
            cutoff = 4;
            break;
        case 4:
            cutoff = 5;
            break;
        /* Prevent data leakage - only want classes, not specific substance
         case 5:
         cutoff = 7;
         break;
         */
        default:
            return list;
    }

    for(var i = 0; i < drugs.length; i++) {
        // Get all represented codes for each drug
        var codes = drugs[i].medicationInformation().codedProduct();

        // Filter out only ATC codes
        for(var j = 0; j < codes.length; j++) {
            if(codes[j].codeSystemName() == "whoATC") {
                // Truncate to appropriate level length
                list.push(codes[j].code().substring(0, cutoff));
            }
        }
    }

    return list;
}
