// Reference Number: PDC-055
// Query Title: Most commonly prescribed medication classes

function map(patient) {
    var atcLevel = 2; // Level definition based on definition found on Wikipedia
    var atcCutoff = getATCCodeLength(atcLevel);

    var drugList = patient.medications();

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
        var diff = Math.floor((end - start) / (1000 * 3600 * 24));
        var offset = Math.floor(1.2 * diff);
        return addDate(start, 0, 0, offset);
    }

    function isCurrentDrug(drug) {
        var drugStart = drug.indicateMedicationStart().getTime();
        var drugEnd = drug.indicateMedicationStop().getTime();

        return (endDateOffset(drugStart, drugEnd) >= now && drugStart <= now);
    }

    // Define ATC cutoff levels
    function getATCCodeLength(val) {
        switch (val) {
            case 1:
                return 1;
            case 2:
                return 3;
            case 3:
                return 4;
            case 4:
                return 5;
            case 5:
                return 7;
            default:
                return 0;
        }
    }

    for (var i = 0; i < drugList.length; i++) {
        if (isCurrentDrug(drugList[i])) {
            // Get all represented codes for each drug
            var codes = drugList[i].medicationInformation().codedProduct();

            // Filter out only ATC codes
            for (var j = 0; j < codes.length; j++) {
                if (codes[j].codeSystemName().toLowerCase() !== null &&
                    codes[j].codeSystemName().toLowerCase() === "whoATC".toLowerCase()) {
                    // Truncate to appropriate level length
                    emit(codes[j].code().substring(0, atcCutoff), 1);
                }
            }
        }
    }
}
