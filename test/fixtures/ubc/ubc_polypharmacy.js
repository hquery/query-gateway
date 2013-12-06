// Reference Number: UBC-001
// Query Title: Patients, 65 and older, on 5 or more medications
// Reference Number: UBC-002
// Query Title: Patients, 65 and older, on 10 or more medications
// Created by rrusk on 2013-12-06.

function map(patient) {
    var ageLimit = 65;
    var drugLimit = 5; // Change this value to number of active medications to count
    var now = new Date();

    var drugList = patient.medications();
    var currentDrugs = findCurrentDrugs(drugList);
    var currentDrugsWithoutPRN = findCurrentDrugsWithoutPRN(drugList);

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

    // Returns count of "active" drugs that are between start & end date
    // Also checks for the same "active" drug and doesn't overcount
    function findCurrentDrugs(drugs) {
        var count = 0;
        var seenDrugs = [];

        for(var i = 0; i < drugs.length; i++) {
            var repeat = false;

            // Check if drug is PRN or within the right time
            if(drugs[i].freeTextSig().indexOf(" E2E_PRN flag") !== -1
                || isCurrentDrug(drugs[i])) {
                // Check if this entry is a repeat of same drug (codesystem agnostic)
                var codes = drugs[i].medicationInformation().codedProduct();

                for (var j = 0; j < codes.length; j++) {
                    var code = codes[j].code();

                    if(seenDrugs.indexOf(code) === -1) {
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

    // Returns count of "active" drugs that are between start & end date
    // Also checks for the same "active" drug and doesn't overcount
    function findCurrentDrugsWithoutPRN(drugs) {
        var count = 0;
        var seenDrugs = [];

        for(var i = 0; i < drugs.length; i++) {
            var repeat = false;

            // Check if drug is within the right time
            if(isCurrentDrug(drugs[i])) {

                // check whether drugs[i] is a PRN; if it is skip
                if (drugs[i].freeTextSig().indexOf(" E2E_PRN flag") !== -1) {
                    continue; // continue on to next drug immediately
                }

                // Check if this entry is a repeat of same drug (codesystem agnostic)
                var codes = drugs[i].medicationInformation().codedProduct();

                for (var j = 0; j < codes.length; j++) {
                    var code = codes[j].code();

                    if(seenDrugs.indexOf(code) === -1) {
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
    if (patient.age(now) >= ageLimit) {
        emit('denominator_sampled_number', 1);

        // Adds patient to count if over ageLimit & over drugLimit
        if (currentDrugs >= drugLimit) {
            emit('numerator_polypharmacy_number_including_prn', 1);
        }
        // Adds patient to count if over ageLimit & over drugLimit
        if (currentDrugsWithoutPRN > drugLimit) {
            emit('numerator_polypharmacy_number_without_prn', 1);
        }

        // Empty Case
        emit('numerator_polypharmacy_number_including_prn', 0);
        emit('numerator_polypharmacy_number_without_prn', 0);
        emit('denominator_sampled_number', 0);
    }
}
