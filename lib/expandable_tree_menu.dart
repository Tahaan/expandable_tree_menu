library expandable_tree_menu;

import 'package:flutter/material.dart';

import 'src/defaults.dart';
import 'src/nodes.dart';

/// The data type for tree nodes.
///
/// The type [T] is the [value] type that will be used by the [nodeBuilder]
///  passed to the [ExpandableTree] Widget
/// When [subNodes] is an empty list the "node" is rendered as a Leaf node.
/// Transport data payload in [value].
class TreeNode<T> {
  final T value;
  final List<TreeNode<T>> subNodes;

  const TreeNode(
    this.value, {
    this.subNodes = const [],
  });
}

/// Creates a (recursive) menu tree-structure where each item is either a leaf
/// node or a sub-menu containing another tree-structure of sub-nodes.
///
/// [onSelect] callBack of the selected node in the menu
/// [nodes] List of nodes at this level of the menu
/// [closedTwisty] Override Twisty Widget when node is collapsed
/// [openTwisty] Override Twisty Widget when node is expanded
/// [nodeBuilder] called to render the node itself from the node's data.
/// [openTwistyColor] Color override to use when node is expanded
/// [closedTwistyColor] Override icon color when node is collapsed
///
/// Example:
///   return ExpandableMenu<String>(
///     onSelect: showSelectedNodePage,
///     nodeBuilder: (context, node) => Text(node.value),
///     nodes: [
///       TreeNode('First Item'),
///       TreeNode('Item with sub items',
///         subNodes: [
///           TreeNode('First Sub Item'),
///           TreeNode('Next sub item'),
///           ]
///         ]
///       );
///
class ExpandableTree<T> extends StatelessWidget {
  final NodeSelectedCallback<T>? onSelect;
  final List<TreeNode<T>> nodes;
  final Widget closedTwisty;
  final Widget openTwisty;
  final NodeBuilder<T> nodeBuilder; // Use Label
  final double childIndent;
  final bool initiallyExpanded;
  final Color? openTwistyColor;
  final Color? closedTwistyColor;

  // TODO: Add a controller to allow Expand-all / collapse-all functionality

  const ExpandableTree({
    Key? key,
    this.onSelect,
    this.closedTwisty = DEFAULT_CLOSED_TWISTY,
    this.openTwisty = DEFAULT_OPENED_TWISTY,
    required this.nodes,
    required this.nodeBuilder,
    this.childIndent = DEFAULT_CHILD_INDENT,
    this.initiallyExpanded = false,
    this.openTwistyColor,
    this.closedTwistyColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: itemBuilder,
      itemCount: nodes.length,
    );
  }

  Widget itemBuilder(BuildContext context, int itemIndex) {
    if (nodes[itemIndex].subNodes.isEmpty) {
      return ExpandableMenuLeafNode(
          onSelect: () {
            onSelect!(nodes[itemIndex].value);
          },
          child: nodeBuilder(context, nodes[itemIndex].value));
    }
    return CustomSubTreeWrapper<T>(
      openTwistyColor: openTwistyColor,
      closedTwistyColor: closedTwistyColor,
      openTwisty: openTwisty,
      closedTwisty: closedTwisty,
      childIndent: childIndent,
      defaultState: initiallyExpanded ? TwistyState.open : TwistyState.closed,
      onSelect: onSelect,
      subNodes: nodes[itemIndex].subNodes,
      nodeBuilder: nodeBuilder,
      node: nodes[itemIndex],
    );
  }
}
