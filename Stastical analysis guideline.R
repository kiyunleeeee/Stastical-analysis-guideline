# created: 8/15/2021. By kiyunlee
# modified: 4/19/2023/ By kiyunlee

# note
# This program is a guideline for stastical analysis.
# The program is suitable for biotech/neuroscience/pharamaceutical field where my PhD study and industry experience were in.
# The program contains statistical models, normal distribution tests, data transformation, hypothesis tests, post-hoc tests.
# The program is designed to run by selection, not the whole.
# Please refer to the example dataset "stastical analysis example.txt". This program is modified and adapted to the dataset.




# ///
# handle data
# import data
data <- read.delim("stastical analysis example.txt",header = TRUE)

# remove NaN values
data <- na.omit(data)

# create subsets
sub <- subset(data, drug='d1')
# ///




# build a linear regression model
model <- lm(numSynapse ~ drug*time, data)




# ///
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
# ///




# ///
# if not normally distributed
# option 1: power transform (Box-Cox)
library(MASS)
bc = boxcox(model, lambda = seq(-3,3))
best.lam = bc$x[which(bc$y == max(bc$y))]
data$numSynapseTrans <- data$numSynapse^best.lam
model <- lm(numSynapseTrans ~ drug*time, data)


# option 2: remove a few data points
df <- data
df$resid <- model$resid
df <- df[order(df$resid),] # order data by residual
head(df)
tail(df)


# option 3: non-normal distribution
install.packages('tidyverse')
library(tidyverse)

data$drug <- as.factor(data$drug)
data$time <- as.factor(data$time)
data$drug_time <- with(data, interaction(data, time)) # interaction

kw <- kruskal.test(model, data=data) # Kruskal-Wallis test.  To compare three or more groups


# option 4: non-normal distribution
install.packages("ARTool")
library(ARTool)

data$drug <- as.factor(data$drug)
data$time <- as.factor(data$time)
data$drug_time <- with(data, interaction(data, time)) # interaction

model <- art(target1 ~ feature1*feature2*feature3, data) # Aligned Ranks Transformation ANOVA for non-parametric test
anova(model)
# ///





# ///
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
# ///




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
fisher <- LSD.test(aov_model, "drug", p.adj="bonferroni")



# post hoc for Aligned Ranks Transformation
marginal = art.con(model, "drug:time", adjust="tukey") # tukey
marginal = art.con(model, "drug:time", adjust="none") # LSD
# ///





# add significance letters
install.packages('emmeans')
library("emmeans")
em <- emmeans(aov_model,~drug*time)

summary(pairs(em, adjust="none"), infer=TRUE)

library(multcomp)
cld(em, adjust="none", Letters = "abcdefghijklmnopqrstuvwxyz", reversed = TRUE)


install.packages("multcompView")
library(multcompView)
cld <- multcompLetters4(aov_model, tukey)
print(cld)





