# Script to download all raw data from S3 underworlds bucket

# AWS configuration should be the same as for almlab.bucket

# Make this an empty string if you want to actually download the data
# Make this "--dryrun" to just print the dry run command without actually downloading the data
DRYRUN="--dryrun"

################
# 24-hour study
################
DIR=data/raw/16s/24hr
RAW=s3://underworlds.bucket/data/sequencing/16S_and_18S/150702Alm_16S_24-hr/raw_fastq/

mkdir ${DIR}
mkdir ${DIR}/fastq
aws s3 sync ${RAW} ${DIR}/fastq/ ${DRYRUN}

## metadata
META="s3://underworlds.bucket/metadata/24hr-study/24hr EXP - Metadata April 8,9 2015.xlsx"
aws s3 cp "$META" ${DIR}/

############################
# Upstream/downstream Boston
############################

DIR=data/raw/16s/boston-upstream-downstream
RAW=s3://underworlds.bucket/data/sequencing/16S_and_18S/160202Alm_16S_Chelsea-Portland/raw_fastq/

mkdir ${DIR}
mkdir ${DIR}/fastq
aws s3 sync ${RAW} ${DIR}/fastq/ ${DRYRUN}

## metadata - same as 24hr, but in a different tab on the excel sheet
META="s3://underworlds.bucket/metadata/24hr-study/24hr EXP - Metadata April 8,9 2015.xlsx"
aws s3 cp "$META" ${DIR}/

################################################
# Boston multi-loc and MIT semester longitudinal
################################################

DIR=data/raw/16s/boston-multi-loc-MIT-long
RAW=s3://underworlds.bucket/data/sequencing/16S_and_18S/170120AlmA_16S_multi-loc_MIT-longitudinal_etc/raw_fastq/

mkdir ${DIR}
mkdir ${DIR}/fastq
aws s3 sync ${RAW} ${DIR}/fastq/ ${DRYRUN}

## metadata
META="s3://underworlds.bucket/metadata/multi-loc_ChelseaPortland-reseq_MIT-longitudinal/Metadata - 10 locations.xlsx"
aws s3 cp "$META" ${DIR}/

##################
# Kuwait multi-loc
##################

DIR=data/raw/16s/kuwait-multi-loc
RAW=s3://underworlds.bucket/data/sequencing/16S_and_18S/170201AlmA_16S_Kuwait/raw_fastq/

mkdir ${DIR}
mkdir ${DIR}/fastq
aws s3 sync ${RAW} ${DIR}/fastq/ ${DRYRUN}

# metadata - same file as boston multi-loc
META="s3://underworlds.bucket/metadata/multi-loc_ChelseaPortland-reseq_MIT-longitudinal/Metadata - 10 locations.xlsx"
aws s3 cp "$META" ${DIR}/

#################
# Seoul multi-loc
#################

DIR=data/raw/16s/seoul-multi-loc
RAW=s3://underworlds.bucket/data/sequencing/16S_and_18S/170613AlmA_16S_Seoul_ChelseaPortland-reseq/raw_fastq/

mkdir ${DIR}
mkdir ${DIR}/fastq
aws s3 sync ${RAW} ${DIR}/fastq/ ${DRYRUN}

# metadata - same file as boston multi-loc
META="s3://underworlds.bucket/metadata/multi-loc_ChelseaPortland-reseq_MIT-longitudinal/Metadata - 10 locations.xlsx"
aws s3 cp "$META" ${DIR}/

## MIT building longitudinal (twice a week sampling at a few MIT buldings)
## We need to ask Fangqiong for this data if we want it.
