import 'package:flutter/material.dart';

const Icon DEFAULT_CLOSED_TWISTY = Icon(Icons.expand_more);
const Icon DEFAULT_OPENED_TWISTY = Icon(Icons.expand_less);
const Icon DEFAULT_LEAFNODE_TWISTY = Icon(
  Icons.circle,
  color: Colors.transparent, // Spacer to ensure alignment of leaf nodes
);

// TODO: Get rid of the place holder in favour of another way of aligning
//       leaf nodes with non-leaf nodes.

enum TwistyState { root, open, closed, leaf }

const TwistyState DEFAULT_EXPANDED_STATE = TwistyState.closed;
