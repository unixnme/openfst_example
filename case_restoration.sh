set -xe
export LD_LIBRARY_PATH=../instant_search/third_party/openfst-1.7.7/build/lib/fst/

gunzip -c wotw.lm.gz > wotw.lm
fstcompile --isymbols=wotw.syms --osymbols=wotw.syms wotw.lm ngram.fst

fstcompile --isymbols=ascii.syms --osymbols=ascii.syms full_downcase.txt full_downcase.fst

# option a (slow)
# fstcompose lexicon_opt.fst ngram.fst | fstarcsort --sort_type=ilabel > wotw.fst

# option b (fast)
fstconvert --fst_type=olabel_lookahead --save_relabel_opairs=relabel.pairs lexicon_opt.fst > lexicon_lookahead.fst
fstrelabel --relabel_ipairs=relabel.pairs ngram.fst | fstarcsort --sort_type=ilabel > ngram_relabel.fst
fstcompose lexicon_lookahead.fst ngram_relabel.fst > wotw.fst

fstinvert full_downcase.fst | fstcompose - wotw.fst >case_restore.fst
