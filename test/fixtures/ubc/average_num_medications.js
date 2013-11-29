// Reference Number: UBC-008
// Query Title: Average number of prescriptions
//
// Created by rrusk on 2013-11-28.
//
// Equivalent SQL:
//
// Numerator:
// SELECT
//   COUNT(d.drugid) AS Count
// FROM
//   drugs AS d
// WHERE
//   d.rx_date >= DATE_SUB( NOW(), INTERVAL 12 MONTH ) AND
//   d.archived = 0
//
// Denominator:
// SELECT
//   COUNT(DISTINCT d.demographic_no) AS 'Count'
// FROM
//   drugs AS d
// WHERE
//   d.rx_date >= DATE_SUB( NOW(), INTERVAL 12 MONTH ) AND
//   d.archived = 0

// There is no drug object in the mongodb.  All medications are attached to specific, active patients
// so it is not possible to duplicate the previous OSCAR SQL query exactly.  This calculation is similar.
// though.

function map(patient) {
    var now = new Date();
    var startDate = addDate(now, -1, 0, 0); // last 12 months

    var drugList = patient.medications();
    var currentDrugs;

    if (drugList === null || drugList.length === 0) {
        emit('patients_no_medication_record', 1);
    } else {
        emit('patients_with_medication_record', 1);
        currentDrugs = findCurrentDrugs(drugList);
    }

    // Shifts date by year, month, and date specified
    function addDate(date, y, m, d) {
        var n = new Date(date);
        n.setFullYear(date.getFullYear() + (y || 0));
        n.setMonth(date.getMonth() + (m || 0));
        n.setDate(date.getDate() + (d || 0));
        return n;
    }

    function isCurrentDrug(drug) {
        var start = drug.indicateMedicationStart().getTime();
        return (start >= startDate);
    }

    // Find uncoded drugs that are between start & end date
    function findCurrentDrugs(drugs) {

        for(var i = 0; i < drugs.length; i++) {

            var codes = drugs[i].medicationInformation().codedProduct();

            if (codes === null || codes.length == 0) {
                emit('medication_no_codedProduct', 1);
            } else {
                // Check if drug is within the right time
                var j;
                if(isCurrentDrug(drugs[i])) {
                    for (j = 0; j < codes.length; j++) {
                        emit('medication_last12months', 1);
                    }
                } else {
                    for (j = 0; j < codes.length; j++) {
                        emit('medication_prior_to_last12months', 1);
                    }
                }
            }
        }
    }

    emit('total_population', 1);

    // Empty Case
    emit('patients_no_medication_record', 0);
    emit('patients_with_medication_record', 0);
    emit('medication_last12months', 0);
    emit('medication_prior_to_last12months', 0);
}