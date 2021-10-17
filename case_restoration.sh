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

fstinvert full_downcase.fst | fstcompose - wotw.fst > case_restore.fst

fstcompile --isymbols=ascii.syms --acceptor > marsman.fst << EOF
0 1 m
1 2 a
2 3 r
3 4 s
4 5 <space>
5 6 m
6 7 a
7 8 n
8 9 <space>
9
EOF

fstcompose marsman.fst case_restore.fst | fstrmepsilon | fstpush --push_weights --push_labels | fstdraw --portrait --isymbols=ascii.syms --osymbols=wotw.syms | dot -Tpdf > prediction.pdf
open -a Preview prediction.pdf

fstcompile --isymbols=ascii.syms --acceptor > just_a_second.fst << EOF
0 1 j
1 2 u
2 3 s
3 4 t
4 5 <space>
5 6 a
6 7 <space>
7 8 s
8 9 e
9 10 c
10 11 o
11 12 n
12 13 d
13 14 <space>
14
EOF

fstcompose just_a_second.fst case_restore.fst | fstproject --project_output | fstrmepsilon | fstshortestpath --unique --nshortest=3 | fstrmepsilon | fstpush --push_labels --push_weights | fstdraw --portrait --isymbols=wotw.syms --acceptor | dot -Tpdf > just_a_second.pdf
open -a Preview just_a_second.pdf

fstcompile --isymbols=ascii.syms --acceptor > no_one.fst << EOF
0 1 n
1 2 o
2 3 <space>
3 4 o
4 5 n
5 6 e
6 7 <space>
7
EOF

fstcompose no_one.fst case_restore.fst | fstproject --project_output | fstrmepsilon | fstshortestpath --unique --nshortest=3 | fstrmepsilon | fstpush --push_labels --push_weights | fstdraw --portrait --isymbols=wotw.syms --osymbols=wotw.syms | dot -Tpdf > no_one.pdf
open -a Preview no_one.pdf
