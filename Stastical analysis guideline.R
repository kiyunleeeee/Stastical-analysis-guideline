# created: 8/15/2021. By kiyunlee
# modified: 4/11/2023/ By kiyunlee

# note
# This program is a guideline for stastical analysis.
# The program is useful to perform entry level of stastical analysis from the beginning.
# The program contains statistical models, normal distribution tests, data transformation, hypothesis tests, post-hoc testsl.



# handle data
# import data
data <- read.delim("result.txt",header = TRUE)

# remove NaN values
data <- na.omit(data)

# create subsets
sub <- subset(data, feature1!='15min')
sub <- subset(data, feature2=='100nM' | feature2=='150nM')




# build a linear regression model
model <- lm(target1 ~ feature1*feature2*feature3, data)





# perform various normal distribution tests
install.packages("ggpubr")
library(ggpubr)
hist(model$resid)

# density plot
ggdensity(model$resid, xlab = "target variable")

# Q-Q plot
ggqqplot(model$resid)

# Shapiro-Wilk’s method
shapiro.test(model$resid)

#skewness & kurtosis
install.packages("moments")
library(moments)
skewness(model$resid)
kurtosis(model$resid)





# if not normally distributed, power transform (Box-Cox)
library(MASS)
bc = boxcox(model, lambda = seq(-3,3))
best.lam = bc$x[which(bc$y == max(bc$y))]
data$target1Trans <- data$target1^best.lam
model <- lm(target1Trans ~ feature1*feature2*feature3, data)





# if not normally distributed, remove a few data points
# order data by residual
df <- data
df$resid <- model$resid
df <- df[order(df$resid),]
head(df)
tail(df)




#if not normally distributed, Non-normal distribution
# Kruskal-Wallis test.  To compare three or more groups
install.packages('tidyverse')
library(tidyverse)

data$feature1 <- as.factor(data$feature1)
data$feature2 <- as.factor(data$feature2)

data$feature1_2 <- with(data, interaction(feature1, feature2)) # interaction
kw <- kruskal.test(model, data=data)




#if not normally distributed, Non-normal distribution
#Aligned Ranks Transformation ANOVA for non-parametric test
install.packages("ARTool")
library(ARTool)

data$feature1_2 <- with(data, interaction(feature1, feature2)) # interaction

data$feature1 <- as.factor(data$feature1)
data$feature2 <- as.factor(data$feature2)

model <- art(target1 ~ feature1*feature2*feature3, data)
anova(model)






# perform hypothesis tests

# variance test
# shoule perform before t-test, do the two populations have the same variances?
# yes: p>0.05, no: p<0.05 
var.test(model, data)

# t-test
t.test(model, data, paired = FALSE, var.equal = TRUE)
help(t-test)


# ANOVA
anova(model)
aov_model <- aov(model)



#marginal = lsmeans(lme.repeated, ~ treat*drug*ages)
cld(marginal, alpha   = 0.05, Letters = letters,  adjust  = "tukey")



# perform post hoc tests
# Tukey HSD
# option 1
tukey <- TukeyHSD(aov_model)

# option 2
install.packages("DescTools")
library("DescTools")
tukey <- PostHocTest(aov_model)

# option 3
install.packages('agricolae')
library(agricolae)
tukey <- HSD.test(aov_fm,"ages:treat")




# Fisher's Least Significant Different Test
# option 1
library("DescTools")
fisher <- PostHocTest(aov_model, method = "lsd")

# option 2
fisher <- LSD.test(aov_model, "ages", p.adj="bonferroni")






# post hoc for Aligned Ranks Transformation
marginal = art.con(model, "feature1:feature2", adjust="none") #LSD
marginal = art.con(model, "feature1:feature2", adjust="tukey") #tukey





# add significance letters
install.packages('emmeans')
library("emmeans")
em <- emmeans(aov_model,~feature1*feature2*feature3)

summary(pairs(em, adjust="none"), infer=TRUE)

library(multcomp)
cld(em, adjust="none", Letters = "abcdefghijklmnopqrstuvwxyz", reversed = TRUE)


install.packages("multcompView")
library(multcompView)
cld <- multcompLetters4(aov_model, tukey)
print(cld)





