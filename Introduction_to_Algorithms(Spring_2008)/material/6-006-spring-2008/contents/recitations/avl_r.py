import bstsize_r
from bstsize_r import BST, BSTnode

def height(node):
    if node is None:
        return -1
    else:
        return node.height

class AVLnode(BSTnode):
    """AVL node"""

    def update_stats(self):
        """Updates the current node's height based on its children's height"""
        self.height = max(height(self.left), height(self.right)) + 1
        BSTnode.update_stats(self)

    def left_rotate(self):
        """Left-rotates the subtree rooted at the current node. Returns the new root."""
        x = self; y = x.right
        y.parent = x.parent
        if y.parent.left is x:
            y.parent.left = y
        elif y.parent.right is x:
            y.parent.right = y
        x.right = y.left
        if x.right is not None:
            x.right.parent = x
        y.left = x
        x.parent = y
        x.update_stats()
        y.update_stats()
        return y
    
    def right_rotate(self):
        """Right-rotates the subtree rooted at the current node. Returns the new root."""
        x = self; y = x.left
        y.parent = x.parent
        if y.parent.left is x:
            y.parent.left = y
        elif y.parent.right is x:
            y.parent.right = y
        x.left = y.right
        if x.left is not None:
            x.left.parent = x
        y.right = x
        x.parent = y
        x.update_stats()
        y.update_stats()  
        
    def rebalance(self):
        """Re-balances an AVL tree, assuming the deepest violation occurs at this node."""        
        if self.key is None: return
        
        self.update_stats()
        if height(self.left) >= 2 + height(self.right):
            if height(self.left.left) < height(self.left.right):
                self.left.left_rotate()
            self.right_rotate()
        elif height(self.right) >= 2 + height(self.left):
            if height(self.right.right) < height(self.right.left):
                self.right.right_rotate()
            self.left_rotate()
        self.parent.rebalance()
    
class AVL(BST):
    def __init__(self):
        BST.__init__(self, AVLnode)
    
    """
    AVL binary search tree implementation.
    Supports insert, find, and delete-min operations in O(lg n) time.
    """
    def insert(self, t):
        """Insert key t into this tree, modifying it in-place."""
        node = BST.insert(self, t)
        node.rebalance()
        self.reroot()
        
    def delete(self):
        node = BST.delete(self)
        node.parent.rebalance()
        self.reroot()
        
        #raise NotImplemented('AVL.delete_min')

def test(args=None):
    bstsize_r.test(args, BSTtype=AVL)

if __name__ == '__main__': test()
