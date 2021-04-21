import 'package:flutter/material.dart';

import '../expandable_tree_menu.dart';
import 'defaults.dart';

/// Node without children / sub-items
class ExpandableMenuLeafNode extends StatelessWidget {
  final VoidCallback? onSelect;
  final Widget child;

  const ExpandableMenuLeafNode({
    Key? key,
    this.onSelect,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // DEFAULT_LEAFNODE_TWISTY,
        GestureDetector(
          onTap: onSelect,
          child: child,
        )
      ],
    );
  }
}

/// Header for a Node with children / sub-items
class ExpandableNode extends StatelessWidget {
  final VoidCallback? onSelect;
  final Widget child;

  const ExpandableNode({
    Key? key,
    this.onSelect,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: onSelect,
        child: child,
      ),
    );
  }
}

// TODO: Consider allowing a custom "SubTree" node, eg Flutter "ExpansionTile"

/// Wrapper for node with children / sub-items.  Maintains the open/closed
///  state of this sub-tree.
class CustomSubTreeWrapper<T> extends StatelessWidget {
  final Function(T value)? onSelect;
  final List<TreeNode<T>> subNodes;
  final Widget closedTwisty;
  final Widget openTwisty;
  final Widget Function(BuildContext, T) nodeBuilder; // Use Label
  final TreeNode<T> node; // Null when this is the root of the tree
  final double childIndent;
  final TwistyState defaultState;

  const CustomSubTreeWrapper({
    Key? key,
    this.onSelect,
    this.closedTwisty = DEFAULT_CLOSED_TWISTY,
    this.openTwisty = DEFAULT_OPENED_TWISTY,
    required this.subNodes,
    required this.nodeBuilder,
    required this.node,
    required this.childIndent,
    required this.defaultState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ExpansionTile(
        initiallyExpanded: defaultState == TwistyState.open,
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.only(left: childIndent),
        title: ExpandableNode(
          onSelect: () {
            onSelect!(node.value);
          },
          child: nodeBuilder(context, node.value),
        ),
        children: [
          _ThinDivider(),
          ExpandableTree<T>(
            initiallyExpanded: defaultState == TwistyState.open,
            childIndent: childIndent,
            nodes: subNodes,
            nodeBuilder: nodeBuilder,
            onSelect: onSelect,
          ),
        ],
      ),
    );

  }

}

class _ThinDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Container(
        // width: double.infinity,
        decoration: BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(width: 0.5))),
      ),
    );
  }
}
