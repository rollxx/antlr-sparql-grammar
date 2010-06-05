grammar RootSparql;

options {
  language = Java;
  backtrack=true;
  memoize=true;
}

import Tokenizer, Sparql11;

parse	:	top;