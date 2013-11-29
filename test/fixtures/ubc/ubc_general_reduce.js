/**
 * Created by rrusk on 2013-11-29.
 */

function reduce(key, values) {
    var result = 0;

    while (values.hasNext()) {
        result += values.next();
    }

    return result;
}