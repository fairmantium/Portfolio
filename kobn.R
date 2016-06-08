kobn <- function() {

	#Read in Phil's data
        data <- read.csv("data.csv")

        #Getting number of lines in the dataset and preparing for For Loop
        numberfiles <- nrow(data)
        x <- c(1:numberfiles)

	#Setting up directories for copying
	y <- data[,2]
	z <- unique(y)
	for (blah in z) {

		system( paste("mkdir ./R/",blah,sep="") )

	}

        #For Loop to cycle through all of the rows of data
        for (n in x) {

		#Parsing out information from individual row into vectors
		linelist <- data[n,]
		bsinum <- linelist[[1]]
		mixture <- linelist[[2]]

		#sourcedir <- paste("./*",bsinum,"*_01.fid",sep="")
		destdir <- paste("./R/",mixture,"/",bsinum,"/",sep="")

		#system( paste("cp -r",sourcedir,destdir,sep=" ") )
		system( paste("cp -r ",bsinum,"*.fid ",destdir,sep="") )
		system( paste("cp -r R",bsinum,"*.fid ",destdir,sep="") )
		
	}

}
