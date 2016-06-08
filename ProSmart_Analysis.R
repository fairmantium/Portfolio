##############################################################################
# R for Taking Data from ProSmart Run and Importing Files into an Excel File #
##############################################################################

################
#  Jim Fairman #
#  2016-04-26  #
################

#########################################################
# Usage:  ProSmart_analysis("/directory/where/data/is") #
#########################################################

#Libraries needed to perform analysis
library(xlsx)
library(stringr)

ProSmart_analysis <- function (inputpath) {

        #Adding subdirectory to input path
        inputsubpath <- paste(inputpath, "/Output_Files/Residue_Alignment_Scores/", sep="")

        #Getting a list of directories to analyze data from
        datadirectories <- list.files(path=inputsubpath)

        #For Loop to go through all data directories
        for (directory in datadirectories) {

                #Get list of files in each data directory
                subdirectory <- paste(inputsubpath, "/", directory, "/", sep="")
                subdirfiles <- list.files(path=subdirectory)
                
		#Removing files from list the contain "clusters" string
		#badfiles <- grep('clusters', subdirfiles)
		#subdirfiles <- subdirfiles[-badfiles]
        	
		#For Loop to go through each text file
		for (textfile in subdirfiles) {
			
			#Load text file into a dataframe
			concattextfile <- paste(subdirectory, textfile, sep="")
			df <- read.table(file=concattextfile, sep="\t", header=TRUE)
			
			#Pasting together strings to get excel file name
			excelfile <- paste(subdirectory, directory, ".xlsx", sep="")

			#Taking only the last 20 characters of the .txt file for the sheetName
			sheetnamestring <- str_sub(textfile,-20,-1)
			
			#Writing results to XLSX file
			write.xlsx(df, file=excelfile, sheetName=sheetnamestring, row.names=FALSE, append=TRUE)

		}
		
	}

}
