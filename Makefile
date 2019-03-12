# Welcome to your first Makefile!

all: MTAB_DATA

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

MTAB_DOWNLOAD_LOG := data/raw/metabolomics/download_log.txt
MTAB_PREP_LOG := data/raw/metabolomics/prep_files_log.txt

MTAB_DATA: $(MTAB_DOWNLOAD_LOG) $(MTAB_PREP_LOG)

$(MTAB_DOWNLOAD_LOG): src/data/download_mtab.sh
	$<

$(MTAB_PREP_LOG): src/data/prep_mtab_proc.py
	python $<
