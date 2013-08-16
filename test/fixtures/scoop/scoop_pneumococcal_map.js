function map(patient) {
    var targetImmunizationCodes = {
        "whoATC": ["J07AL02"]
    };

    var ageLimit = 65;

    var immunizationList = patient.immunizations();

    var now = new Date(2013, 6, 20);
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


    // Checks for existence of Pneumovax
    function hasImmunization() {
        return immunizationList.match(targetImmunizationCodes, start, end).length;
    }

    emit('total_pop', 1);

    if (hasImmunization()) {
        emit("total_pneumovax", 1);
    }

    if (population(patient)) {
        //emit("senior_pop: " + patient.given() + " " + patient.last(), 1);
        emit("senior_pop", 1);
        if (hasImmunization()) {
            emit("senior_pop_pneumovax", 1);
        }
    }
}
