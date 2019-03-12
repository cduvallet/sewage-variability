# Bash script to convert the raw metabolomics files to mzML
# I will ask Ethan to run this script, because it requires MSConvert with the right driver, which is only available on Windows machines.

#study=2017_0613-untargeted-Kuwait-and-Korea
study=2018_0727-untargeted-MIT-cross-building-longitudinal
this_script=raw_to_mzml.sh

## Make the necessary directories
# for each study: raw data and mzML output
mkdir ${study}
mkdir ${study}/raw_data
mkdir ${study}/mzML_files

## Sync raw data onto local computer (needs to be windows machine)
aws s3 sync s3://underworlds.bucket/data/metabolomics/${study}/raw_data/ ${study}/raw_data/

## Download the MS Convert script
# This is from commit 8feeef336ff3277c79d1126e75647f8a8b37706e
wget https://raw.githubusercontent.com/cduvallet/metabolomics/master/msconvert_wrapper.py

## Run msconvert script
# To change the path for msconvert, use the --msconvert flag
python msconvert_wrapper.py ${study}/raw_data ${study}/mzML_files

## Upload back to S3
aws s3 sync ${study}/mzML_files/ s3://underworlds.bucket/data/metabolomics/${study}/mzML_files/
aws s3 cp ${this_script} s3://underworlds.bucket/data/metabolomics/${study}/
