import 'package:expandable_tree_menu/expandable_tree_menu.dart';
import 'package:expandable_tree_menu/src/defaults.dart';
import 'package:expandable_tree_menu/src/nodes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final _et = ExpandableTree<String>(
  onSelect: (s) {},
  nodeBuilder: (cntext, nodeValue) {
    return Container();
  },
  nodes: [],
);

final expandableTreeStringType = _et.runtimeType;


final _expandableSubTree = ExpandableSubTree<String>(
  defaultState: TwistyState.closed,
  childIndent: DEFAULT_CHILD_INDENT,
  node: TreeNode('Data'),
  onSelect: (s) {},
  nodeBuilder: (context, nodeValue) {
    return Container();
  },
  subNodes: [],
);

final expandableSubTreeStringType = _expandableSubTree.runtimeType;

void main() {
  testWidgets('Test With Empty List of Nodes', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ExpandableTree(
          nodes: [],
          nodeBuilder: (context, node) {
            return Text(node.runtimeType.toString());
          },
        ),
      ),
    );
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

    // final menuBase = find.byType(ExpandableTree);
    // expect(menuBase, findsOneWidget);
  });

  testWidgets('Test With 2 nodes each with 2 sub-nodes',
      (WidgetTester tester) async {
    final nodeList = [
      TreeNode('Main Node #1', subNodes: [
        TreeNode('Main 1 Node #1'),
        TreeNode('Main 1 Node #2'),
      ]),
      TreeNode('Main Node #2', subNodes: [
        TreeNode('Main 2 Node #1'),
        TreeNode('Main 2 Node #2'),
      ]),
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

    // await tester.pump();

    debugDumpApp();

    final text = find.text('Main Node #1');
    expect(text, findsOneWidget);

    final subItem = find.byType(ExpandableMenuLeafNode);
    expect(subItem, findsNothing);

    final subItemText = find.text('Main 1 Node #2');
    expect(subItemText, findsNothing);

    final menuFinder = find.byType(expandableTreeStringType);
    expect(menuFinder, findsOneWidget);

    final subMenuFinder = find.byType(expandableSubTreeStringType);
    expect(subMenuFinder, findsNWidgets(2));

    var clickThis = find.byIcon(Icons.expand_more);
    expect(clickThis, findsNWidgets(2));

    await tester.tap(clickThis.first);
    await tester.pump();

    final leafsAfterClick = find.byType(ExpandableMenuLeafNode);
    expect(leafsAfterClick, findsNWidgets(2));
  });
}
