// import 'dart:io';
//
// void main(
//   final List<String> args,
// ) {
//   final int numberOfInputs = int.parse(stdin.readLineSync());
//   for (int i = 0; i < numberOfInputs; i++) {
//     final line = stdin.readLineSync().split(' ').map((final s) => int.parse(s)).toList();
//     final int inp_t = line[0];
//     final int inp_n = line[1];
//     final int inp_a = line[2];
//     final int inp_b = line[3];
//     int inp_x = line[4];
//     stderr.writeln('#######################');
//     stderr.writeln('$i / $numberOfInputs');
//     stderr.writeln('#######################');
//     final treeMin = SegmentTree.min(List.generate(inp_n, (final _) => 0));
//     //var treeMax = SegmentTree.max(List.generate(inp_n, (_) => 0));
//     //var treeSum = SegmentTree.sum(List.generate(inp_n, (_) => 0));
//     final resultsMin = List<int>();
//     final resultsMax = List<int>();
//     final resultsSum = List<int>();
//     for (int i = 0; i < inp_t; i++) {
//       if (i % 1000 == 0) {
//         stderr.writeln('$i / $inp_t');
//       }
//       final Input realInput = generate_input(inp_n, inp_a, inp_b, inp_x);
//       inp_x = realInput.x;
//       switch (realInput.t) {
//         case 0:
//           resultsMin.add(treeMin.queryOnInterval(realInput.b, realInput.e));
//           //resultsMax.add(treeMax.queryOnInterval(realInput.b, realInput.e));
//           //resultsSum.add(treeSum.queryOnInterval(realInput.b, realInput.e));
//           break;
//         case 1:
//           treeMin.addOnIntervalLazy(realInput.b, realInput.e, realInput.a);
//           //treeMax.addOnIntervalLazy(realInput.b, realInput.e, realInput.a);
//           //treeSum.addOnIntervalLazy(realInput.b, realInput.e, realInput.a);
//           break;
//         case 2:
//           treeMin.setOnIntervalLazy(realInput.b, realInput.e, realInput.a);
//           //treeMax.setOnIntervalLazy(realInput.b, realInput.e, realInput.a);
//           //treeSum.setOnIntervalLazy(realInput.b, realInput.e, realInput.a);
//           break;
//       }
//     }
//     int minXor = 0;
//     int maxXor = 0;
//     int sumXor = 0;
//     for (final number in resultsMin) {
//       minXor ^= number;
//     }
//     for (final number in resultsMax) {
//       maxXor ^= number;
//     }
//     for (final number in resultsSum) {
//       sumXor ^= number;
//     }
//     print(minXor);
//     print(maxXor);
//     print(sumXor);
//   }
// }
//
// Input generate_input(
//   final int n,
//   final int a,
//   final int b,
//   final int x0,
// ) {
//   int x = nextInt(x0, a, b);
//   final t = x % 3;
//   x = nextInt(x, a, b);
//   int nextB = x % n;
//   x = nextInt(x, a, b);
//   int e = x % n;
//   if (nextB > e) {
//     final c = nextB;
//     nextB = e;
//     e = c;
//   }
//   x = nextInt(x, a, b);
//   final int nextA = x % n;
//   return Input(t, nextB, e, nextA, x);
// }
//
// int nextInt(
//   final int x,
//   final int a,
//   final int b,
// ) {
//   return (x * a + b) % 1000000007;
// }
//
// class Input {
//   final int t;
//   final int b;
//   final int e;
//   final int a;
//   final int x;
//
//   Input(
//     final this.t,
//     final this.b,
//     final this.e,
//     final this.a,
//     final this.x,
//   );
// }
