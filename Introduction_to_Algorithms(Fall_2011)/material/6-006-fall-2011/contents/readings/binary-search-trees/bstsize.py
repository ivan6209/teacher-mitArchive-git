import bst

def size(node):
    if node is None:
        return 0
    else:
        return node.size

def update_size(node):
    node.size = size(node.left) + size(node.right) + 1

class BST(bst.BST):
    """
Simple binary search tree implementation, augmented with subtree sizes.
This BST supports insert, find, and delete-min operations.
Each tree contains some (possibly 0) BSTnode objects, representing nodes,
and a pointer to the root.
"""

    def __init__(self):
        self.root = None

    def insert(self, t):
        """Insert key t into this BST, modifying it in-place."""
        node = bst.BST.insert(self, t)
        while node is not None:
            update_size(node)
            node = node.parent

    def delete_min(self):
        """Delete the minimum key (and return the old node containing it)."""
        deleted, parent = bst.BST.delete_min(self)
        node = parent
        while node is not None:
            update_size(node)
            node = node.parent
        return deleted, parent

def test(args=None):
    bst.test(args, BSTtype=BST)

if __name__ == '__main__': test()
