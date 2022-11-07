// TODO support rmq.
// TODO impl lca via rmq?
// TODO worst case linear time construction possible?
// TODO impl and benchmark lazy updates see: https://codeforces.com/blog/entry/44478
// TODO impl augmentation?
// TODO https://en.algorithmica.org/hpc/data-structures/segment-trees/
// TODO digest: https://cp-algorithms.com/data_structures/segment_tree.html
// TODO digest: https://codeforces.com/blog/entry/18051
// TODO digest: https://codeforces.com/blog/entry/57319
// TODO digest: https://codeforces.com/blog/entry/80031
// TODO digest: https://codeforces.com/blog/entry/15890
// TODO digest: https://codeforces.com/blog/entry/89399
// TODO digest: https://www.geeksforgeeks.org/segment-tree-efficient-implementation/
// TODO digest: https://www.baeldung.com/cs/segment-trees
// TODO digest: https://www.sciencedirect.com/science/article/pii/S2215016119300391
// TODO https://github.com/ice1000/OI-codes/blob/f2df277c9b3f8d67ba9065d15dcb8449186b82f7/codewars/authoring/dart/total_area_covered_by_rectangles.dart
// TODO https://github.com/ice1000/OI-codes/blob/f2df277c9b3f8d67ba9065d15dcb8449186b82f7/codewars/authoring/dart/total_area_covered_by_rectangles_test.dart
// TODO https://www.cs.cmu.edu/~ckingsf/bioinfo-lectures/intervaltrees.pdf
// TODO https://web.stanford.edu/class/archive/cs/cs166/cs166.1146/lectures/00/Extra00.pdf
library _;

import 'dart:math';

// region public
SegmentTree<int> segment_tree_from_list({
  required final List<int> list,
}) {
  final tree = List<int>.generate(
    (2 * pow(2, (log(list.length) / log(2)).ceil()).toInt() - 1) + 1,
        (final i) => 0,
  );
  void _construct_segment_tree({
    required final int start,
    required final int end,
    required final int node_index,
  }) {
    if (start == end) {
      tree[node_index] = list[start];
    } else {
      // Finding index of the midpoint.
      final mid = (start + ((end - start) / 2)).floor();
      // Recursion to find minimum.
      _construct_segment_tree(
        start: start,
        end: mid,
        node_index: 2 * node_index,
      );
      _construct_segment_tree(
        start: mid + 1,
        end: end,
        node_index: 2 * node_index + 1,
      );
      // Finding minimum of the parent from its children.
      tree[node_index] = min<int>(
        tree[2 * node_index],
        tree[2 * node_index + 1],
      );
    }
  }

  _construct_segment_tree(
    start: 0,
    end: list.length - 1,
    node_index: 1,
  );
  return _SegmentTreeImpl(
    size: list.length,
    tree2: tree,
    max_value: 9223372036854775807,
    op: min,
  );
}

abstract class SegmentTree<T> {
  List<T> get tree2;

  int get size;

  T Function(T, T) get op;

  T get max_value;

  void update_node({
    required final int position,
    required final T new_val,
  });

  T query({
    required final int start,
    required final int end,
  });
}
// endregion

// region internal
class _SegmentTreeImpl<T> implements SegmentTree<T> {
  @override
  final List<T> tree2;
  @override
  final int size;
  @override
  final T Function(T, T) op;
  @override
  final T max_value;

  const _SegmentTreeImpl({
  required final this.tree2,
  required final this.size,
  required final this.op,
  required final this.max_value,
});

@override
void update_node({
  required final int position,
  required final T new_val,
}) {
  void update_node({
    required final int tree_start,
    required final int tree_end,
    required final int node_index,
    required final int position,
    required final T new_val,
  }) {
    if (tree_start == tree_end) {
      tree2[node_index] = new_val;
    } else {
      final mid = (tree_start + ((tree_end - tree_start) / 2)).floor();
      if (position < mid) {
        update_node(
          tree_start: tree_start,
          tree_end: mid,
          node_index: 2 * node_index,
          position: position,
          new_val: new_val,
        );
      } else {
        update_node(
          tree_start: mid + 1,
          tree_end: tree_end,
          node_index: 2 * node_index + 1,
          position: position,
          new_val: new_val,
        );
      }
      tree2[node_index] = op(
        tree2[2 * node_index],
        tree2[2 * node_index + 1],
      );
    }
  }

  update_node(
    node_index: 1,
    position: position,
    new_val: new_val,
    tree_start: 0,
    tree_end: size - 1,
  );
}

@override
T query({
  required final int start,
  required final int end,
}) {
  T query_on_segment_tree({
    required final int start,
    required final int end,
    required final int node_index,
    required final int tree_start,
    required final int tree_end,
  }) {
    if (start > end) {
      return max_value;
    } else {
      // Base Case
      if (start == tree_start && end == tree_end) {
        return tree2[node_index];
      } else {
        // Finding the index of midpoint
        final mid = (tree_start + (tree_end - tree_start) / 2).floor();
        return op(
          query_on_segment_tree(
            start: start,
            end: min<int>(end, mid),
            tree_start: tree_start,
            tree_end: mid,
            node_index: 2 * node_index,
          ),
          query_on_segment_tree(
            start: max<int>(start, mid + 1),
            end: end,
            tree_start: mid + 1,
            tree_end: tree_end,
            node_index: 2 * node_index + 1,
          ),
        );
      }
    }
  }

  return query_on_segment_tree(
    start: start,
    end: end,
    node_index: 1,
    tree_start: 0,
    tree_end: size - 1,
  );
}
}
// endregion
