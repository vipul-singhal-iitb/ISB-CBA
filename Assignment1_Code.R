attach(Data)


# Package "Lattice" is used for dotplot graph
library("lattice") 
library(car)

# Correlation Matrix
cor(Data)


# Partial Correlation Matrix
library(corpcor)
cor2pcor(cor(Data))


### Scatter plot matrix with Correlations inserted in graph
panel.cor <- function(x, y, digits=2, prefix="", cex.cor)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r = (cor(x, y))
  txt <- format(c(r, 0.123456789), digits=digits)[1]
  txt <- paste(prefix, txt, sep="")
  if(missing(cex.cor)) cex <- 0.4/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex)
}
pairs(Data, upper.panel=panel.cor,main="Scatter Plot Matrix with Correlation Coefficients")


# Scatter Plots

plot(POP,SALES,main="Population  '000 Vs Sales")
plot(MEDHVL,SALES,main="Median Home Value Vs Sales")
plot(MEDINC,SALES,main="Extimated Income Vs Sales")
plot(MEDSCHYR,SALES,main="Median of Schooling Vs Sales")
plot(PRCRENT,SALES,main="% Rented Vs Sales")
plot(PRC55P,SALES,main="Higher than 55 Vs Sales")
plot(HHMEDAGE,SALES,main="Median  Age Vs Sales")


#Linear Regression Model 
model<-lm(SALES~ POP ,data=Data)
summary(model)
anova(model)


#ScatterPlot of "Sales VS POP"

plot(POP,SALES,main="Line of Best Fit - With Intercept", col="Dodgerblue4", col.main="Dodgerblue4", col.lab="Dodgerblue4", xlab="POP", ylab="SALES", pch=20)
abline(model, col="red")
segments(POP, SALES, POP,predict(model))



#Multiple Linear Regression Model 

model5<-lm(SALES~ POP+MEDHVL ,data=Data)
summary(model5)
anova(model5)


model4<-lm(SALES~ POP+MEDHVL+MEDSCHYR ,data=Data)
summary(model4)
anova(model4)
plot(model4)
confint(model4)
avPlots(model4)
residualPlots(model4)
influenceIndexPlot(model4, id.n=3)


# "par(mfrow)"command is used To plot the graphs in 2*2 matrix form

#The below "Plot" command gives four graphs like residual V fitted , Normal QQ Plot,...
par(mfrow=c(2,2))
plot(model4)



# Deletion Diagnostics
influence.measures(model4)
influenceIndexPlot(model4,id.n=3) # Index Plots of the influence measures
influencePlot(model4,id.n=3) # A user friendly representation of the above


## Regression after deleting the 9th observation
model.final<-lm(SALES~ POP+MEDHVL+MEDSCHYR, data=Data[-c(9),])
summary(model.final)
anova(model.final)
plot(model.final)
confint(model.final)
avPlots(model.final)
residualPlots(model.final)
influenceIndexPlot(model.final, id.n=3)
influence.measures(model.final)
influenceIndexPlot(model.final,id.n=3) # Index Plots of the influence measures
influencePlot(model.final,id.n=3) # A user friendly representation of the above

#Confidence Intervalfor the coefficient
confint(model.final,level=0.95)



# Diagnostic Plots
# Residual Plots, QQ-Plos, Std. Residuals vs Fitted
plot(model.final) 

# Residuals vs Regressors
residualPlots(model.final) 

# Added Variable Plots
avPlots(model.final, id.n=2, id.cex=0.7) 


### Variance Inflation Factors
vif(model.final)