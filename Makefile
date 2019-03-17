# Welcome to your first Makefile!

all: MTAB_DATA

RAWDIR := data/raw
PROCDIR := data/proc
MTAB_PROCDIR := $(PROCDIR)/metabolomics

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

PROC_MTAB := $(MTAB_PROCDIR)/24hr.aligned_table.batch_24hr.negative.csv \
			 $(MTAB_PROCDIR)/boston-multi-loc-MIT-long.aligned_table.batch_boston-multi-loc-MIT-long.negative.csv \
			 $(MTAB_PROCDIR)/boston-upstream-downstream.aligned_table.batch_boston-upstream-downstream.negative.csv \
			 $(MTAB_PROCDIR)/kuwait-multi-loc.aligned_table.batch_kuwait-multi-loc.negative.csv \
 			 $(MTAB_PROCDIR)/mit-building-longitudinal.aligned_table.batch_mit-building-longitudinal.negative.csv \


MTAB_PROC: $(PROC_MTAB)
	mkdir $(PROCDIR)
	mkdir $(MTAB_PROCDIR)

# Wonder how I could use wildcard here...

$(MTAB_PROCDIR)/24hr.aligned_table.batch_24hr.negative.csv: $(MTAB_PREP_LOG)
	python ../metabolomics/raw2feats.py -i $(RAWDIR)/metabolomics/24hr/ -o $(MTAB_PROCDIR)

$(MTAB_PROCDIR)/boston-multi-loc-MIT-long.aligned_table.batch_boston-multi-loc-MIT-long.negative.csv: $(MTAB_PREP_LOG)
	python ../metabolomics/raw2feats.py -i $(RAWDIR)/metabolomics/boston-multi-loc-MIT-long/ -o $(MTAB_PROCDIR)

$(MTAB_PROCDIR)/boston-upstream-downstream.aligned_table.batch_boston-upstream-downstream.negative.csv: $(MTAB_PREP_LOG)
	python ../metabolomics/raw2feats.py -i $(RAWDIR)/metabolomics/boston-upstream-downstream/ -o $(MTAB_PROCDIR)

$(MTAB_PROCDIR)/kuwait-multi-loc.aligned_table.batch_kuwait-multi-loc.negative.csv: $(MTAB_PREP_LOG)
	python ../metabolomics/raw2feats.py -i $(RAWDIR)/metabolomics/kuwait-multi-loc/ -o $(MTAB_PROCDIR)

$(MTAB_PROCDIR)/mit-building-longitudinal.aligned_table.batch_mit-building-longitudinal.negative.csv: $(MTAB_PREP_LOG)
	python ../metabolomics/raw2feats.py -i $(RAWDIR)/metabolomics/mit-building-longitudinal/ -o $(MTAB_PROCDIR)
