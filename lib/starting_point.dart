import 'dart:io';
import 'dart:math';

// TODO migrate instructions to code.
// TODO migrate main to unit test.
/// Enter number of elements:
/// 10
/// Enter array of numbers:
/// 12 43 9 -2 1 8 6 5 10 23
/// Enter number of queries:
/// 6
/// Enter queries:
/// Enter 1 to retrieve minimum in a range or 2 to update a value:
/// 1
/// Enter corresponding query:
/// 1 2
/// 9    (Output)
/// Enter 1 to retrieve minimum in a range or 2 to update a value:
/// 2
/// Enter corresponding query:
/// 0 -12
/// Enter 1 to retrieve minimum in a range or 2 to update a value:
/// 1
/// Enter corresponding query:
/// 1 2
/// -12    (Output)
/// Enter 1 to retrieve minimum in a range or 2 to update a value:
/// 2
/// Enter corresponding query:
/// 7 -100
/// Enter 1 to retrieve minimum in a range or 2 to update a value:
/// 1
/// Enter corresponding query:
/// 4 9
/// -100  (Output)
/// Enter 1 to retrieve minimum in a range or 2 to update a value:
/// 1
/// Enter corresponding query:
/// 2 6
/// -2   (Output)
void main() {
  // Taking input of number of array elements.
  print("Enter number of elements: ");
  String? input = stdin.readLineSync();
  final n = int.parse(
    input.toString(),
  );
  // Taking input of the number array (num[i]).
  print("Enter array of numbers:");
  input = stdin.readLineSync();
  List<String> lis = input!.split(' ');
  final numbers = lis
      .map(
        int.parse,
      )
      .toList();
  // Calculating the depth of the possible binary tree.
  final depth = _log_to_base_2(n).ceil();
  // Finding the maximum number of nodes in the binary tree.
  final num_nodes = 2 * pow(2, depth).toInt() - 1;
  // Initializing the Segment tree.
  final tree = List<int>.generate(
    num_nodes + 1,
    (final i) => 0,
  );
  // Constructing the Segment Tree.
  _construct_segment_tree(
    tree: tree,
    numbers: numbers,
    start: 0,
    end: n - 1,
    node_index: 1,
  );
  // Taking input of number of queries.
  print("Enter number of queries: ");
  input = stdin.readLineSync();
  final q = int.parse(input!);
  int flag;
  // Taking input of queries.
  print("Enter queries: ");
  for (int i = 0; i < q; i++) {
    print("Enter 1 to retrieve minimum in a range or 2 to update a value: ");
    input = stdin.readLineSync();
    flag = int.parse(input!);
    print("Enter corresponding query: ");
    input = stdin.readLineSync();
    lis = input!.split(' ');
    final queries = lis
        .map(
          int.parse,
        )
        .toList();
    if (flag == 2) {
      numbers[queries[0]] = queries[1];
      _update_node(
        tree: tree,
        tree_start: 0,
        tree_end: n - 1,
        node_index: 1,
        position: queries[0],
        new_val: queries[1],
      );
    } else {
      // Printing output of each query.
      print(
        _query_on_segment_tree(
          tree: tree,
          start: queries[0],
          end: queries[1],
          tree_start: 0,
          tree_end: n - 1,
          node_index: 1,
        ),
      );
    }
  }
}

// TODO get rid of recursion?
// TODO compare to fenwick.
/// Function to update value at a particular position in the tree.
void _update_node({
  required final List<int> tree,
  required final int tree_start,
  required final int tree_end,
  required final int node_index,
  required final int position,
  required final int new_val,
}) {
  if (tree_start == tree_end) {
    tree[node_index] = new_val;
  } else {
    final int mid = (tree_start + ((tree_end - tree_start) / 2)).floor();
    if (position < mid) {
      _update_node(
        tree: tree,
        tree_start: tree_start,
        tree_end: mid,
        node_index: 2 * node_index,
        position: position,
        new_val: new_val,
      );
    } else {
      _update_node(
        tree: tree,
        tree_start: mid + 1,
        tree_end: tree_end,
        node_index: 2 * node_index + 1,
        position: position,
        new_val: new_val,
      );
    }
    tree[node_index] = min<int>(
      tree[2 * node_index],
      tree[2 * node_index + 1],
    );
  }
}

// TODO get rid of recursion?
// TODO compare to fenwick.
/// Function to query on a Segment Tree.
int _query_on_segment_tree({
  required final List<int> tree,
  required final int start,
  required final int end,
  required final int tree_start,
  required final int tree_end,
  required final int node_index,
}) {
  if (start > end) {
    return _int64_max_value;
  } else {
    // Base Case
    if (start == tree_start && end == tree_end) {
      return tree[node_index];
    } else {
      // Finding the index of midpoint
      final mid = (tree_start + (tree_end - tree_start) / 2).floor();
      return min<int>(
        _query_on_segment_tree(
          tree: tree,
          start: start,
          end: min<int>(end, mid),
          tree_start: tree_start,
          tree_end: mid,
          node_index: 2 * node_index,
        ),
        _query_on_segment_tree(
          tree: tree,
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

// TODO get rid of recursion?
// TODO compare to fenwick.
/// Function to construct the Segment Tree.
void _construct_segment_tree({
  required final List<int> tree,
  required final List<int> numbers,
  required final int start,
  required final int end,
  required final int node_index,
}) {
  if (start == end) {
    tree[node_index] = numbers[start];
  } else {
    // Finding index of the midpoint.
    final mid = (start + ((end - start) / 2)).floor();
    // Recursion to find minimum.
    _construct_segment_tree(
      tree: tree,
      numbers: numbers,
      start: start,
      end: mid,
      node_index: 2 * node_index,
    );
    _construct_segment_tree(
      tree: tree,
      numbers: numbers,
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

/// Maximum range of int of 64 bits.
const int _int64_max_value = 9223372036854775807;

// TODO use msb?
/// Function to find logarithm to base 2.
double _log_to_base_2(
  final int n,
) {
  return log(n) / log(2);
}
