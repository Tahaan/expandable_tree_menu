import 'package:expandable_tree_menu/expandable_tree_menu.dart';
import 'package:expandable_tree_menu/src/defaults.dart';
import 'package:expandable_tree_menu/src/nodes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final nodeListWithSubNodes = [
  TreeNode('Main Node #1', subNodes: [
    TreeNode('Main 1 Node #1'),
    TreeNode('Main 1 Node #2'),
  ]),
  TreeNode('Main Node #2', subNodes: [
    TreeNode('Main 2 Node #1'),
    TreeNode('Main 2 Node #2',
    subNodes: [
      TreeNode('Node 2-2-1'),
      TreeNode('Node 2-2-2'),
    ]),
  ]),
];

final _et = ExpandableTree<String>(
  onSelect: (s) {},
  nodeBuilder: (cntext, nodeValue) {
    return Container();
  },
  nodes: [],
);


Type typeOf<T>() => T;


void main() {
  testWidgets('Test With Empty List of Nodes', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ExpandableTree<dynamic>(
          nodes: [],
          nodeBuilder: (context, node) {
            return Text(node.runtimeType.toString());
          },
        ),
      ),
    );

    // debugDumpApp();

    final subItem = find.byType(ExpandableMenuLeafNode);
    expect(subItem, findsNothing);

    final menuFinder = find.byType(ExpandableTree);
    expect(menuFinder, findsOneWidget);


  });

  testWidgets('Test With 3 simple String nodes', (WidgetTester tester) async {
    final nodeList = [
      TreeNode<String>('Node #1'),
      TreeNode<String>('Node #2'),
      TreeNode<String>('Node #3'),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: ExpandableTree(
          nodes: nodeList,
          nodeBuilder: (context, itemValue) {
            return Text(itemValue.toString());
          },
        ),
      ),
    );

    await tester.pump();

    final nodes = find.byType(ExpandableMenuLeafNode);
    expect(nodes, findsNWidgets(3));

    final menuFinder = find.byType(typeOf<ExpandableTree<String>>());
    expect(menuFinder, findsOneWidget);
  });

  testWidgets('Test With sub-nodes',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ExpandableTree(
          nodes: nodeListWithSubNodes,
          nodeBuilder: (context, itemValue) {
            return Text(itemValue.toString());
          },
        ),
      ),
    );

    // await tester.pump();

    // debugDumpApp();

    final text = find.text('Main Node #1');
    expect(text, findsOneWidget);

    final subItem = find.byType(ExpandableMenuLeafNode);
    expect(subItem, findsNothing);

    final subItemText = find.text('Main 1 Node #2');
    expect(subItemText, findsNothing);

    final menuFinder = find.byType(typeOf<ExpandableTree<String>>());
    expect(menuFinder, findsOneWidget);

    final subMenuFinder = find.byType(typeOf<CustomSubTreeWrapper<String>>());
    expect(subMenuFinder, findsNWidgets(2));

    var clickThis = find.byIcon(Icons.expand_more);
    expect(clickThis, findsNWidgets(2));

    await tester.tap(clickThis.first);
    await tester.pump();

    final leafsAfterClick = find.byType(ExpandableMenuLeafNode);
    expect(leafsAfterClick, findsNWidgets(2));
  });

  testWidgets('Sub-nodes initially expanded', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ExpandableTree(
          initiallyExpanded: true,
          nodes: nodeListWithSubNodes,
          nodeBuilder: (context, itemValue) {
            return Text(itemValue.toString());
          },
        ),
      ),
    );

    final text = find.text('Main Node #1');
    expect(text, findsOneWidget);

    final subItem = find.byType(ExpandableMenuLeafNode);
    expect(subItem, findsNWidgets(5));

    final subItemText = find.text('Node 2-2-2');
    expect(subItemText, findsOneWidget);

  });
}
