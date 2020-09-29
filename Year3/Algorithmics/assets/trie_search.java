// searching for a word w in a trie t
Node n = root of t; // current node (start at root)
int i = 0; // current position in word w (start at beginning)

while (true) {
	if (n has a child c labelled w.charAt(i)) {
// can match the character of word in the current position
		if (i == w.length()-1) { // end of word
			if (c is an 'intermediate' node) return "absent";
			else return "present";
		} else { // not at end of word
			n = c; // move to child node
			i++; // move to next character of word
		}
	} else return "absent"; // cannot match current character
}

// inserting a word w in a trie t
Node n = root of t; // current node (start at root)
for (int i=0; i < w.length(); i++){ // go through chars of word
	if (n has no child c labelled w.charAt(i)){
// need to add new node
		create such a child c;
		mark c as intermediate;
	}
n = c; // move to child node
}
// mark n as representing a word;