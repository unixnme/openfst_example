set -xe

cat > nums.syms << EOF
<epsilon> 0
4 4
42 42
422 422
4225 4225
EOF

fstcompile --isymbols=ascii.syms --osymbols=nums.syms > 4.fst << EOF
0 1 4 4
1
EOF


fstcompile --isymbols=ascii.syms --osymbols=nums.syms > 42.fst << EOF
0 1 4 42
1 2 2 <epsilon>
2
EOF


fstcompile --isymbols=ascii.syms --osymbols=nums.syms > 422.fst << EOF
0 1 4 422
1 2 2 <epsilon>
2 3 2 <epsilon>
3
EOF

fstcompile --isymbols=ascii.syms --osymbols=nums.syms > 4225.fst << EOF
0 1 4 4225
1 2 2 <epsilon>
2 3 2 <epsilon>
3 4 5 <epsilon>
4
EOF

fstunion 4.fst 42.fst | fstunion - 422.fst | fstunion - 4225.fst | fstconcat - punct.fst | fstclosure > lexicon_number.fst
fstrmepsilon lexicon_number.fst | fstdeterminize | fstminimize > lexicon_number_opt.fst

fstcompile --isymbols=nums.syms --osymbols=wotw.syms > nums2wotw.fst << EOF
0
0 0 4 four
0 1 42 forty
1 0 <epsilon> two
0 2 422 four
2 3 <epsilon> hundred
3 4 <epsilon> twenty
4 0 <epsilon> two
0 5 4225 four
5 6 <epsilon> thousand
6 7 <epsilon> two
7 8 <epsilon> hundred
8 9 <epsilon> twenty
9 0 <epsilon> five
EOF

fstarcsort --sort_type=olabel lexicon_number_opt.fst | fstcompose - nums2wotw.fst > lexicon_number_opt_wotw.fst
fstunion lexicon_opt.fst lexicon_number_opt_wotw.fst | fstclosure | fstrmepsilon | fstdeterminize | fstminimize > lexicon_all_opt.fst

fstcompile --isymbols=ascii.syms --osymbols=ascii.syms > ex1_input.fst << EOF
0 1 M M
1 2 a a
2 3 r r
3 4 s s
4 5 <space> <space>
5 6 i i
6 7 s s
7 8 <space> <space>
8 9 4 4
9 10 2 2
10 11 2 2
11 12 5 5
12 13 <space> <space>
13 14 m m
14 15 i i
15 16 l l
16 17 e e
17 18 s s
18 19 <space> <space>
19 20 a a
20 21 w w
21 22 a a
22 23 y y
23 24 <space> <space>
24
EOF

fstcompose ex1_input.fst lexicon_all_opt.fst | fstprint --isymbols=ascii.syms --osymbols=wotw.syms
