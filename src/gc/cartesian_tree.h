#ifndef SRC_GC_CARTESIAN_TREE_H_
#define SRC_GC_CARTESIAN_TREE_H_

#include <cstddef>
#include <cstdint>
#include <fstream>

#include "gc/deque.h"

#define DEBUG_CARTESIAN_TREE __MRT_DEBUG_COND_FALSE
#ifdef DEBUG_CARTESIAN_TREE
// #define CTREE_ASSERT(cond, msg) __MRT_ASSERT(cond, msg)
#define CTREE_ASSERT(cond, msg) (void(0))
#define CTREE_CHECK_PARENT_AND_LCHILD(n) CheckParentAndLeftChild(n)
#define CTREE_CHECK_PARENT_AND_RCHILD(n) CheckParentAndRightChild(n)
#else
#define CTREE_ASSERT(cond, msg) (void(0))
#define CTREE_CHECK_PARENT_AND_LCHILD(n) (void(0))
#define CTREE_CHECK_PARENT_AND_RCHILD(n) (void(0))
#endif

// This is an implementation of a Cartesian tree.
// This can be used in arbitrary-sized, free-list allocation algorithm.
// The use of this tree and the algorithm is inspired by
// R. Jones, A. Hosking, E. Moss. The garbage collection handbook:
// the art of automatic memory management. Chapman and Hall/CRC, 2016.
// This implementation is all hand-written, in which process the
// author might have referenced some online tutorials, notably
// https://www.geeksforgeeks.org/ This data structure doesn't guarantee the
// multi-thread safety, so the external invoker should take some policy to avoid
// competition problems.
namespace ROS_GC {
template <class A = std::uintptr_t, class S = std::size_t>
class CartesianTree {
 public:
  CartesianTree() : root(nullptr) {}

  ~CartesianTree() {
    DeleteFrom(root);
    DeleteMemMap();
  }

  void Init(size_t mapSize) {
    // when used to manage free page regions, we count how many nodes we need at
    // max
    size_t pageCount = ALLOCUTIL_PAGE_RND_UP(mapSize) / ALLOCUTIL_PAGE_SIZE;
    size_t regionCount =
        (pageCount >> 1) + 1;  // at most we need this many regions
    // calculate how much we need for native allocation
    // we might need some extra space for some temporaries, so set aside another
    // 7 slots
    // size_t nativeSize =
    //     (regionCount + 7) * AllocUtilRndUp(sizeof(Node), alignof(Node));
    // NativeAlloc::nal.Init(ALLOCUTIL_PAGE_RND_UP(nativeSize));
    // calculate how much we need for the deque temporary
    size_t dequeSize = regionCount * sizeof(void *);
    sud.Init(ALLOCUTIL_PAGE_RND_UP(dequeSize));
  }

  inline bool Empty() { return root == nullptr; }
  inline S Top() { return root ? root->key2 : 0U; }

  // insert a node to the tree, if we find connecting nodes, we merge them
  // (the non-merging insertion is not allowed)
  // true when insertion succeeded, false otherwise
  // if [a, a + s) clashes with existing node, it fails
  // if s is 0U, it always fails
  bool MergeInsert(A a, S s) {
    if (root == nullptr) {
      root = new Node(a, s);
      //__MRT_ASSERT(root != nullptr, "fail to allocate a new node");
      return true;
    }

    if (s == 0) {
      return false;
    }

    return MergeInsertInternal(a, s);
  }

  // find a node with a key2 of at least s, store its key1 into a
  // split/remove this node if found
  // return false if nothing is found or s is 0U
  bool Find(A &a, S s) {
    if (root == nullptr || s == 0) {
      return false;
    }

    return Find(root, root, a, s);
  }

  struct CartesianTreeNode {
    A key1;
    S key2;
    CartesianTreeNode *l;
    CartesianTreeNode *r;

    CartesianTreeNode(A k1, S k2)
        : key1(k1), key2(k2), l(nullptr), r(nullptr) {}
    ~CartesianTreeNode() {
      l = nullptr;
      r = nullptr;
    }

    /*static void *operator new(std::size_t sz __attribute__((unused))) {
      return NativeAlloc::Allocate();
    }

    static void operator delete(void *ptr) {
      NativeAlloc::Deallocate(ptr);
    }*/

    // alias of key1: in PageManager, key1 is the first page's index of a region
    inline A &Idx() { return key1; }

    // alias of key2: in PageManager, key2 is the page count of a region
    inline S &Cnt() { return key2; }
  };

  class Iterator {
   public:
    Iterator(CartesianTree &tree) : ct(tree) {
      if (ct.traversalSud == nullptr) {
        ct.traversalSud = new SingleUseDeque<Node *>();
        ct.traversalSud->Init(ct.sud.GetMemMap());
      }
      tq.SetSud(*ct.traversalSud);
      if (ct.root != nullptr) {
        tq.Push(ct.root);
      }
    }
    ~Iterator() = default;
    // we provide a preorder traversal method (preorder lets the largest region
    // visited first):
    inline CartesianTreeNode *Next() {
      if (tq.Empty()) {
        return nullptr;
      }
      Node *front = tq.Front();
      if (front->r != nullptr) {
        tq.Push(front->r);
      }
      if (front->l != nullptr) {
        tq.Push(front->l);
      }
      tq.PopFront();
      return front;
    }

   private:
    CartesianTree &ct;
    LocalDeque<CartesianTreeNode *> tq;
  };

  size_t DeleteNodeIfSatisfy(
      const std::function<bool(const CartesianTreeNode *)> &callback) {
    LocalDeque<CartesianTreeNode *> stack;
    auto **cur_node = &root;
    size_t cnt = 0;
    while (*cur_node || !stack.Empty()) {
      while (*cur_node) {
        // visit root
        auto *p = *cur_node;
        while (p && callback(p)) {
          p = RemoveNode(p);
          cnt++;
        }
        *cur_node = p;
        if (!p) break;
        stack.Push(p);
        cur_node = &p->l;
      }
      if (!stack.Empty()) {
        auto *p = stack.Top();
        stack.Pop();
        cur_node = &(p->r);
      }
    }
    return cnt;
  }

  using Node = CartesianTreeNode;
  // using NativeAlloc = NativeAllocLite<sizeof(Node), alignof(Node)>;

 private:
  Node *root;
  SingleUseDeque<Node **> sud;
  SingleUseDeque<Node *> *traversalSud = nullptr;

  // used by destructor to resursively delete the tree
  void DeleteFrom(Node *n) {
    if (n == nullptr) {
      return;
    }
    DeleteFrom(n->l);
    DeleteFrom(n->r);
    delete n;
    n = nullptr;
  }

  void DeleteMemMap() {
    if (traversalSud != nullptr) {
      traversalSud->Destruct(/*deleteMemMap=*/false);
      delete traversalSud;
      traversalSud = nullptr;
    }
    sud.Destruct();
  }

  // the following function tries to merge new node (a, s) with n
  enum MergeResult {
    kSuccess = 0,  // successfully merged with the node n
    kMiss,         // the new node (a, s) is not connected to n, cannot merge
    kError         // error, operation aborted
  };
  MergeResult MergeAt(Node *n, A a, S s) {
    A m = a + s;

    // try to merge the inserted node to the right of n
    if (a == n->key1 + n->key2) {
      Node *last = n;
      Node *next = n->r;
      // also, find a connected node to the right of the inserted node
      while (next != nullptr) {
        if (next->key1 == m) {
          if (next->l != nullptr) {
            // CTREE_ASSERT(false, "merging failed case 1");
            return kError;
          }
          break;
        } else if (next->key1 < m) {
          // CTREE_ASSERT(false, "merging failed case 2");
          return kError;
        } else {
          last = next;
          next = next->l;
        }
      }
      n->key2 += s;
      if (next != nullptr) {
        n->key2 += next->key2;
        if (last == n) {
          last->r = RemoveNode(next);
        } else {
          last->l = RemoveNode(next);
        }
      }
      CTREE_CHECK_PARENT_AND_RCHILD(n);
      return kSuccess;
    }

    // try to merge the inserted node to the left of n
    if (m == n->key1) {
      Node *last = n;
      Node *next = n->l;
      // also, find a connected node to the left of the inserted node
      while (next != nullptr) {
        if (next->key1 + next->key2 == a) {
          if (next->r != nullptr) {
            CTREE_ASSERT(false, "merging failed case 3");
            return kError;
          }
          break;
        } else if (next->key1 + next->key2 > a) {
          CTREE_ASSERT(false, "merging failed case 4");
          return kError;
        } else {
          last = next;
          next = next->r;
        }
      }
      n->key1 = a;
      n->key2 += s;
      if (next != nullptr) {
        n->key1 = next->key1;
        n->key2 += next->key2;
        if (last == n) {
          last->l = RemoveNode(next);
        } else {
          last->r = RemoveNode(next);
        }
      }
      CTREE_CHECK_PARENT_AND_LCHILD(n);
      return kSuccess;
    }

    return kMiss;
  }

  // see the public MergeInsert()
  inline bool MergeInsertInternal(A a, S s) {
    //     +-------------+       +--------------+
    //     | parent node |  n--> | current node |
    //     |             |       |              |
    // pn ---> Node* l; -------> |              |
    //     |   Node* r;  |       |              |
    //     +-------------+       +--------------+
    // suppose current node is parent node's left child, then
    // n points to the current node,
    // pn points to the 'l' field in the parent node
    Node *n = root;     // root is current node
    Node **pn = &root;  // pointer to the 'root' field in this tree
    // stack of pn recording how to go from root to the current node
    LocalDeque<Node **> pnStack(sud);  // this uses another deque as container
    A m = a + s;

    // this loop insert the new node (a, s) at the proper place
    do {
      if (n == nullptr) {
        n = new Node(a, s);
        //__MRT_ASSERT(n != nullptr, "fail to allocate a new node");
        *pn = n;
        break;
      }
      MergeResult res = MergeAt(n, a, s);
      if (res == kSuccess) {
        break;
      } else if (UNLIKELY(res == kError)) {
        return false;
      }
      // kMiss: (a, s) cannot be connected to n
      if (m < n->Idx()) {
        // should insert into left subtree
        pnStack.Push(pn);
        pn = &(n->l);
        n = n->l;
      } else if (a > n->Idx() + n->Cnt()) {
        // should insert into right subtree
        pnStack.Push(pn);
        pn = &(n->r);
        n = n->r;
      } else {
        // something clashes
        CTREE_ASSERT(false, "merge insertion failed");
        return false;
      }
    } while (true);

    // this loop bubbles the inserted node up the tree to satisfy heap property
    while (!pnStack.Empty()) {
      pn = pnStack.Top();
      pnStack.Pop();
      n = *pn;
      CTREE_ASSERT(n, "merge insertion bubbling failed case 1");
      if (m < n->Idx()) {
        // (a, s) was inserted into n's left subtree, do rotate l, if needed
        if (n->Cnt() < n->l->Cnt()) {
          *pn = RotateLeft(n);
          CTREE_CHECK_PARENT_AND_RCHILD(*pn);
        } else {
          break;
        }
      } else if (a > n->Idx() + n->Cnt()) {
        // (a, s) was inserted into n's right subtree, do rotate r, if needed
        if (n->Cnt() < n->r->Cnt()) {
          *pn = RotateRight(n);
          CTREE_CHECK_PARENT_AND_LCHILD(*pn);
        } else {
          break;
        }
      } else {
        CTREE_ASSERT(false, "merge insertion bubbling failed case 2");
        return false;
      }
    }

    return true;
  }

  // rotate the node and its left child to maintain heap property
  inline Node *RotateLeft(Node *n) {
    Node *tmp = n->l;
    n->l = tmp->r;
    tmp->r = n;
    return tmp;
  }
  // rotate the node and its right child to maintain heap property
  inline Node *RotateRight(Node *n) {
    Node *tmp = n->r;
    n->r = tmp->l;
    tmp->l = n;
    return tmp;
  }

  // see the public find()
  // balance could be a problem
  bool Find(Node *&pn, Node *n, A &a, S s) {
    if (n->key2 < s) {
      return false;
    }

    if (n->l != nullptr) {
      // leftmost node preference
      // this makes left tree significantly shorter
      CTREE_CHECK_PARENT_AND_LCHILD(n);
      if (Find(n->l, n->l, a, s)) {
        return true;
      }
    }

    a = n->key1;
    n->key1 += s;
    n->key2 -= s;
    if (n->key2) {
      pn = LowerNode(n);
    } else {
      pn = RemoveNode(n);
    }
    CTREE_CHECK_PARENT_AND_LCHILD(pn);
    CTREE_CHECK_PARENT_AND_RCHILD(pn);
    return true;
  }

  // move a node down in the tree below to maintain heap property
  Node *LowerNode(Node *n) {
    CTREE_ASSERT(n, "lowering node failed");
    Node *tmp = nullptr;

    if (n->l != nullptr && n->l->key2 > n->key2) {
      // this makes right tree slightly taller
      if (n->r != nullptr && n->r->key2 > n->l->key2) {
        tmp = RotateRight(n);
        tmp->l = LowerNode(tmp->l);
        CTREE_CHECK_PARENT_AND_LCHILD(tmp);
        return tmp;
      } else {
        tmp = RotateLeft(n);
        tmp->r = LowerNode(tmp->r);
        CTREE_CHECK_PARENT_AND_RCHILD(tmp);
        return tmp;
      }
    }

    if (n->r && n->r->key2 > n->key2) {
      tmp = RotateRight(n);
      tmp->l = LowerNode(tmp->l);
      CTREE_CHECK_PARENT_AND_LCHILD(tmp);
      return tmp;
    }

    return n;
  }

  // remove a node and adjust the tree below
  // inline
  Node *RemoveNode(Node *n) {
    CTREE_ASSERT(n, "removing node failed");
    if (n->l == nullptr && n->r == nullptr) {
      delete n;
      n = nullptr;
      return nullptr;
    }
    Node *tmp = nullptr;
    if (n->l == nullptr) {
      tmp = RotateRight(n);
      tmp->l = RemoveNode(tmp->l);
      CTREE_CHECK_PARENT_AND_LCHILD(tmp);
      return tmp;
    } else {
      if (n->r == nullptr) {
        tmp = RotateLeft(n);
        tmp->r = RemoveNode(tmp->r);
        CTREE_CHECK_PARENT_AND_RCHILD(tmp);
        return tmp;
      } else {
        // this makes right tree slightly taller
        if (n->l->key2 < n->r->key2) {
          tmp = RotateRight(n);
          tmp->l = RemoveNode(tmp->l);
          CTREE_CHECK_PARENT_AND_LCHILD(tmp);
          return tmp;
        } else {
          tmp = RotateLeft(n);
          tmp->r = RemoveNode(tmp->r);
          CTREE_CHECK_PARENT_AND_RCHILD(tmp);
          return tmp;
        }
      }
    }
  }

  inline void CheckParentAndLeftChild(const Node *n) {
#ifdef DEBUG_CARTESIAN_TREE
    if (n != nullptr) {
      const Node *l = n->l;
      if (l != nullptr) {
        CTREE_ASSERT((n->key1 > (l->key1 + l->key2)),
                     "left child overlapped with parent");
        CTREE_ASSERT((n->key2 >= l->key2), "left child bigger than parent");
      }
    }
#else
    (void)n;
#endif
  }
  inline void CheckParentAndRightChild(const Node *n) {
#ifdef DEBUG_CARTESIAN_TREE
    if (n != nullptr) {
      const Node *r = n->r;
      if (r != nullptr) {
        CTREE_ASSERT(((n->key1 + n->key2) < r->key1),
                     "right child overlapped with parent");
        CTREE_ASSERT((n->key2 >= r->key2), "right child bigger than parent");
      }
    }
#else
    (void)n;
#endif
  }
};
}  // namespace ROS_GC
#endif
