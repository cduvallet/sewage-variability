#!/usr/bin/env python

"""
This script prepares the metabolomics data and sequence files for
processing with Claire's metabolomics pipeline.
"""

import os
import pandas as pd

def read_seq_file(seqfilepath, keeprows, remove_first_row):
    """
    Read the sequence file provided, convert the rows provided
    into correctly indexed pandas indexes, and return
    just those rows.

    remove_first_row : bool
        Flag to skip the first row when reading in file
    """
    # Convert to correct index for subsetting dataframe
    keepidx = [i - 3 for i in keeprows]

    if remove_first_row:
        df = pd.read_csv(seqfilepath,
            sep=',', skiprows=1)
    else:
        df = pd.read_csv(seqfilepath, sep=',')

    df = df.iloc[keepidx]

    return df

def add_proc_columns(df, study):
    """
    Add the columns needed for processing with Claire's pipeline.
    """
    df['Sample ID'] = df['Sample Name'].apply(fix_sample_id)
    df['Ion Mode'] = 'negative'
    df['Batches'] = study
    return df

def fix_sample_id(s):
    """
    Remove spaces or special characters from a string.
    """

    s = (s.replace(' ', '_')
          .replace('-', '_')
          .replace(',', '_')
          .replace('#', '')
          .replace('(', '')
          .replace(')', '')
          .replace('/', '')
        )
    return s

def update_seq_df(study, seqfile, keeprows, remove_first_row=True):
    """
    Read in the dataframe, subset only the rows indicated,
    add the columns need for the pipeline, and write updated
    dataframe back to the folder.

    RAWDIR is a global variable

    study : str
        folder with the study ID
    seqfile : str
        name of sequence file
    keeprows : list
        list of rows to keep (row numbers from the excel spreadsheet,
        to be converted into correct indices)
    """
    df = read_seq_file(os.path.join(RAWDIR, study, seqfile),
        keeprows,
        remove_first_row)

    # Add the required columns for processing
    df = add_proc_columns(df, study)

    # Write the updated dataframe back to the folder
    newseqfile = seqfile.rsplit('.csv')[0] + '.for_proc.csv'
    df.to_csv(os.path.join(RAWDIR, study, newseqfile), index=False)

    return newseqfile

def write_summary_file(dataset_id, seq_file, data_dir, fsummary):
    with open(fsummary, 'w') as f:
        f.write(
            '\n'.join([
            'DATASET_ID\t' + dataset_id + '\n',
            '#mtab_start',
            'MODE\tnegative',
            'SEQUENCE_FILE\t' + seq_file,
            'DATA_DIRECTORY\t' + data_dir,
            '#mtab_end'])
        )


########

RAWDIR = 'data/raw/metabolomics/'

######################################################
# Make sequence files for processing and summary files
######################################################

# 24 hour study
study = '24hr'
seqfile = 'sequence_Alm.2015.11.18.corrected.csv'

# Label the sequence file rows to keep.
# These numbers corresond to the row numbers when you open the file in Excel.
# The second number in the call to 'range' should be one more than the last
# row you want to keep
keeprows = range(35, 69) + range(81, 89)
newseqfile = update_seq_df(study, seqfile, keeprows)

data_dir = os.path.join(RAWDIR, study, 'mzml')
fsummary = os.path.join(RAWDIR, study, 'summary_file.txt')
write_summary_file(study, newseqfile, data_dir, fsummary)

# Boston multi location
study = 'boston-multi-loc-MIT-long'
seqfile = 'mtab_Alm_2017_0426_sequence.csv'
keeprows = range(16, 62) + range(74, 120)
newseqfile = update_seq_df(study, seqfile, keeprows)

data_dir = os.path.join(RAWDIR, study, 'mzml')
fsummary = os.path.join(RAWDIR, study, 'summary_file.txt')
write_summary_file(study, newseqfile, data_dir, fsummary)

# Upstream downstream
study = 'boston-upstream-downstream'
seqfile = 'mtab_Alm_2016_0120_sequence.csv'
keeprows = range(15, 26)
newseqfile = update_seq_df(study, seqfile, keeprows, remove_first_row=False)

data_dir = os.path.join(RAWDIR, study, 'mzml')
fsummary = os.path.join(RAWDIR, study, 'summary_file.txt')
write_summary_file(study, newseqfile, data_dir, fsummary)

# Kuwait multi-location
study = 'kuwait-multi-loc'
seqfile = 'mtab_Alm_2017_0613_sequence.csv'
keeprows = range(16, 62) + range(74, 120)
newseqfile = update_seq_df(study, seqfile, keeprows)

data_dir = os.path.join(RAWDIR, study, 'mzml')
fsummary = os.path.join(RAWDIR, study, 'summary_file.txt')
write_summary_file(study, newseqfile, data_dir, fsummary)

# MIT building longitudinal
study = 'mit-building-longitudinal'
seqfile = 'mtab_Alm_UW_Lumos_072718_csv.csv'
keeprows = range(17, 77) + range(90, 148) + range(159, 166)
newseqfile = update_seq_df(study, seqfile, keeprows)

data_dir = os.path.join(RAWDIR, study, 'mzml')
fsummary = os.path.join(RAWDIR, study, 'summary_file.txt')
write_summary_file(study, newseqfile, data_dir, fsummary)

####################
# Log file for Make
####################

with open ('data/raw/metabolomics/prep_files_log.txt', 'w') as f:
    f.write('All mtab proc files prepped.')
