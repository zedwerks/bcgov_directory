%%REM batch to fetch the bc government employee directory from DataBC and then
%REM convert to csv to use to import into Outlook, etc. and also generate VCF (VCARD) files.
%REM Author: brad.head@quartech.com
%REM
mkdir tmp
move /Y tmp\bcgov.xml tmp\bcgov.xml~
.\bin\curl.exe https://dir.gov.bc.ca/downloads/BCGOV_directory.xml > bcgov.xml
.\bin\msxsl.exe tmp\bcgov.xml scripts/convert2vcard.xslt -u 4.0 -o bcgov.vcf
.\bin\msxsl.exe tmp\bcgov.xml scripts/convert2csv.xslt -u 4.0 -o bcgov.csv
rmdir /S /Q vcards-old
move /Y vcards vcards-old
mkdir vcards
%echo 'done!'
%echo 'Now running vCardSplit.exe to split the vcf file into individuals'
cd vcards
..\bin\vCardSplit-cli.exe ..\bcgov.vcf > vcards.log
cd ..