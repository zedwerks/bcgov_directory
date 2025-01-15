# batch to fetch the bc government employee directory from DataBC and then
# convert to csv to use to import into Outlook, etc. and also generate VCF (VCARD) files.
# Author: brad.head@quartech.com

mkdir tmp
mv tmp/bcgov.csv tmp/bcgov.csv~
curl https://dir.gov.bc.ca/downloads/BCGOV_directory_people.csv -o tmp/bcgov.csv 
#curl -o tmp/bcgov.xml https://dir.gov.bc.ca/downloads/BCGOV_directory_people.xml 
sh bin/csv2xml.sh tmp/bcgov.csv tmp/bcgov.xml
xsltproc tmp/bcgov.xml scripts/convert2vcard.xslt -o bcgov.vcf
rm -rf vcards
mkdir vcards
echo 'done!'
echo 'Now running split-vcards.sh to split the vcf file into individuals'
cd vcards
sh ../bin/split-vcards.sh ../bcgov.vcf
cd ..