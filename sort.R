library('xlsx')

sortFOL <- function() {

	#Read in Phil's spreadsheet
	df <- read.xlsx("jimsorted.xlsx",sheetName="FOL Quick QC")

	#Get column F and column L out of the dataframe.
	pass <- df$FOLNumber[df$passfail=="p"]
	fail <- df$FOLNumber[df$passfail=="f"]
	
	for (p in pass) {
		
		system( paste("mv ./Individual_Spectra_for_Sorting/", p, " ./PASS/", sep=''))
		
	}

	for (f in fail) {
		
		system( paste("mv ./Individual_Spectra_for_Sorting/", f, " ./FAIL/", sep=''))
		
	}	

}
