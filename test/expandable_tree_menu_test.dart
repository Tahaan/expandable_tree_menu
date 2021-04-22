import 'package:expandable_tree_menu/expandable_tree_menu.dart';
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
    TreeNode('Main 2 Node #2', subNodes: [
      TreeNode('Node 2-2-1'),
      TreeNode('Node 2-2-2'),
    ]),
  ]),
];

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

    await tester.tap(menuFinder.first);
    await tester.pump();

    // TODO: Test handling of Taps
  });

  testWidgets('Test With sub-nodes', (WidgetTester tester) async {
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
  testWidgets('Test Open and Close with customer Twisty Icons', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ExpandableTree(
          openTwisty: Icon(Icons.add),
          closedTwisty: Icon(Icons.arrow_forward),
          openTwistyColor: Colors.red,
          initiallyExpanded: false,
          nodes: nodeListWithSubNodes,
          nodeBuilder: (context, itemValue) {
            return Text(itemValue.toString());
          },
        ),
      ),
    );

    // Data:
    //
    //   Main Node #1
    //     Main 1 Node #1 (leaf)
    //     Main 1 Node #2 (leaf)
    //   Main Node #2
    //     Main 2 Node #1 (leaf)
    //     Main 2 Node #2
    //       Node 2-2-1 (leaf)
    //       Node 2-2-2 (leaf)

    // Initial View expected:
    //
    //   Main Node #1 (closed)
    //   Main Node #2 (closed)

    Finder findOpenNodes() => find.byIcon(Icons.add);
    Finder findClosedNodes() => find.byIcon(Icons.arrow_forward);

    final allIconsFound = find.byType(Icon);
    expect(allIconsFound, findsNWidgets(2));

    var openIcon = findOpenNodes();
    var closedIcon = findClosedNodes();
    expect(closedIcon, findsNWidgets(2));
    expect(openIcon, findsNothing);

    await tester.tap(closedIcon.last);
    await tester.pump();

    // Expected View
    //   Main Node #1 (closed)
    //   Main Node #2 (open)
    //     Main 2 Node #1 (leaf)
    //     Main 2 Node #2 (closed)

    openIcon = findOpenNodes();
    expect(openIcon, findsOneWidget);

    closedIcon = findClosedNodes();
    expect(closedIcon, findsNWidgets(2));

    final visibleNodeIcons = find.byType(Icon);
    expect(visibleNodeIcons, findsNWidgets(3));

    await tester.tap(openIcon.first);
    await tester.pump();

    // Final View expected:
    //
    //   Main Node #1 (closed)
    //   Main Node #2 (closed)

    openIcon = findOpenNodes();
    expect(openIcon, findsNothing);

    closedIcon = findClosedNodes();
    expect(closedIcon, findsNWidgets(2));
  });
}
