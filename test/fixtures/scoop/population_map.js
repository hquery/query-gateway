// TODO: Factor in Clinical Encounters
function map(patient) {
    var time = new Date(2013, 7, 19);
    var age = Math.floor(patient.age(time));
    var gender;

    if (patient.gender() == "M") {
        gender = "male"
        emit("total_male", 1);
    }
    else {
        gender = "female"
        emit("total_female", 1)
    }

    if(age <= 9) {
        emit(gender + "_0-9", 1);
        emit("total_0-9", 1);
    }
    else if(age >= 10 && age <= 19) {
        emit(gender + "_10-19", 1);
        emit("total_10-19", 1);
    }
    else if(age >= 20 && age <= 29) {
        emit(gender + "_20-29", 1);
        emit("total_20-29", 1);
    }
    else if(age >= 30 && age <= 39) {
        emit(gender + "_30-39", 1);
        emit("total_30-39", 1);
    }
    else if(age >= 40 && age <= 49) {
        emit(gender + "_40-49", 1);
        emit("total_40-49", 1);
    }
    else if(age >= 50 && age <= 59) {
        emit(gender + "_50-59", 1);
        emit("total_50-59", 1);
    }
    else if(age >= 60 && age <= 69) {
        emit(gender + "_60-69", 1);
        emit("total_60-69", 1);
    }
    else if(age >= 70 && age <= 79) {
        emit(gender + "_70-79", 1);
        emit("total_70-79", 1);
    }
    else if(age >= 80 && age <= 89) {
        emit(gender + "_80-89", 1);
        emit("total_80-89", 1);
    }
    else {
        emit(gender + "_90+", 1);
        emit("total_90+", 1);
    }

    emit("total_population", 1);
}
