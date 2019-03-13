# Welcome to your first Makefile!

all: MTAB_DATA

RAWDIR := data/raw
PROCDIR := data/proc

############################
#         16S DATA         #
############################

# Download raw data


#####################################
#         METABOLOMICS DATA         #
#####################################

# I have bash and python files that download and prep the data
# for all the metabolomics studies together. These output a log
# file, which will be the target for Make. (This is definitely not
# the best way to do this, but oh well.)

MTAB_DOWNLOAD_LOG := $(RAWDIR)/metabolomics/download_log.txt
MTAB_PREP_LOG := $(RAWDIR)/metabolomics/prep_files_log.txt

MTAB_DATA: $(MTAB_DOWNLOAD_LOG) $(MTAB_PREP_LOG)

$(MTAB_DOWNLOAD_LOG): src/data/download_mtab.sh
	$<

$(MTAB_PREP_LOG): src/data/prep_mtab_proc.py
	python $<

### PROCESS MTAB DATA #####

PROC_MTAB := $(PROCDIR)/24hr.aligned_table.batch_24hr.negative.csv \
			 $(PROCDIR)/boston-multi-loc-MIT-long.aligned_table.batch_boston-multi-loc-MIT-long.negative.csv \
			 $(PROCDIR)/boston-upstream-downstream.aligned_table.batch_boston-upstream-downstream.negative.csv \
			 $(PROCDIR)/kuwait-multi-loc.aligned_table.batch_kuwait-multi-loc.negative.csv \
 			 $(PROCDIR)/mit-building-longitudinal.aligned_table.batch_mit-building-longitudinal.negative.csv \


MTAB_PROC: $(PROC_MTAB)

mkdir $(PROCDIR)
mkdir $(PROCDIR)/metabolomics

# Wonder how I could use wildcard here...

$(PROCDIR)/24hr.aligned_table.batch_24hr.negative.csv: $(MTAB_PREP_LOG)
	python ../metabolomics/raw2feats.py -i $(RAWDIR)/24hr/ -o $(PROCDIR)/metabolomics

$(PROCDIR)/boston-multi-loc-MIT-long.aligned_table.batch_boston-multi-loc-MIT-long.negative.csv: $(MTAB_PREP_LOG)
	python ../metabolomics/raw2feats.py -i $(RAWDIR)/boston-multi-loc-MIT-long/ -o $(PROCDIR)/metabolomics

$(PROCDIR)/boston-upstream-downstream.aligned_table.batch_boston-upstream-downstream.negative.csv: $(MTAB_PREP_LOG)
	python ../metabolomics/raw2feats.py -i $(RAWDIR)/boston-upstream-downstream/ -o $(PROCDIR)/metabolomics

$(PROCDIR)/kuwait-multi-loc.aligned_table.batch_kuwait-multi-loc.negative.csv: $(MTAB_PREP_LOG)
	python ../metabolomics/raw2feats.py -i $(RAWDIR)/kuwait-multi-loc/ -o $(PROCDIR)/metabolomics

$(PROCDIR)/mit-building-longitudinal.aligned_table.batch_mit-building-longitudinal.negative.csv: $(MTAB_PREP_LOG)
	python ../metabolomics/raw2feats.py -i $(RAWDIR)/mit-building-longitudinal/ -o $(PROCDIR)/metabolomics
