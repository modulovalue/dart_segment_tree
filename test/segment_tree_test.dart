import 'package:segment_tree/segment_tree.dart';
import 'package:test/test.dart';

void main() {
  group("segment tree", () {
    test("smoke test", () {
      final tree = segment_tree_from_list(
        list: [12, 43, 9, -2, 1, 8, 6, 5, 10, 23],
      );
      expect(
        tree.query(start: 1, end: 2),
        9,
      );
      tree.update_node(
        position: 0,
        new_val: -12,
      );
      expect(
        tree.query(start: 1, end: 2),
        -12,
      );
      tree.update_node(
        position: 7,
        new_val: -100,
      );
      expect(
        tree.query(start: 4, end: 9),
        -100,
      );
      expect(
        tree.query(start: 2, end: 6),
        -2,
      );
    });
  });
}
