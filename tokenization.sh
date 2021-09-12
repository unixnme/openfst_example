set -xe

fstcompile --isymbols=ascii.syms --osymbols=wotw.syms > Mars.fst << EOF
0 1 M Mars
1 2 a <epsilon>
2 3 r <epsilon>
3 4 s <epsilon>
4
EOF
fstdraw --isymbols=ascii.syms --osymbols=wotw.syms --portrait Mars.fst | dot -Tpdf >Mars.pdf

fstcompile --isymbols=ascii.syms --osymbols=wotw.syms > Martian.fst << EOF
0 1 M Martian
1 2 a <epsilon>
2 3 r <epsilon>
3 4 t <epsilon>
4 5 i <epsilon>
5 6 a <epsilon>
6 7 n <epsilon>
7
EOF
fstdraw --isymbols=ascii.syms --osymbols=wotw.syms --portrait Martian.fst | dot -Tpdf >Martian.pdf

fstcompile --isymbols=ascii.syms --osymbols=wotw.syms > man.fst << EOF
0 1 m man
1 2 a <epsilon>
2 3 n <epsilon>
3
EOF
fstdraw --isymbols=ascii.syms --osymbols=wotw.syms --portrait man.fst | dot -Tpdf >man.pdf

fstcompile --isymbols=ascii.syms --osymbols=wotw.syms full_punct.txt punct.fst

fstunion man.fst Mars.fst | fstunion - Martian.fst | fstconcat - punct.fst | fstclosure >lexicon.fst
fstdraw --isymbols=ascii.syms --osymbols=wotw.syms --portrait lexicon.fst | dot -Tpdf >lexicon.pdf

fstrmepsilon lexicon.fst | fstdeterminize | fstminimize >lexicon_opt.fst
fstdraw --isymbols=ascii.syms --osymbols=wotw.syms --portrait lexicon_opt.fst | dot -Tpdf >lexicon_opt.pdf

fstcompile --isymbols=ascii.syms --osymbols=ascii.syms > input.fst << EOF
0 1 M M
1 2 a a
2 3 r r
3 4 s s
4 5 <space> <space>
5 6 m m
6 7 a a
7 8 n n
8 9 ! !
9
EOF
fstcompose input.fst lexicon_opt.fst | fstproject --project_output | fstrmepsilon | fstdraw --portrait --isymbols=wotw.syms --osymbols=wotw.syms | dot -Tpdf > output.pdf

gunzip -c lexicon_opt.txt.gz | fstcompile --isymbols=ascii.syms --osymbols=wotw.syms - lexicon_opt.fst
