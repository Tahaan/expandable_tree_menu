# expandable_tree_menu

A Tree of Sub-menus that can be expanded/collapsed and each node can recursively contain another
tree.

Using the onSelect callback allows the Tree to be used as a menu.

## Getting Started

Add the dependency to the pubspec.yaml file

``
dependencies:
    ...
    expandable_tree_menu: ^0.1.0
``

Import it

`import 'package:expandable_tree_menu/expandable_tree_menu.dart';`


Instantiate it somewhere

``
ExpandableTree(
                nodes: _nodesFromBooks(bookNodes),
                nodeBuilder: _nodeBuilder,
                onSelect: (dynamic node) => _nodeSelected(context, node),
              ), 
``