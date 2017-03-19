#B Corfman
#This has everything except deleting an entire node implemented (you can split and truncate nodes with deletes, though)

import sys
import os

class Node: #Node methods should all be called by Tree methods
    def __init__(self, tree, p, side, interval):
        self.parent = p
        setattr(p, side, self) #side is either left, right, or root
        self.left = None
        self.right = None
        self.value = interval
        self.depth = p.depth + 1
        tree.splay(self)
    def print(self):
        if self.left != None:
            self.left.print()
        sys.stdout.write(str(self.depth) + " [" + str(self.value[0]) +", "+ str(self.value[1]) + ")\n")
        if self.right != None:
            self.right.print()
    def zig(self, p, nSide, oSide):
        t1 = getattr(self, oSide)
        self.move(p.parent, nSide, 'root')
        p.move(self, None, oSide)
        if t1 != None:
            t1.move(p, None, nSide)
        else:
            setattr(p, nSide, None)
        self.depth -= 1
        self.correctDepth()
    def zigzig(self, p, g, nSide, tSide, oSide):
        t1 = getattr(self, oSide)
        t2 = getattr(p, oSide)
        self.move(g.parent, nSide, tSide)
        p.move(self, nSide, oSide)
        g.move(p, None, oSide)
        if t1 != None:
            t1.move(p, None, nSide)
        else:
            setattr(p, nSide, None)
        if t2 != None:
            t2.move(g, None, nSide)
        else:
            setattr(g, nSide, None)
        self.depth -= 2
        self.correctDepth()
    def zigzag(self, p, g, nSide, pSide, tSide):
        t1 = getattr(self, nSide)
        t2 = getattr(self, pSide)
        self.move(g.parent, nSide, tSide) #move node to top
        g.move(self, None, nSide) #move g to nSide of node
        p.move(self, pSide, pSide) #move p to pSide of node
        if t1 != None:
            t1.move(p, None, nSide) #move t1 to nSide of p
        else:
            setattr(p, nSide, None)
        if t2 != None:
            t2.move(g, None, pSide) #move t2 to pSide of g
        else:
            setattr(p, nSide, None)
        self.depth -= 2
        self.correctDepth()
    def move(self, p, oldSide, newSide): #reposition node so it's on newSide of p, delete old parent's reference.(called only by zig, zigzig, and zigzag)
        temp = getattr(p, newSide)  #(g, p, None, right)
        if oldSide != None: #if a parent points to this node (some nodes are orphaned mid-splay):
            setattr(self.parent, oldSide, None) #remove the parent's reference to the node
        if temp != None:
            temp.parent = None #sever p.newside's reference to p
        self.parent = p
        setattr(p, newSide, self) #point p's newSide reference to node
    def remove(self, tree, side): #deletes an entire node and splays the deepest affected node. Side is the side of p deleted node was on.
        return "removing whole node not implemented\n"
##        p = self.parent #for ease of reading
##        succ = self.succ()#find inorder successor
##        if self.right != None: #if right node exists
##            if self.right != None: #and left node exists
##                pass
##            else: #node has one chil
##                self.left.move(p, left, side)
##                
##        elif self.right != None: #elif right node exists, move it up
##            setattr(p, side, self.right)
##            if self.left != None:
##                pass
##        else: #node has no children
##            setattr(p, side, None)
##            tree.splay(p)
##            return None #!!!---need to put string to print here---!!!
        #p.side will contain a node at this point
        temp = getattr(p, side)
        temp.parent = p #node being moved up changes parent reference
        if (getattr(p, side)).right != None: #if moved up node has a right child
            tree.splay((getattr(p, side)).right) #splay it
        elif (getattr(p, side)).left != None: #elif moved up node has a left child
            tree.splay((getattr(p, side)).left) #splay it
        else: #moved up node has no children
            tree.splay(getattr(p, side))
        #all reference to self should now be gone; it will be garbage collected
    def trunc(self, toDel, side, tree): #pred: toDel definitely overlaps with node (self is node, toDel is interval, side is which side self is on)
        if self.value[0] >= toDel[0]: #if toDel starts at or before start of node
            if self.value[1] <= toDel[1]: #if it also ends at or after end of node
                return self.remove(tree, side) #remove the entire node, splay deepest affected #########NOT IMPLEMENTED#################
            else: #it must end before the end of the node
                ret = str(self.depth) + " truncated " + str(self.value[0]) + " " + str(self.value[1]) + "\n"
                self.value = (toDel[1], self.value[1]) #modify the interval
                tree.splay(self) #splay the smaller node
                return ret
        else: #toDel must start after start of node
            if self.value[1] <= toDel[1]: #if it also ends at or after end of node
                ret = str(self.depth) + " truncated " + str(self.value[0]) + " " + str(self.value[1]) + "\n"
                self.value = (self.value[0], toDel[0]) #modify the interval
                tree.splay(self) #splay the smaller node
                return ret
            else: #it must be contained within the node
                rTop = self.value[1]
                self.value = (self.value[0], toDel[0]) #truncate left interval
                sys.stdout.write(str(self.depth) + " truncated " + str(self.value[0]) + " " + str(rTop) + "\n")
                return t.insert(toDel[1], rTop) #insert new node. This will also splay it.
    def split(self, toDel, tree): #pred: toDel is fully contained in node and doesn't overlap either end
        nl = Node(self.parent, side, (self.value[0], toDel[0])) #leave left side in place
        n2 = tree.insert(toDel[1], self.value[1]) #insert right side, which will then splay it.
    def correctDepth(self):
        if self.left != None:
            self.left.depth = self.depth + 1
            self.left.correctDepth()
        if self.right != None:
            self.right.depth = self.depth +1
            self.right.correctDepth()
        return
    def find(self, interval, side, tree): #returns a (parent, side, exists?) triple
        if self.value[0] > interval[1]: #interval is strictly less than current node
            side = 'left'
        elif self.value[1] < interval[0]: #interval is strictly more than current node
            side = 'right'
        else:
            return (self, side, True) #interval overlaps current node. return it.
        if getattr(self, side) == None: #if we've reached an empty node, we should return the node above it and the side
            return (self, side, False)
        return (getattr(self, side)).find(interval, side, tree) #otherwise, recur

class Tree:
    def __init__(self):
        self.root = None
        self.count = 0
        self.depth = -1 #above the root. will cause root depth to be zero.
    def print(self):
        self.root.print()
    def insert(self, x, y): #insert a node into the tree
        if self.root == None:
            Node(self, self, 'root', (x, y))
            return "0 added "+str(x)+" "+str(y) + "\n"
        pos = self.root.find((x,y), 'root', self) #Find the position for the node.
        node = pos[0] #parent of new node, or node that was overlapped
        if pos[2]: #did it overlap?
            if node.value[0] > x: #if overlap's bottom value is greater than the interval's bottom
                ret = str(node.depth)+" added " + str(x) + " " + str(y) + "\n"
                node.value = (x, node.value[1]) #extend the bottom of the node. splay.
                self.splay(node)
                return ret
            elif node.value[1] < y: #if overlap's top value is less than the interval's top
                ret = str(node.depth)+" added " + str(x) + " " + str(y) + "\n"
                node.value = (node.value[0], y) #extend the top of the node. splay.
                self.splay(node)
                return ret
            else: #if overlap entirely contains interval, just splay.
                ret = str(node.depth)+" not added " + str(x) + " " + str(y) + "\n"
                self.splay(node)
                return ret
        else:
            Node(self, pos[0], pos[1], (x, y))
            return str(node.depth)+" added " + str(x) + " " + str(y) + "\n"
    def remove(self, x, y):
        if self.root == None:
            return "0 not found "+str(x)+" "+str(y) + "\n test\n"
        pos = self.root.find((x,y), 'root', self)
        node = pos[0]
        if pos[2]: #did it overlap?
            return node.trunc((x,y), pos[1], self) #truncate, split, or delete the overlapped node. returns the print statement
        ret = str(node.depth + 1)+ " not found " + str(x) + " " + str(y) + "\n"
        self.splay(node) #otherwise we splay the last touched node and delete nothing
        return ret
    def splay(self, node):
        if type(node.parent) == Tree:
            return
        if node.parent.left is node:
            nodeSide = 'left'
            oSide = 'right'
        else:
            nodeSide = 'right'
            oSide = 'left'
        if type(node.parent.parent) == Tree:
            node.zig(node.parent, nodeSide, oSide)
            return
        #-------determine direction/whether to zig zig or zig zag
        if type(node.parent.parent.parent) == Tree:
            topSide = 'root'
        elif node.parent.parent.parent.left is node.parent.parent:
            topSide = 'left'
        else:
            topSide = 'right'
        if node.parent.parent.left is node.parent:
            pSide = 'left'
        else:
            pSide = 'right'
        if nodeSide == pSide:
            node.zigzig(node.parent, node.parent.parent, nodeSide, topSide, oSide)
        else:
            node.zigzag(node.parent, node.parent.parent, nodeSide, pSide, topSide)
        self.splay(node) #keep splaying until it's at the root
        return
t = Tree()
def add(x,y):
    sys.stdout.write(t.insert(x,y))
def remove(x,y):
    sys.stdout.write(t.remove(x,y))

if not os.isatty(0):
    for line in sys.stdin.readlines():
        call = line.split()
        exec(call[0]+"("+call[1]+","+call[2]+")")
t.print()
