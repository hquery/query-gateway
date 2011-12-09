function reduce(gender, counts) {
  var sum = 0;
  while(counts.hasNext()){
    sum += counts.next();
  }
  return sum;
};