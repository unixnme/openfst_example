set -xe

for file in wotw.txt wotw.lm.gz wotw.syms ascii.syms lexicon.txt.gz lexicon_opt.txt.gz full_downcase.txt full_punct.txt; do
    if [ ! -f "$file" ]; then
        wget http://www.openfst.org/twiki/pub/FST/FstExamples/$file
    fi
done

