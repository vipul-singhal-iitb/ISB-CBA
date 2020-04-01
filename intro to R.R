
#simulate data
set.seed(1234)

cpba3 <- data.frame("Gender"=sample(c("M","F"), 100, replace=T, prob=c(0.8,0.2)),"Age_years"=round(rnorm(100,mean=28,sd=5),digits=0),"Height_feet"=round(rnorm(100,mean=5,sd=2.5),digits=2),"Weight_kgs"=round(rnorm(100,mean=45,sd=30),digits=2),"Qualification"=sample(c("B.Tech","MBA", "B.Com"), 100, replace=T, prob=c(0.6,0.35,0.05)),"Industry"=sample(c("IT","Banking", "Consulting", "Healthcare", "Insurance"), 100, replace=T, prob=c(0.6,0.2,0.1,0.05,0.05)),"WorkEx_years"=round(rnorm(100,mean=10,sd=4),digits=0),"City"=sample(c("Bangalore","Hyderabad", "Delhi/NCR", "Mumbai", "Pune", "Chennai"), 100, replace=T, prob=c(0.3,0.2,0.15,0.15,0.05,0.15)),"Batch_timing"=sample(c("1.15","3.30"), 100, replace=T, prob=c(0.5,0.5)))

```

# Data Summary

Now that we have data the first thing we will do is to have a look at the summary and the structure of the data. This will help us identify the type of variables (numeric, categorical, date or time), missing values and measures of central tendency and variation.



```{r dataSummary,echo=T, message=F, fig.height=7, fig.width=20, cache=T, fig.keep='all',eval=T, warning=F,fig.align='center',comment="", results='markup',tidy=T}

# data structure
str(session.4.data)

# data summary default
summary(session.4.data)

# variable summary from the package BCA
require(BCA)
variable.summary(session.4.data)

```

# Distribution of Numeric Variables

The next thing we can look at is the distribution of the numeric variables through histograms.
This is an important visualization technique to check for normality of variables, especially for statistical techniques which are based upon the assumption of normality for example Ordinary Least Squares (OLS) regression.

This is also a good opportunity to demonstrate the for loop and paste function. We will also look at splitting the graphing pane so that we the result is a paneled graph.

```{r histograms,echo=T, message=F, fig.height=7, fig.width=20, cache=T, fig.keep='high',eval=T, warning=F,fig.align='center',comment="", results='markup',tidy=T}

# splitting the graphing pane
opar <- par(no.readonly=T) # assigining default parameters to opar
par(mfrow = c(2,2), mar=par("mar")/2) #splitting the pane into a 2X2 matrix

# creating a data frame of the numeric variables only, this is optional
numVar <- cpba3[,c(1:4,7)]

# using the for loop to plot histograms for each of the 4 numeric variables
for (i in 2:ncol(numVar)) {
  hist(numVar[,i], main=paste("Histogram of", names(numVar[i]), sep=" "), col=i, xlab= names(numVar[i]))
}

# restoring R to it's default parameters
par(opar)

```

# Contingency Tables

Another important framework for analyzing categorical variables are 2X2 or contingency tables. 2X2 refers to two factors both of which may have one or more levels.

These become especially useful while conducting Chi-Squared Tests of Association and evaluating the performance of classification models, both of which will be covered over the duration of your course.

For now it is important to know how to construct and interpret these tables. We will be using the gmodels package for this purpose.

```{r contingencyTables,echo=T, message=F, fig.height=7, fig.width=20, cache=T, fig.keep='high',eval=T, warning=F,fig.align='center',comment="", results='markup',tidy=T}

require(gmodels)

# an example of a 2X2 table where both factors have 2 levels each
with(cpba3,{CrossTable(Gender,Batch_timing,digits = 2,format = "SPSS",prop.chisq = F)})

# another example where both factors have more than 2 levels each
with(cpba3,{CrossTable(City,Industry,digits = 2,format = "SPSS",prop.chisq = F)})

```

# Multivariate Visualization Techniques

Multivariate visualization techniques are those where you consider one than one variable to create a graph.

The types of variables used can be similar i.e both numeric or both categorical or a mix of the two. We will look at the various graphs we can use for each of these cases.

We will be using the package plotting2 considerably in this section. Entire websites are devoted to this powerful graphics package a couple of which are mentioned below:
  
  1. [ggplot2](http://docs.ggplot2.org/0.9.3.1/index.html)

2. [Cookbook for R](http://www.cookbook-r.com/)

## Scatterplots

To visualize the relationship between two continuous variables for example let's say Height and Weight from the data we have, we can use a scatterplot.

This is a useful tool to understand the magnitude and direction of the relationship between the variables. It also helps us to identify outliers.

```{r scatterplots,echo=T, message=F, fig.height=7, fig.width=20, cache=T, fig.keep='high',eval=T, warning=F,fig.align='center',comment="", results='markup',tidy=T}

require(ggplot2)
#simple scatterplot
plot(Weight_kgs~Height_feet,data=cpba3, pch=19, col="darkblue", main="Simple Scatterplot - \n Weight vs Height")

#different color dots depending on gender
plot(Weight_kgs~Height_feet,data=cpba3, pch=19, col=as.numeric(Gender), main="Scatterplot  of Weight vs Height \n by Gender")

# panelled scatterplot by gender
ps <- ggplot(cpba3, aes(Height_feet,Weight_kgs))
ps + geom_point(aes(colour=City,size=5))+ylab("Weight (kg)")+ xlab("Height (feet)") + facet_grid(City~Gender) +ggtitle("Scatterplot of Weight by Gender and City")+ theme(legend.position="none",
plot.title = element_text(lineheight=.8, face="bold",size=20)
,axis.title.x = element_text(face="bold", colour="#990000", size=15),axis.title.y = element_text(face="bold", colour="#990000", size=15),
strip.text.y = element_text(size=10, face="bold"),strip.text.x = element_text(size=15, face="bold")) 

```


## Boxplots

Boxplots are another great way of visualizing the distribution of a continuous variable  by it's self or conditioned upon one or more categorical variables.

```{r Boxplots,echo=T, message=F, fig.height=7, fig.width=20, cache=T, fig.keep='high',eval=T, warning=F,fig.align='center',comment="", results='markup',tidy=T}

require(ggplot2)

p <- ggplot(cpba3, aes(Gender,Weight_kgs))
p + geom_boxplot(outlier.colour = "red",outlier.size = 3,aes(fill=Gender))+ylab("Weight (kg)") +ggtitle("Boxplot of Weight by Gender")+ theme(legend.position="none",plot.title = element_text(lineheight=.8, face="bold")) + geom_jitter() 

```

## Barplots

Barplots are an intuitive way of looking at your data. Let's look at a couple of variations.

```{r Barlots,echo=T, message=F, fig.height=7, fig.width=20, cache=T, fig.keep='high',eval=T, warning=F,fig.align='center',comment="", results='markup',tidy=T}

require(ggplot2)

#simple barplot with flipped coordinates
c <- ggplot(cpba3, aes(Gender))
c + geom_bar(aes(fill=Gender))+ylab("Count") +ggtitle("Barplot of Gender")+ theme(legend.position="none",plot.title = element_text(lineheight=.8, face="bold")) +coord_flip()

#stacked bar chart
cs <- ggplot(cpba3, aes(City))
cs + geom_bar(aes(fill=Gender))+ylab("Count") +ggtitle("Stacked Barplot of Gender by City")+ theme(plot.title = element_text(lineheight=.8, face="bold")) +coord_flip()

#dodged bar chart, same as above but male and female bars plotted side by side
cs + geom_bar(aes(fill=Gender),position = "dodge")+ylab("Count") +ggtitle("Dodged Barplot of Gender by City")+ theme(plot.title = element_text(lineheight=.8, face="bold")) +coord_flip()

#finally using facets
c + geom_bar(aes(fill=Gender)) +facet_grid(City~Industry)+ggtitle("Barplot of Gender by City and Industry")+ theme(legend.position="none",
plot.title = element_text(lineheight=.8, face="bold",size=20)
,axis.title.x = element_text(face="bold", colour="#990000", size=15),axis.title.y = element_text(face="bold", colour="#990000", size=15),
strip.text.y = element_text(size=10, face="bold"),strip.text.x = element_text(size=15, face="bold")) 

```
