
public class Node {

	private char letter; // label on incoming branch
	private boolean isWord; // true when node represents a word
	private Node sibling; // next sibling (when it exists)
	private Node child; // first child (when it exists)
	
	/** create a new node with letter c */
	public Node(char c){
		letter = c;
		isWord = false;
		sibling = null;
		child = null;
	}

	// accessors
	public char getLetter(){
    	return letter;
    }
	public boolean getIsWord(){
    	return isWord;
    }
	public Node getSibling(){
    	return sibling;
    }
	public Node getChild(){
    	return child;
    }
	
	// mutators
	public void setLetter(char c){
    	letter = c;
    }
	public void setIsWord(boolean b){
    	isWord = b;
    }
	public void setSibling(Node n){
    	sibling = n;
    }
	public void setChild(Node n){
    	child = n;
    }
    
}

