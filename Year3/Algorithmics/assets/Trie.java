import java.util.ArrayList;

public class Trie {
	
	// create root of the trie
	private Node root; 
	
	public Trie() {
		// null character in the root
		root = new Node(Character.MIN_VALUE); 
	}        
	
	// possible outcomes of a search
	private enum Outcomes {PRESENT, ABSENT, UNKNOWN}
	
	/** search trie for word w */
	public boolean search(String w) {
		
		// initially outcome unknown
		Outcomes outcome = Outcomes.UNKNOWN;
		
		// position in word so far searched (start at beginning)
		int i = 0;
		
		// start with first child of the root
		Node current = root.getChild();
		
		// start search
		while (outcome == Outcomes.UNKNOWN) {
			
			if (current == null) outcome = Outcomes.ABSENT; // dead-end
			else if (current.getLetter() == w.charAt(i)) { // positions match				
				if (i == w.length() - 1) {
					outcome = Outcomes.PRESENT; // matched word
				}
				else { // descend one level...
					current = current.getChild(); // in trie
					i++; // in word being searched
				}
			}	
			else { // positions not matched so try next sibling
				current = current.getSibling();
			}
		}
		// return answer
		if (outcome != Outcomes.PRESENT) return false;
		else return current.getIsWord();
	}
	
	/** inserting a word w into trie */
	public void insert(String w){
		
		int i = 0; // position in word (start at beginning)
		Node current = root; // current node in trie (start at root)
		Node next = current.getChild(); // first child of current node we are testing
		
		while (i < w.length()) { // not reached end of word
			if (next !=null && next.getLetter() == w.charAt(i)) { // chars match: decend a level
				current = next; // update node to the child node
				next = current.getChild(); // update child node
				i++; // next position in the word
			} 
			else if (next != null) { // try next sibling
				next = next.getSibling();
			}
			else { // no more siblings: need new node
				Node x = new Node(w.charAt(i)); // label with ith element of the word
				x.setSibling(current.getChild()); // sibling: first child of current node
				current.setChild(x); // make first child of current node
				current = x; // move to the new node
				next = current.getChild(); // update child node
				i++; // next position in word
			}
		}
		current.setIsWord(true); // current represents word w

	}
	
	// traverse method for extracting words - to be added (task 1)
	
}
