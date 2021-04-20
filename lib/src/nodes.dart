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
        DEFAULT_LEAFNODE_TWISTY,
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
class ExpandableSubTree<T> extends StatefulWidget {
  final Function(T value)? onSelect;
  final List<TreeNode<T>> subNodes;
  final Widget closedTwisty;
  final Widget openTwisty;
  final Widget Function(BuildContext, T) nodeBuilder; // Use Label
  final TreeNode<T> node; // Null when this is the root of the tree

  const ExpandableSubTree({
    Key? key,
    this.onSelect,
    this.closedTwisty = DEFAULT_CLOSED_TWISTY,
    this.openTwisty = DEFAULT_OPENED_TWISTY,
    required this.subNodes,
    required this.nodeBuilder,
    required this.node,
  }) : super(key: key);

  @override
  _ExpandableSubTreeState createState() => _ExpandableSubTreeState<T>();
}

class _ExpandableSubTreeState<T> extends State<ExpandableSubTree<T>> {
  TwistyState state = DEFAULT_EXPANDED_STATE;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        // Twisty and a Sub-menu
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Twisty
          GestureDetector(
            onTap: toggleState,
            child: state == TwistyState.open
                ? widget.openTwisty
                : widget.closedTwisty,
          ),
          // Sub-menu
          Expanded(
            child: Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpandableNode(
                        onSelect: () {
                          widget.onSelect!(widget.node.value);
                        },
                        child: widget.nodeBuilder(context, widget.node.value),
                      ),
                      Container(
                        child: state == TwistyState.closed
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _ThinDivider(),
                                  ExpandableTree<T>(
                                    nodes: widget.subNodes,
                                    nodeBuilder: widget.nodeBuilder,
                                    onSelect: widget.onSelect,
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void toggleState() {
    setState(() {
      state =
          (state == TwistyState.open) ? TwistyState.closed : TwistyState.open;
    });
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
            border: Border.symmetric(
                horizontal: BorderSide(width: 0.5, color: Colors.green))),
      ),
    );
  }
}
