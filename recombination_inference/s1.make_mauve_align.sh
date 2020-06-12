# ================
#  mauve_align.sh
# ================

cat <<EOF > mauve_align.sh
#!/bin/bash
APP_NAME=FN_small
RUN="RAW"
NP=4

/home-fn/users/nscc1082/software/mauve_2.3.1/linux-x64/progressiveMauve --output=mauve_out.xmfa \\
EOF

find genomic_fasta/*.fna | sed ':a;N;$!ba;s/\n/ \\\n/g' >> mauve_align.sh

cat <<EOF >> mauve_align.sh

echo '========================================================================================================'
echo '========================================================================================================'

EOF

chmod +x mauve_align.sh
bsub mauve_align.sh
