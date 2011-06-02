function(gender, counts) {
  var sum = 0;
  for(var i in counts) sum += counts[i];
  return sum;
};