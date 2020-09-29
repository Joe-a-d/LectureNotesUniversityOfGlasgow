// assume we have the following method which returns 
// the value represented by the b bits of x when starting at position pos
private int bits(Item x, int b, int pos)

// suppose that:
// a is the sequence to be sorted
// m is the number of bits in each item of the sequence a
// b is the ‘block length’ of radix sort

// number of iterations required for sorting
int numIterations = m / b;

// number of buckets
int numBuckets = (int) Math.pow(2, b); 

// represent sequence a to be sorted as an ArrayList of Items
ArrayList < Item > a = new ArrayList < Item > ();

// represent the buckets as an array of ArrayLists
ArrayList < Item > [] buckets = new ArrayList[numBuckets];

for (int i = 0; i < numBuckets; i++) buckets[i] = new ArrayList < Item > ();

for (int i = 1; i <= numIterations; i++) {
  // clear the buckets
  for (int j = 0; j < numBuckets; j++) buckets[j].clear();
  // distribute the items (in order from the sequence a)
  for (Item x: a) {
    // find the value of the b bits starting from position (i-1)*b in x
    int k = bits(x, b, (i - 1) * b); // find the correct bucket for item x
    buckets[k].add(x); // add item to this bucket
  }
  a.clear(); // clear the sequence

  // concatenate the buckets (in sequence) to form the new sequence
  for (j = 0; j < numBuckets; j++) a.addAll(buckets[j]);
}