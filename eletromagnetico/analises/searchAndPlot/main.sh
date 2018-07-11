findAndDelete()
{
	find . -type f -name "$1" -delete
}

find -name "*.asc" | while read ARQUIVO 
do 
	octave-cli analitics.m $ARQUIVO
	mv *.pdf $(dirname -- $ARQUIVO)
done

findAndDelete "*-inc.pdf"
findAndDelete "*.log"
findAndDelete "*.tex"
findAndDelete "*.aux"

