DIR="parts_Ne_est"
IDFILE="idfile.txt"

/yourpath/chromocombine-0.0.4/chromocombine -o my_res.unnamed -d $DIR
/yourpath/fs-2.0.7/scripts/chromopainterindivrename.pl $IDFILE my_res.unnamed my_res

