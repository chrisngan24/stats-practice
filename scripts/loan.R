insertTo <- function(data, strin){
	ret <- array()
	j<-1
	for (i in data$Loan.Purpose){
		if (i == strin && !is.null(data$Amount.Requested[j])){
			ret <- c(ret, data$Amount.Requested[j])
		}
		j<- j +1
	}

	return(ret)

}

raw <- read.table(
		"./data/loansData.csv",
		
		sep=",",
	)

cred <- insertTo(raw, 'credit_card')
print("Amount.Requested")
summary(cred)
head(cred)
plot(cred)