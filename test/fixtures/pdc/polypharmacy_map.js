// Reference Number: PDC-053
// Query Title: Patients, 65 and older, on 5 or more medications
// Reference Number: PDC-054
// Query Title: Patients, 65 and older, on 10 or more medications
function map(patient) {
    var ageLimit = 65;
    var drugLimit = 5; // Change this value to number of active medications to count
    var time = new Date(2013, 2, 10);

    var drugList = patient.medications();
    var currentDrugs = findCurrentDrugs(drugList, time);

    // Returns count of "active" drugs that are between start & end date
    // Also checks for the same "active" drug and doesn't overcount
    function findCurrentDrugs(drugs, time) {
        var now = time.getTime();
        var count = 0;
        var seenDrugs = [];

        for(var i = 0; i < drugs.length; i++) {
            var repeat = false;
            var drugStart = drugs[i].indicateMedicationStart().getTime();
            var drugEnd = drugs[i].indicateMedicationStop().getTime();

            // Check if drug is within the right time
            if(drugEnd >= now && drugStart <= now) {
                // Check if this entry is a repeat of same drug (codesystem agnostic)
                var codes = drugs[i].medicationInformation().codedProduct();

                for (var j = 0; j < codes.length; j++) {
                    var code = codes[j].code();

                    if(seenDrugs.indexOf(code) == -1) {
                        seenDrugs.push(code);
                    }
                    else {
                        repeat = true;
                    }
                }

                // Increment count if not a repeat
                if(!repeat) {
                    count++;
                }
            }
        }

        return count;
    }

    emit('total_population', 1);
    if (patient.age(time) > ageLimit) {
        emit('sampled_number', 1);

        // Adds patient to count if over ageLimit & over drugLimit
        if (currentDrugs > drugLimit) {
            emit('polypharmacy_number', 1);
        }
    }
}
