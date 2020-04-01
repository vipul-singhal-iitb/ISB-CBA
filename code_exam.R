model1=lm(Taste.Score ~ ( factor(Colour) *factor(Sim) *  factor(Display)), data=data)
summary(model1)

# using teh scores1 date without missing

model1=glm( gender_binary  ~ test.1+test.2  , family="binomial", data=scores1)
summary(model1)
nd=data.frame(test.1=81, test.2=82)
predict(model1,  nd, type="response")

model=glm( gender~ test.1+test.2  , family="binomial", data=scores)
summary(model1)
exp(coef(model))


# We need a package called "nnet" to run the multinomial logistic regression

# Assiging a reference level

multi_logit<- relevel(scores$gender, ref="M")

#Fitting a Multinomial Logistic regression Model

#Here,factor is a command used for categorical variables

model<-multinom(gender ~  test.1   + test.2  , data=scores)
summary(model)

# Code for the output of Odds ratio
exp(coef(model))

# Finding the p values for the estimates

z.values <- summary(model)$coefficients/summary(model)$standard.errors
p <- (1 - pnorm(abs(z.values), 0, 1)) * 2
p
attach(scores)
interaction.plot(test.1, gender, test.2)
interaction.plot(test.2, gender, test.1)
# To classify the new observations ,we use the test dataset(uploaded on LMS) as follows:

# import the test dataset and then run the below command

predict(model,newdata=scores2, "probs")



model_insurance_glm=glm(Claim_Count ~ factor(Age_category) + factor(Vehicle_Use.1)+ Severity, family=(link="poisson"), data=insurance1)
summary(model_insurance_glm)

model_insurance_glm1=glm.nb(Claim_Count ~ factor(Age_category) * factor(Vehicle_Use.1)+ Severity, data=insurance1)
summary(model_insurance_glm1)


# Fitting a Cox proportional hazards Model
cox=coxph(Surv(survtime, status) ~ clinic + prison + dose,data=data) 
summary(cox)
plot(survfit(cox), ylim=c(0.7, 1), xlab="Survival time(in days)", ylab="Proportion", main="Estimated Survival Function by PH Method")




# Fitting a Parametric Distribution 
dist=survreg(Surv(ptp_months, dead_flag) ~ ., data = membership, dist = "weibull")

model_cox=coxph(Surv(ptp_months, dead_flag) ~ unsub_flag + avg_ip_time + returns,data=membership) 

summary (model_cox)

plot(survfit(model_cox), ylim=c(0.7, 1), xlab="Months", ylab ="Estimated Survival Function by PH Method")

model_cox_1=coxph(Surv(ptp_months, dead_flag) ~ unsub_flag + avg_ip_time + returns,data=membership) 

summary (model_cox)