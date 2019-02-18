#!/usr/bin/env python
"""
This script makes the manifest files for each study.

It includes only samples we're interested in (i.e. no robot samples,
no 10 uM samples, etc) and outputs manifest files formatted for QIIME 2.
"""

import pandas as pd

def write_manifest(fout, df, fastqpath, file_prefix):
    """
    Write the QIIME 2 manifest file.

    Parameters
    ----------
    fout : str
        File path to write manifest file to
    df : pandas DataFrame
        DataFrame with 'BMC ID' and 'Sample ID' columns
    fastqpath : str
        path that raw data is in, locally
    file_prefix : str
        the prefix to add to each file (before whatever is in
        the 'BMC ID' column in the dataframe)
    """

    with open(fout, 'w') as f:
        f.write("sample-id,absolute-filepath,direction\n")
        for _, row in df.iterrows():
            sid = row['Sample ID']
            fid = row['BMC ID']
            stem = fastqpath + '/' + file_prefix + fid
            # Forward read
            f.write(','.join([
                sid,
                stem + '_1_sequence.fastq',
                'forward'
            ]) + '\n')
            # Reverse read
            f.write(','.join([
                sid,
                stem + '_2_sequence.fastq',
                'reverse'
            ]) + '\n')

################
# 24-hour study
################

# input metadata file that has BMC IDs <--> sample IDs
fin = "data/raw/16s/24hr/24hr EXP - Metadata April 8,9 2015.xlsx"
# You can also change the fout path to point to something in the
# processing folder if that's easier
fout = "data/raw/16s/24hr/24hr.manifest.csv"
# Note: may need to change this path depending on where the
# qiime2 scripts get called from. fastqpath gives the absolute
# path that tells qiime2 where to find the raw fastq files.
fastqpath = 'data/raw/16s/24hr/fastq'

sheetname = "Labels of samples 16S sequenced"

df = pd.read_excel(fin, sheet_name=sheetname, skiprows=1)
df = df[['BMC ID', 'Sample ID']]

# Keep only the 02 um samples
df = df[df['Sample ID'].str.contains('UW_02um')]

# Write the output manifest file
write_manifest(fout, df, fastqpath, '150702Alm_')

############################
# Upstream/downstream Boston
############################

fin = "data/raw/16s/boston-upstream-downstream/24hr EXP - Metadata April 8,9 2015.xlsx"
fout = "data/raw/16s/boston-upstream-downstream/boston-upstream-downstream.manifest.csv"
fastqpath = 'data/raw/16s/boston-upstream-downstream/fastq'

# Actual sheet name is "Labels of samples sent to 16S seq (batch 2)",
# but downloading from google drive truncates file names and turned this
# one into the same as another sheet, so it got renamed
sheetname = 'Sheet16'

df = pd.read_excel(fin, sheet_name=sheetname, skiprows=1)
df = df[['BMC ID', 'Sample ID']]

# Keep only the 11/04 samples (bc they have paired upstream/downstream sampling)
# and .2 uM filter data
df = df[df['Sample ID'].str.contains('uw_110415_02um')]

# Write the output manifest file
write_manifest(fout, df, fastqpath, '160202Alm_')

################################################
# Boston multi-loc and MIT semester longitudinal
################################################

fin = "data/raw/16s/boston-multi-loc-MIT-long/Metadata - 10 locations.xlsx"
fout = "data/raw/16s/boston-multi-loc-MIT-long/boston-multi-loc-MIT-long.manifest.csv"
fastqpath = 'data/raw/16s/boston-multi-loc-MIT-long/fastq'

sheetname = 'BMC IDs 16S BATCH 1'

# This one doesn't have the data nicely in columns, will need to parse
df = pd.read_excel(fin, sheet_name=sheetname, skiprows=1,
    names=['ix', 'bmc_sample_map', 'xx'])

# Keep just the multi-loc and longitudinal samples
# Note: any samples in this metadata that are labeled with 'B' are blanks,
# we exclude these here.
# So we'll just keep the first 41 rows
df = df.query('ix < 42')

# Now split up the column with all the info into two columns
df = df['bmc_sample_map'].str.split(' : ', expand=True)
df.columns = ['BMC ID', 'Sample ID']
df['Sample ID'] = df['Sample ID'].str.split("(").str[0].str.strip()

# Write the output manifest file
write_manifest(fout, df, fastqpath, '170120AlmA_')

##################
# Kuwait multi-loc
##################

fin = "data/raw/16s/kuwait-multi-loc/Metadata - 10 locations.xlsx"
fout = "data/raw/16s/kuwait-multi-loc/kuwait-multi-loc.manifest.csv"
fastqpath = 'data/raw/16s/kuwait-multi-loc/fastq'

sheetname = 'BMC IDs 16S BATCH 2'

# This one doesn't have the data nicely in columns, will need to parse
df = pd.read_excel(fin, sheet_name=sheetname,
    names=['bmc_sample_map'])

# Here again we'll exclude the blanks. Also I don't know what the
# NDC samples are, so exclude those as well.
df = df.iloc[:14]

# Now split up the column with all the info into two columns
df = df['bmc_sample_map'].str.split(' : ', expand=True)
df.columns = ['BMC ID', 'Sample ID']
df['Sample ID'] = df['Sample ID'].str.split("(").str[0].str.strip()

# Write the output manifest file
write_manifest(fout, df, fastqpath, '170201AlmA_')

#################
# Seoul multi-loc
#################

fin = "data/raw/16s/seoul-multi-loc/Metadata - 10 locations.xlsx"
fout = "data/raw/16s/seoul-multi-loc/seoul-multi-loc.manifest.csv"
fastqpath = 'data/raw/16s/seoul-multi-loc/fastq'

sheetname = 'BMC IDs 16S BATCH 3'

# This one doesn't have the data nicely in columns, will need to parse
df = pd.read_excel(fin, sheet_name=sheetname,
    names=['bmc_sample_map'])

# Here again we'll exclude the blanks. Also I don't know what the
# NDC samples are, so exclude those as well.
df = df.iloc[:9]

# Now split up the column with all the info into two columns
df = df['bmc_sample_map'].str.split(' : ', expand=True)
df.columns = ['BMC ID', 'Sample ID']
df['Sample ID'] = df['Sample ID'].str.split("(").str[0].str.strip()

# Write the output manifest file
write_manifest(fout, df, fastqpath, '170613AlmA_')
