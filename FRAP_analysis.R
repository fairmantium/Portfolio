#
#
#

#Stringr library for working with strings
library(stringr)

FRAP_analysis <- function (inputpath) {

	#Getting a list of all files in the ./data directory
	datafiles_vector <- list.files(path=inputpath )
	
	#Creating dataframe for storing data from each file
	df <- data.frame(filename=character(), D=numeric(), Imax=numeric(), DStdErr=numeric(), ImaxStdErr=numeric(), ImmobileFrac=numeric(), stringsAsFactors=FALSE )
	
	#Creating for loop for all of the data files
	for (n in datafiles_vector) {
		
		b <- paste(inputpath, "/", n, sep="")

		#Read in the raw data as tab-delimited text.  First 19 lines are header/garbage.
		q <- read.delim(file=b, skip=15, header=TRUE, sep="\t")
	
		#Removing first three rows of data since they occur at time less than 0 before experiment starts
		r <- q[5:89,]
		#Getting X and Y values for graph
		x <- r$Time..s.
		y <- r$FrapNormalized....
		maxy <- max(y)
		
		#Defining the radius of the bleached spot from the file header in row 12
		z <- readLines(b, n=12)
		blah <- z[12]
		blah <- sub("\\t"," ",blah)
		blahblah <- word(blah,5)
		w <- as.numeric(blahblah)
		
		#Creating X-Y plot of Data
		e <- paste(b, ".png", sep="")
		png(file=e)
		plot(x,y, xlab="Time (s)", ylab="% Recovery", main="FRAP Recovery Curve", col="red", pch=19)

		# Non-Least Squares Fit to Data - Number 1
		#fit <- nls(y ~ 100*(1-((w^2)*(((w^2)+(4*pi*D*x))^-1))^0.5), start=list(D=2, I=maxy))
		# Non-Least Squares Fit to Data - Number 2
                fit <- nls(y ~ I*((1-((w^2)*(((w^2)+(4*pi*D*x))^-1)))^0.5), start=list(D=2, I=maxy))

		fitinfo <-coef(fit)
		errors <- summary(fit)$parameters[,"Std. Error"]
		c <- c("Fitted Values for D and Rmax", fitinfo)
                d <- c("Standard Errors for D and Rmax", errors)
		immobile <- as.numeric( c[3] )
		immobile <- 100 - immobile
		dataframeimport <- c(n, fitinfo, errors, immobile)

		df[nrow(df) + 1, ] <- dataframeimport
		
		#Drawing the fit onto the plot
		new <- data.frame(x = seq(min(x), max(x),len=200) )
		lines(new$x, predict(fit,newdata=new) )
		legend("bottomright", legend= c(c, d), lty=c(1,1) )
		dev.off()

	}

	writefile <- paste(inputpath,"/","data.csv",sep="")
	write.csv(df, file=writefile, row.names=FALSE)

}

