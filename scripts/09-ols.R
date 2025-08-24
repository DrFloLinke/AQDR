#' # Linear Regression 

#' 
#' 
#' 
#' 
#' ## Content
#' 
#' <center> __Site still under construction!__ </center>
#' 
#' ### Introduction 

#' 
#' Regression is the power house of the social sciences. It is widely applied and takes many different forms. In this Chapter we are going to explore the linear variant, also called Ordinary Least Squares (OLS). This type of regression is used if our dependent variable is continuous. In the following Chapter we will have a look at regression with a binary dependent variable and the calculation of the probability to fall into either of those two categories. But let's first turn to linear regression.
#' 
#' ### Bivariate Linear Regression 

#' 
#' #### The Theory 

#' 
#' Regression is not only able to identify the direction of a relationship between an independent and a dependent variable, it is also able to quantify the effect. Let us choose `Y` as our dependent variable, and `X` as our independent variable. We have some data which we are displaying in a scatter plot:
#' 
#' 
#' {width=75%}
#' 
#' With a little goodwill we can already see that there is a positive relationship: as `X` increases, `Y` increases, as well. Now, imagine taking a ruler and trying to fit in a line that best describes the relationship depicted by these points. This will be our regression line. 
#' 
#' The position of a line in a coordinate system is usually described by two items: the intercept with the Y-axis, and the slope of the line. The slope is defined as rise over run, and indicates by how much Y increases (or decreases is the slope is negative) if we add an additional unit of X. In the notation which follows we will call the intercept $\beta_{0}$, and the slope $\beta_{1}$. It will be our task to estimate these values, also called coefficients. You can see this depicted graphically here:
#' 
#' 
#' {width=75%}
#' 
#' 
#' __Population__
#' 
#' We will first assume here that we are dealing with the population and not a sample. The regression line we have just drawn would then be called the Population Regression Function (PRF) and is written as follows:
#' 
#' \begin{equation}
#' E(Y|X_{i}) = \beta_{0} + \beta_{1} X_{i}
#' (\#eq:prf)
#' \end{equation}
#' 
#' Because wer are dealing with the population, the line is the geometric locus of all the expected values of the dependent variable `Y`, given the values of the independent variables `X`. This has to do with the approach to statistics that underpins this module: frequentist statsctics (as opposed to Bayesian statistics). We are understanding all values to be "in the long run", and if we sampled repeatedly from a population, then the expected value is the value we would, well, expect to see most often in the long run.
#' 
#' The regression line is not intercepting with all observations. Only two are located on the line, and all others have a little distance between them and the PRF. These distances between $E(Y|X_{i})$ and $Y_{i}$ are called error terms and are denoted as $\epsilon_{i}$. 
#' 
#' 
#' {width=75%}
#' 
#' To describe the observations $Y_{i}$ we therefore need to add the error terms to equation \@ref(eq:prf):
#' 
#' \begin{equation}
#' Y_{i} = \beta_{0} + \beta_{1} X_{i} + \epsilon_{i}
#' (\#eq:pop)
#' \end{equation}
#' 
#' __Sample__
#' 
#' In reality we hardly ever have the population in the social sciences, and we generally have to contend with a sample. Nonetheless, we can construct a regression line on the basis of the sample, the Sample Regression Function (SRF). It is important to note that the nature of the regression line we derive fromt he sample will be different for every sample, as each sample will have other values in it. Rarely, the PRF is the same as the SRF - but we are always using the SRF to estimate the PRF.  
#' 
#' In order to flag this up in the notation we use to specify the SRF, we are using little hats over everything we estimate, like this:
#' 
#' \begin{equation}
#' \hat{Y}_{i} = \hat{\beta}_{0} + \hat{\beta}_{1} X_{i}
#' (\#eq:srf)
#' \end{equation}
#' 
#' 
#' Analogously, we would would describe the observations $Y_{i}$ by adding the estimated error terms $\hat{\epsilon}_{i}$ to the equation.
#' 
#' \begin{equation}
#' Y_{i} = \hat{\beta}_{0} + \hat{\beta}_{1} X_{i} + \hat{\epsilon}_{i}
#' \end{equation}
#' 
#' The following graph visdualised the relationship between an observation, the PRF, the SRF and the respective error terms.
#' 
#' 
#' {width=75%}
#' 
#' 
#' 
#' Ordinary Least Squares (OLS)
#' 
#' When you eye-balled the scatter plot  at the start of this Chapter in order to fit a line through it, you have sub-consciously done so by minimising the distance between each of the observations and the line. Or put differently, you have tried to minimise the error term $\hat{\epsilon}_{i}$. This is basically the intuition behind fitting the SRF mathematically, too. We try to minimise the sum of all error terms, so that all observations are as close to the regression line as possible. The only problem that we encounter when doing this is that these distances will always sum up to zero. 
#' 
#'  But similar to calculating the standard deviation where the differences between the observations and the mean would sum up to zero (essentially we are doing the same thing here), we simply square those distances. So we are not minimising the sum of distances between observations and the regression line, but the sum of the __squared__ distances between the observations and the regression line. Graphically, we would end up with little squares made out of each $\hat{\epsilon}_{i}$ which gives the the method its name: Ordinary Least Squares (OLS). 
#' 
#' 
#' 
#' {width=75%}
#' 
#' 
#' We are now ready to apply this stuff to a real-world example!
#' 
#' 
#' 
#' #### The Application 

#' 
#' In the applied part of this Chapter, we are going to model the feelings towards Donald Trump in the lead-up to the presidential election 2020. Data for this investigation are taken from  https://electionstudies.org/data-center/2020-exploratory-testing-survey/ Please follow this link and download the "2020 Exploratory Testing Survey" and pop it into a working directory. 
#' 
#' We can then load the ANES data set:
#' 
## ------------------------------------------------------------------------------------------------
anes <- read.csv("data/anes.csv")

#' 
#' 
## ------------------------------------------------------------------------------------------------
summary(anes$fttrump1)

#' 
#' This is no good, as the variable is bounded between 0 and 100. In fact 999 is a placeholder for missing data throughout the data set. We need to replace this with NAs.
#' 
## ------------------------------------------------------------------------------------------------
anes[anes == 999] <- NA

#' 
#' If we look at the summary again, everything looks fine now:
#' 
## ------------------------------------------------------------------------------------------------
summary(anes$fttrump1)

#' 
#' By the way, had you just wanted to replace this in one variable, for example only in `fttrump1`, you could have called:
#' 
## ------------------------------------------------------------------------------------------------
# anes$fttrump1 <- with(anes, replace(fttrump1, fttrump1 == 999, NA))

#' 
#' Norris and Inglehart (2016) have argued that:
#' 
#' >populist support in Europe is generally stronger among the older generation, men, the less educated, the religious, and ethnic majorities, patterns confirming previous research.
#' 
#' Let's see if this also applies to presidential elections in the US. We first look at the question: "Do older people rate Trump higher than younger people?". Our independent variables is `age`.
#' 
## ------------------------------------------------------------------------------------------------
summary(anes$age)

#' 
#' Let's evaluate the relationship through a scatter plot with a line of best fit:
#' 
## ------------------------------------------------------------------------------------------------
library(tidyverse)

ggplot(anes, aes(x = age, y = fttrump1)) +
  geom_point() +
  geom_smooth(method = lm)

#' 
#' There is a positive relationship. We can calculate the exact numerical nature of that relationship as follows:
#' 
## ------------------------------------------------------------------------------------------------
model1 <- lm(fttrump1 ~ age, data = anes)

#' 
#' We start by specifying an object into which we store the results. Then we call `lm` which means linear model. Our dependent variable `fttrump1` is listed first, and then after a tilde the independent variable, `age`. Finally, we tell R which data set to use. We can then print the result, by calling `model1`.
#' 
## ------------------------------------------------------------------------------------------------
model1

#' 
#' How would we interpret these results?
#' 
#' - At an age of zero, a person would rate Trump at 31.68 *on average*. This of course makes little sense in anything but a theoretical / mathematical consideration. 
#' - With every additional year of age, a person would rate Trump 0.22 points higher *on average*.
#' 
#' But are these findings significant at an acceptable significance level? Let's find out, by getting a more detailed output:
#' 
## ------------------------------------------------------------------------------------------------
summary(model1)

#' 
#' OK, there is a lot more here, and it is worth pausing to go through this step by step. First, R reminds us of the actual formula we have used to estimate the model:
#' 
#' 
#' 
#' 
#' 
#' I am ignoring the section on residuals, as we don't need to make our life more difficult than it needs to be. Now come the coefficients:
#' 
#' 
#' 
#' 
#' The size and direction is of course the same as in our previous output, but this output now contains some additional information about the standard error, the resulting t-value, and the p-value. R is very helpful here, in that it offers us a varying amount of asterisks according to different, commonly accepted levels of significance. 0.05 is standard practice in the social sciences, so we will accept anything with one, or more asterisks. Both our intercept and the slope coefficient are significant at a 95% confidence level, so we have shown that there is a statistical relationship between age and ratings for Trump. 
#' 
#' I am omitting the residual standard error for the same reason as before, but let us look at the model fit indicators.
#' 
#' 
#' 
#' 
#' Multiple R-Squared (aka $R^{2}$) tells us how much variation in the dependent variable `fttrump1` is explained through the independent variable `age`. $R^{2}$ runs between 0 and 1, where 1 is equal to 100% of the variation. In our case, we have explained a mere 0.09% of the Trump rating. This is lousy, and we can do a lot better than that. Never expect anything near 100% unless you work with a toy data set from a text book. If you get 60-70% you can be very happy. I will return to Adjusted $R^{2}$ in the Section on [Multiple Linear Regression]. 
#' 
#' The F-statistic at the end:
#' 
#' 
#' 
#' is a test with the null hypothesis that all coefficients of the model are jointly zero. In our case, we can reject this null hypothesis very soundly, as the p-value is far below the commonly accepted maximum of 5%. 
#' 
#' 
#' 
#' ##### Categorical Independent Variables (aka 'Dummies') 

#' 
#' Often variables are categorical. One such example is the variable `sex` which has two categories: male and female. 
#' 
## ------------------------------------------------------------------------------------------------
summary(anes$sex)
table(anes$sex)

#' 
#' 
#' Turn this into a factor variable and assign telling labels
#' 
## ------------------------------------------------------------------------------------------------
anes$sex <- factor(anes$sex, labels = c("Male", "Female"))

#' 
#' Check if this has worked:
#' 
## ------------------------------------------------------------------------------------------------
table(anes$sex)

#' 
#' Let's estimate the model:
#' 
## ------------------------------------------------------------------------------------------------
model2 <- lm(fttrump1 ~ sex, data = anes)
summary(model2)

#' 
#' How do we interpret this?
#' 
#' - Let's do the slope coefficient first: a women would rate Trump at 7.16 points less than a man on average. The interpretation of a dummy variable coefficient is done with regards to the reference category. In our case this is "male". So the effect we observe here is equivalent of moving from "male" to "female" and that effect adds 7.16 points.
#' - This gives you an indication of how to interpret the intercept in this case: The value displayed is how men would rate Trump on average, namely at 46.16 points. All of this is significant at a 95% confidence level. 
#' 
#' This effect corroborates the hypothesis advanced by Inglehart and Norris, but the results are not displayed in the most elegant way. The sex these authors made a statement about were men. So we need to change the reference category to "female".
#' 
## ------------------------------------------------------------------------------------------------
anes <- anes %>%
  mutate(sex = relevel(sex, ref = "Female"))

#' 
#' When we re-estimate the model, we get the effect displayed directly:
#' 
## ------------------------------------------------------------------------------------------------
model2 <- lm(fttrump1 ~ sex, data = anes)
summary(model2)

#' 
#' 
#' Whilst many categorical variables are binary, of course not all of them are. So how does this work with a categorical variable with 3 or more levels?
#' 
#' The next determinant mentioned in Inglehart and Norris' paper is education. We can obtain information about a respondent's level of education with the variable `educ`. 
#' 
## ------------------------------------------------------------------------------------------------
summary(anes$educ)
table(anes$educ)

#' 
#' This is not terribly telling in itself, yet, so let's have a look at the codebook:
#' 
#' 
#' {width=60%}
#' 
#' The first step is, as before to recode this variable into a factor variable:
#' 
## ------------------------------------------------------------------------------------------------
anes$educ <- factor(anes$educ)

#' 
#' Eight levels are too many here to do any meaningful analysis, and two would be too reductionist. For sake of simplicity, let's go with three: low, medium and high education. We recode into an ordered factor as follows:
#' 
## ------------------------------------------------------------------------------------------------
anes <- anes %>%
  mutate(educ_fac = recode(educ, '1'="low", 
                       '2'= "low",
                       '3'= "low",
                       '4' = "medium",
                       '5' = "medium",
                       '6' = "high",
                       '7' = "high",
                       '8' = "high"))

#' 
#' Check the results:
#' 
## ------------------------------------------------------------------------------------------------
table(anes$educ_fac)

#' 
#' 
#' And we are ready to go:
#' 
## ------------------------------------------------------------------------------------------------
model3 <- lm(fttrump1 ~ educ_fac, data = anes)
summary(model3)

#' 
#' Whilst the intercept is statistically significant, the slope coefficients are not. Therefore, we can conclude that education has no statistical influence on Trump's approval ratings. 
#' 
#' Note, that as in the sex example before, R has chose the first level of the independent variable as the reference category. If you wish to change this, you can do so in the same manner as before. You can also check which level R has used as the reference category with the `contrasts()` command. Here:
#' 
## ------------------------------------------------------------------------------------------------
contrasts(anes$educ_fac)

#' 
#' 
#' ###
#' 
#' 
#' 
#' 
#' ## References
#' 
#' Inglehart, Ronald F. and Norris, Pippa (2016) Trump, Brexit, and the Rise of Populism: Economic Have-Nots and Cultural Backlash. HKS Working Paper No. RWP16-026, Available at SSRN: https://ssrn.com/abstract=2818659 or http://dx.doi.org/10.2139/ssrn.2818659
 