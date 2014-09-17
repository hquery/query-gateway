function map(patient) {
    var time = new Date(2013, 5, 1);
    if (patient.gender() == "M") {
        var age = patient.age(time);
        if (typeof age !== 'undefined') {
            age = Math.floor(age);
        }
        if(age >= 65) {
            emit("male_>65", 1);
        }
    }
}
