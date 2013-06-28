function reduce(key, values) {
    var result = 0;

    while (values.hasNext()) {
        result += values.next();
    }

    return result;
}
