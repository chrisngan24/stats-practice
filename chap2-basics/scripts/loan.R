library('ggplot2')
# keep data if part of category
insertIfCat <- function(data, cat){
	ret <- array()
	j<-1
	for (i in data$Loan.Purpose){
		if (i == cat && !is.null(data$Amount.Requested[j])){
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
#cred <- insertIfCat(raw, 'credit_card')
print("Amount.Requested")
summary(raw)
plot1 = ggplot(raw, aes( x=AmountRequested, fill = State)) + geom_density() 
plot2 = ggplot(raw, aes( x=InterestRate, fill = State)) + geom_density() 
ggsave('out/loans-out.pdf')
