# Script to download all raw metabolomics data from S3 underworlds bucket

# AWS configuration should be the same as for almlab.bucket

# Make this an empty string if you want to actually download the data
# Make this "--dryrun" to just print the dry run command without actually downloading the data
DRYRUN=""

# Just in case these directories don't already exist
mkdir data/raw
mkdir data/raw/metabolomics

################
# 24-hour study
################

DIR=data/raw/metabolomics/24hr
RAW=s3://underworlds.bucket/data/metabolomics/2015_1111-untargeted-24hr/mzML_data/

mkdir ${DIR}
mkdir ${DIR}/mzml
aws s3 sync ${RAW} ${DIR}/mzml/ ${DRYRUN}

## metadata
META="s3://underworlds.bucket/data/metabolomics/2015_1111-untargeted-24hr/sequence_Alm.2015.11.18.corrected.csv"
aws s3 cp "$META" ${DIR}/

############################
# Upstream/downstream Boston
############################

DIR=data/raw/metabolomics/boston-upstream-downstream
RAW=s3://underworlds.bucket/data/metabolomics/2016_0120-untargeted-portland-chelseaheadworks/mzML_files/

mkdir ${DIR}
mkdir ${DIR}/mzml
aws s3 sync ${RAW} ${DIR}/mzml/ ${DRYRUN}

## metadata - same as 24hr, but in a different tab on the excel sheet
META="s3://underworlds.bucket/data/metabolomics/2016_0120-untargeted-portland-chelseaheadworks/mtab_Alm_2016_0120_sequence.csv"
aws s3 cp "$META" ${DIR}/

################################################
# Boston multi-loc and MIT semester longitudinal
################################################

DIR=data/raw/metabolomics/boston-multi-loc-MIT-long
RAW=s3://underworlds.bucket/data/metabolomics/2017_0426-untargeted-MIT-longitudinal-multi-location/mzML_files/

mkdir ${DIR}
mkdir ${DIR}/mzml
aws s3 sync ${RAW} ${DIR}/mzml/ ${DRYRUN}

## metadata
META="s3://underworlds.bucket/data/metabolomics/2017_0426-untargeted-MIT-longitudinal-multi-location/mtab_Alm_2017_0426_sequence.csv"
aws s3 cp "$META" ${DIR}/

############################
# Kuwait and Korea multi-loc
############################

DIR=data/raw/metabolomics/kuwait-multi-loc
RAW=s3://underworlds.bucket/data/metabolomics/2017_0613-untargeted-Kuwait-and-Korea/mzML_files/

mkdir ${DIR}
mkdir ${DIR}/mzml
aws s3 sync ${RAW} ${DIR}/mzml/ ${DRYRUN}

# metadata
META="s3://underworlds.bucket/data/metabolomics/2017_0613-untargeted-Kuwait-and-Korea/mtab_Alm_2017_0613_sequence.csv"
aws s3 cp "$META" ${DIR}/


############################
#  MIT building longitudinal
############################

DIR=data/raw/metabolomics/mit-building-longitudinal
RAW=s3://underworlds.bucket/data/metabolomics/2018_0727-untargeted-MIT-cross-building-longitudinal/mzML_files/

mkdir ${DIR}
mkdir ${DIR}/mzml
aws s3 sync ${RAW} ${DIR}/mzml/ ${DRYRUN}

# metadata
META="s3://underworlds.bucket/data/metabolomics/2018_0727-untargeted-MIT-cross-building-longitudinal/Sequence/mtab_Alm_UW_Lumos_072718_csv.csv"
aws s3 cp "$META" ${DIR}/

####################
# Log file for Make
####################

echo -e "All raw data downloaded" > data/raw/metabolomics/download_log.txt
