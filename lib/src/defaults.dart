import 'package:flutter/material.dart';

const Icon DEFAULT_CLOSED_TWISTY = Icon(Icons.expand_more);
const Icon DEFAULT_OPENED_TWISTY = Icon(Icons.expand_less);

enum TwistyState { root, open, closed, leaf }

const TwistyState DEFAULT_EXPANDED_STATE = TwistyState.closed;

const double DEFAULT_CHILD_INDENT = 28;