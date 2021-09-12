set -xe

cat << EOF > numbers.syms
<epsilon> 0
one 1
two 2
three 3
four 4
five 5
six 6
seven 7
eight 8
nine 9
ten 10
eleven 11
twelve 12
thirteen 13
fourteen 14
fifteen 15
sixteen 16
seventeen 17
eighteen 18
nineteen 19
twenty 20
thirty 30
forty 40
fifty 50
sixty 60
seventy 70
eighty 80
ninety 90
hundred 100
thousand 1000
EOF

cat << EOF > num2string.txt
1 one
11 eleven
111 one hundred eleven
1111 one thousand one hundred eleven
11111 eleven thousand one hundred eleven
111111 one hundred eleven thousand one hundred eleven
EOF

cat << EOF > create_num2string_fst.py
import sys
eps = "<epsilon>"
s = 1
for line in sys.stdin.readlines():
    tokens = line.split()
    print(f'0 {s} {eps} {eps}')
    for c in tokens[0]:
        print(f'{s} {s+1} {c} {eps}')
        s += 1
    print(f'{s} {s+1} <space> {eps}')
    s += 1
    for token in tokens[1:]:
        print(f'{s} {s+1} {eps} {token}')
        s += 1
    print(s)
    s += 1
EOF

cat num2string.txt | python3 create_num2string_fst.py | fstcompile --isymbols=ascii.syms --osymbols=numbers.syms --keep_isymbols --keep_osymbols > numbers.fst
fstrmepsilon numbers.fst | fstdeterminize | fstclosure - numbers_opt.fst
fstdraw --portrait numbers_opt.fst | dot -Tpdf > numbers_opt.pdf

cat << EOF | fstcompile --isymbols=ascii.syms --acceptor > ex1_input.fst
0 1 1
1 2 <space>
2 3 1
3 4 1
4 5 <space>
5 6 1
6 7 1
7 8 1
8 9 <space>
9 10 1
10 11 1
11 12 1
12 13 1
13 14 <space>
14 15 1
15 16 1
16 17 1
17 18 1
18 19 1
19 20 <space>
20 21 1
21 22 1
22 23 1
23 24 1
24 25 1
25 26 1
26 27 <space>
27
EOF

fstcompose ex1_input.fst numbers_opt.fst | fstproject --project_output | fstrmepsilon | fstprint