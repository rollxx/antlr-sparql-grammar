grammar RootSparql;

options {
  language = Java;
  backtrack=true;
  memoize=true;
}

import Tokenizer, Sparql11, Sparql10;

parse	:	top | start EOF;