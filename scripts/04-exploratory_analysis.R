#' # Exploratory Data Analysis 

#' 
#' 
#' 
#' 
#' 
#' 
#' ## Content
#' 
#' 
#' ### What is exploratory data analysis? 

#' 
#' Next to data cleaning, exploratory data analysis is one of the first steps taken in the process of analysing quantitative data of any kind. Essentially, it refers to getting an overview of the data through looking at simple summary statistics and plots to understand the distribution of each variable, as well as look for particularly obvious and pronounced relationships between the variables. If one is taking a _deductive_ approach, with a clear-cut, falsifiable hypothesis about the data defined upfront (such as *higher per capita income is related to higher levels of democracy* or *income equality increases levels of subjective well-being*), exploratory data analysis helps you verify whether the hypothetized relationship is in the data at all - for example by applying the so-called *Inter-Ocular Trauma Test* (*if it hits you between the eyes, it's there!*) to a plot. This informs further formal statistical analyses. It also allows you to identify factors that may be important for the hypothesized relationship and should be included in the formal statistical model. In case of an _inductive_ approach, exploratory data analysis allows you to find patterns and form hypothesis to be furhter tested using formal statistical methods.
#' 
#' In this chapter, we will cover some basic exploratory methods that can be applied to examine numeric and categorical data. For this purpose we will use the data from [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets.php), which covers math grades achieved in three years of education by a sample of students, along with some demographic variables ^[note that the data was slightly modified to include missing values for demonstration purposes]. The data download link is available at the top of this course page. To load it, we can use the familiar `read.csv` function. Note that in this case, the `sep` optional argument is specified to `";"`. You can find out why by reading about this argument in the function documentation (`?read.csv`) and by examining the dataset using your computer's notepad app.
#' 
## ------------------------------------------------------------------------------------------------
math <- read.csv("data/student/student-mat-data.csv", sep = ";")

#' 
#' 
#' ### First look at the data 

#' 
#' After loading the data into R, it's useful to get an overview of it. The first thing it's worth to look at is how many variables and how many observations are there in the dataset. This can be seen in the environment browser next to the name of the data frame. We can also access the _dimensions_ of our data (i.e. how many rows and columns/observations and variables it has) through the `dim` function.
#' 
## ------------------------------------------------------------------------------------------------
dim(math)

#' 
#' We can see that the `math` dataset consists of 395 observations of 33 variables. The next useful step is to look at the dataset's structure using the `str` variable:
#' 
## ------------------------------------------------------------------------------------------------
str(math)

#' 
#' This lists all the variables in the dataset, with their names and types. This way, we can scope the dataset for the variables that are interesting for our analysis and start thinking about possible relationships we might want to investigate. 
#' 
#' Finally, we can get some basic summary statistics using the `summary` function:
#' 
## ------------------------------------------------------------------------------------------------
summary(math)

#' 
#' This lists the minimum, maximum, mean and quartiles for each of the numeric variables, along with the count of missing values in it. These concepts will be discussed in more detail in the next sections of this chapter. In case of factor variables, it provides a count of each level of the variable. It also mentions the number of missing variable - in this case, we can see that there are couple of `NA`s in there. Before starting the analysis, we need to address that - in this case, we simply drop them. 
#' 
## ------------------------------------------------------------------------------------------------
math <- math[complete.cases(math), ]

#' 
#' 
#' ### Numeric vs categorical variables 

#' 
#' ### Numeric variables 

#' 
#' #### Histograms 

#' 
#' The simplest and often most powerful way to examine a single numeric variable is through the use of _histogram_. Histogram divides a variable in ranges of equal size called _bins_. Each bin is then represented as a bar, the height of which corresponds with the count/proportion of the observations falling in that range. The main difference between a histogram and a bar chart is that a histogram does not have breaks between the bars, because the variable it describes is assumed to be continuous, not discrete. Let's examine two numeric variables from the `math` dataset - `age` and `absences` (total absent hours recorded by the teacher for each student) using histograms. A histogram is created using the `hist` function:
#' 
## ------------------------------------------------------------------------------------------------
hist(math$age, breaks = length(unique(na.omit(math$age))))

#' 
## ------------------------------------------------------------------------------------------------
hist(math$absences)

#' 
#' In both cases, we can see that the lowest values are the most frequent. For example, from the second histogram we can read that 250 of the 395 students in the samples were absent between 0-5 hours during the school year.
#' 
#' #### Mean 

#' 
#' Mean (aka average) is the simplest statistic describing any numeric variable - it is simply the sum of a variable/vector divided by its length. In R, we can calculate the mean of any variable using the `mean` function. For example, let's examine the average number of absences in the sample:
#' 
## ------------------------------------------------------------------------------------------------
sum(math$absences)/nrow(math)
mean(math$absences)

#' 
#' The same done for `age` returns this value: 
#' 
## ------------------------------------------------------------------------------------------------
mean(math$age)

#' 
#' Had we not removed the missing values (`NA's`) at the start, this command would not have worked and would have returned `NA`. Should you ever come across this issue, then this is a reminder that you need to do something with your missing data. If you just wish to circumvent the problem for the time being, you could call:
#' 
## ------------------------------------------------------------------------------------------------
mean(math$age, na.rm = TRUE)

#'  
#' where we specify the argument `na.rm`(remove `NA` values) to `TRUE`.
#' 
#' We can also use the `trim` argument from to specify the fraction of observations to be removed from each end of the sorted variables before calculating the mean. This makes our estimate of the mean more robust to potentially large and unrepresentative values affecting the calculated value - so-called *outliers*, which will be discussed more extensively in the [section on quantiles](#quantiles). Note that specifying the `trim` argument to 0.1 doesn't seem to change the mean of age significantly:
#' 
## ------------------------------------------------------------------------------------------------
mean(math$age, na.rm = TRUE, trim = 0.1)

#' 
#' However, doing the same in case of absences changes the value of average absences quite a lot. Can you think of the reason why? Take a look at the histograms of both variables.
#' 
## ------------------------------------------------------------------------------------------------
mean(math$absences, trim = 0.1)

#' 
#' 
#' #### Variance and standard deviation 

#' 
#' While a mean offers a good description of the central tendency of a variable (i.e. a value that we would expect to see most often), describing a variable just by its mean can be very misleading. For example, consider the values `-10000, 20, 10000` and `15, 20, 25`. In both cases the mean is the same:
#' 
## ------------------------------------------------------------------------------------------------
x <- c(15, 20, 25)
y <- c(-985, 20, 1025)
mean(x) == mean(y)

#' 
#' However, it would be very misleading to say that these variables are similar. We could try to describe this difference by computing the average distance between each value and the mean:
#' 
## ------------------------------------------------------------------------------------------------
mean(x - mean(x))
mean(y - mean(y))

#' 
#' However, this results in a 0, since the negative and positive values in our example cancel each other out. To avoid this, we can measure the **variance**, which calculates the mean of the sum of the squared distances between each value of a variable and its mean. Since the distance is squared (always positive), the positive and negative values will not cancel out.
#' 
## ------------------------------------------------------------------------------------------------
mean((x - mean(x))^2)
mean((y - mean(y))^2)

#' 
#' We can see that this captures the difference between our two vectors. 
#' 
#' You can calculate the variance with a simple shortcut in R, with the `var` function:
#' 
## ------------------------------------------------------------------------------------------------
var(x)
var(y)

#' 
#' Note that this gives us different results than our variance computed by hand. This is because we calculate the _population wariance_ in which we divide by the number of observations in the population (or length of the vector), N. So, the variance we calculated "manually" above is equivalent to:
#' 
## ------------------------------------------------------------------------------------------------
sum((x - mean(x))^2)/length(x)
mean((x - mean(x))^2)

#' 
#' Instead, the `var()` function calculates the _sample variance_, for which we divide the sum of squared distances from the mean by $N-1$. This is because dividing the sample by N tends to underestimate the variance of the population. The mathematical reasons behind it are clearly outlined in [this article](https://towardsdatascience.com/why-sample-variance-is-divided-by-n-1-89821b83ef6d). So, we can "manually" arrive at equivalent estiamte to the one obtained using the `var` function by:
#' 
## ------------------------------------------------------------------------------------------------
sum((x - mean(x))^2)/(length(x) - 1) == var(x)

#' 
#' We can apply the variance function to `absence` and `age`, to see their spread:
#' 
## ------------------------------------------------------------------------------------------------
var(math$age, na.rm = TRUE)
var(math$absences)

#' 
#' 
#' 
#' 
#' 
#' One problem arising when using variance to describe the data is that its units aren't interpretable, since they are squared. Therefore, saying that the variance of the absence time is 64 squared hours doesn't sound too intuitive. To avoid this, we usually use use the _standard deviation_ in practice, which is simply the square root of the variance. Through taking the square root we return the variable to its original units. The standard deviation of a variable is calculated using the `sd` function:
#' 
## ------------------------------------------------------------------------------------------------
sd(math$age, na.rm = TRUE)
sd(math$age, na.rm = TRUE) == sqrt(var(math$age, na.rm = TRUE))

#' 
#' Not ethat I am including the `na.rm = TRUE` option for illsutrative purposes only, since we did remove missing values, earlier. 
#' 
#' We can know compare the standard deviation and mean of both variables:
#' 
## ------------------------------------------------------------------------------------------------
with(math, c(mean = mean(age, na.rm = TRUE), 
  sd = sd(age, na.rm = TRUE)))

with(math, c(mean = mean(absences, na.rm = TRUE), 
  sd = sd(absences, na.rm = TRUE)))

#' 
#' It can be clearly seen that the hours of students' absence have more variability than the students' ages. This makes intuitive sense, since the sample consists of students from roughly the same age group (the easiest way you can see it is by running `unique(math$age)`). At the same time, students differ match more in the total hours of absence. This explains why the trimmed mean was that different from overall mean in case of `absences`, yet quite similar for `age`.
#' 
#' You can use the widget below to see how varying the standard deviation and the mean affects the distribution of a variable (in this case a normally distributed random variable). Note that you need an active internet connection for the app to load.
#' 
## ------------------------------------------------------------------------------------------------
knitr::include_app('https://drflorianreiche.shinyapps.io/standard_deviation/', height = '800px')

#' 
#' #### Quantiles 

#' 
#' 
#' The final statistic we are going to discuss is _quantile_. Quantiles allow us to get a better grasp of the distribution of the data. Essentially, quantiles are cut points that divide the variable into intervals of equal sizes. For example, _deciles_ are 10-quantiles, dividing the variable into 10 ranges. For example the 8th decile of a variable is the value greater than 80% of the values in this variable. In R we can obtain an arbitrary quantile using the `quantile` function, specifying the proportion below each of the cutpoints through the `probs` argument.
#' 
## ------------------------------------------------------------------------------------------------
quantile(math$absences, probs = 0.9)

#' In the above example, we can see that 90% of the values of the variable `absences` are lower than 14. The `probs` argument can be either a scalar or a vector, so we can obtain multiple quantiles at once. For example in the example below we obtain so-called quartiles (4-quantiles).
#' 
## ------------------------------------------------------------------------------------------------
quantile(math$absences, probs = c(0, .25, .5, .75, 1)) #quartiles

#' 
#' We could get deciles by:
#' 
## ------------------------------------------------------------------------------------------------
quantile(math$absences, probs = seq(0, 1, by = 0.1))

#' 
#' We can visualize this using a histogram:
#' 
## ------------------------------------------------------------------------------------------------
hist(math$absences, breaks = 50, main = "", xlab = "Absences", ylim = c(0, 250))
qnts <- quantile(math$absences, probs = seq(0, 1, by = 0.1))
segments(qnts, 0, qnts, 200)
text(qnts, c(160, 170, 180, 160, 170, 160, 170, rep(160, 4)) + 50, 
     labels = names(qnts), cex = 0.5, offset = 0.1, srt = 45)

#' 
#' ##### Median 

#' 
#' The _median_ is a specific quantile - the 50th percentile of a variable, i.e. the midpoint of the variable's distribution. As opposed to the _mean_, it's not affected by outlying values. Large differences between _mean_ and _meadian_ are often evidence of a skew in the variable's distribution.
#' 
## ------------------------------------------------------------------------------------------------
hist(math$absences, main = "", breaks = 50, xlab = "Absences")
segments(median(math$absences), 0, median(math$absences), 150, col = 'red', 
         lty = 2, lwd = 1.5)
text(median(math$absences), 160, col = 'red', labels = 'Median',
     cex = 0.5, srt = 45)
segments(mean(math$absences), 0, mean(math$absences), 150, col = 'blue', 
         lty = 3, lwd = 1.5)
text(mean(math$absences), 160, col = 'blue', labels = 'Mean', 
     cex = 0.5, srt = 45)

#' 
#' ##### Outliers 

#' 
#' Finally, as mentioned earlier, quantiles are particularly useful when it comes to identifying *outliers*. Outliers are observations with extreme values, lying far from majority of values in a dataset. In some cases they may be results of data collection error, while in others they are simply rare examples of our variable of interest taking a very high or low value. Outliers can often extert high levarage on a given statistic we are measuring (such as the mean), and removing them may sometimes change the results of our analysis significantly. Thus, it is often worth removing them and re-running the analysis to make sure that it's not affected too severly by a small number of observations with extreme values. Note that this is not to say that outliers should always be removed or disregarded - contrary to that, observations with outlying values should be treated with extra care and it is the role of the analyst to examine why are these values extreme and what are the possible implications for the analysis. 
#' 
#' Quantiles can be used to find the outlying observations - for example, by looking at the 0.001 and 0.999 cutpoints, and considering all values below or above to be outiers.
#' 
#' 
#' #### Box plots 

#' 
#' _Box plots_ are commonly used to visualize the distribution of a variable. Below, we use the `boxplot` function to plot a boxplot of the `age` variable from the `math` dataset.
#' 
## ------------------------------------------------------------------------------------------------
boxplot(math$age)

#' 
#' The box in the middle of the plot corresponds with the inter-quartile range of the variable (IQR) - this is the range between the 1st and the 3rd quartile of the variable (which is equivalent to the value range between 25th and 75th percentile). The thick line in the middle corrsponds to the variable's median (the 2nd quartile/50th percentile). The 'whiskers' (i.e. the horizontal lines connected by the dashed line with each end of the box) correspond to the minimum and the maximum values of the variable. The maximum is defined as the largest value in the variable that is _smaller than the number 1.5 IQR above the third quartile_ and the minimum is the lowest value in the variable that is _larger than the number 1.5 IQR below the first quartile_. Anything above/below the whiskers numbers is considered an outlier and marked with a dot. In the above example we can see that one observation is an outlier, lying significantly above the upper whisker of the boxplot. We can identify this value by plugging in the above formula for the upper whisker (#3rd quartile + $1.5IQR$) and finding the value that lies above it.
#' 
## ------------------------------------------------------------------------------------------------
maximum <- quantile(math$age, 0.75, na.rm = TRUE, names = FALSE) + 
  1.5 * IQR(math$age, na.rm = TRUE)
math$age[which(math$age > maximum)]

#' 
#' While useful under many circumstances, box plots can be deceiving, as two similarily looking box plots can represent very different disttributions. That's why it is always useful to look at the variable's histogram as well. This can be seen in the example below:
#' 
## ------------------------------------------------------------------------------------------------
library(gnorm)
x <- rnorm(1000, -2, 0.7)
y <- rnorm(1000, 2, 0.7)
z <- rgnorm(2000, 0, 3.5, beta = 8)
variable <- c(rep("Variable one", length(x) + length(y)), 
              rep("Variable two", length(z)))
boxplot(c(x, y, z) ~ variable, ann = F)

#' 
## ------------------------------------------------------------------------------------------------
par(mfrow = c(1, 2))
hist(c(x, y), breaks = 100, xlab = "Variable one", main = "")
hist(z, breaks = 100, xlab = "Variable two", main = "")

#' 
#' 
#' #### Scatter plots 

#' 
#' Finally, a good way to explore the relationship between two numeric variables visually are scatter plots. Scatter plots represent each observation as a marker, with x-axis represnting value of one variable and y-axis of another. Scatter plots are simply created using the `plot` function.
#' 
## ------------------------------------------------------------------------------------------------
plot(math$G1, math$G2)

#' 
#' 
#' 
#' 
#' 
#' In the example above, we can see that there's a positive relationship between student's grade in first year and the grade in the second year. While such plot would not be sufficient to make any strong empirical claims, it is usually a valuable first step in finding statistical regularities in the dataset. More formal ways of measuring association between variables will be discussed in sections on [statisical association](#association) and [linear regression](#ols).
#' 
#' ### Categorical variables 

#' 
#' #### Cross-tabulation 

#' 
#' Categorical variables are often best described by frequency tables, which provide the counts of the number of occurrences of each level of the categorical variable.
#' 
## ------------------------------------------------------------------------------------------------
table(math$sex)

#' Additionally, we can transform this into a table of proportions, rather than frequencies, by using the `prop.table` function to transform the output of `table`. 
#' 
## ------------------------------------------------------------------------------------------------
prop.table(table(math$sex))

#' 
#' We can also convert such table into a bar plot, by using the `barplot` function.
#' 
## ------------------------------------------------------------------------------------------------
barplot(table(math$Mjob))

#' 
#' 
## ------------------------------------------------------------------------------------------------
barplot(prop.table(table(math$Mjob)),
        names.arg = c("At home", "Health", "Other", "Services", "Teacher"))

#' 
#' 
#' The `table` function can also be used for _cross-tabulation_ - creating a table summarizing the count of observations in the overlap of two categories. In the example we look at the relationship between the reason for choosing the particular school and paid classes attendance.
#' 
## ------------------------------------------------------------------------------------------------
table(math$reason, math$paid)

#' 
#' It appears that students who chose the school because of their course preference were less likely to attend extra paid classes than students choosing the school for other reasons. 
#' 
#' This can be made more apparent if we substitute frequencies with proportions:
#' 
## ------------------------------------------------------------------------------------------------
prop.table(table(math$reason, math$paid))

#' 
#' Note that in this case, the proportions are calculated with respect to the total count of participants (i.e. they add up to 1). For comparison purposes, it might be useful to look at the proportion with respect to the total of each of the categories. This can be specified by the `margin` argument. By setting it to 1, we calculate the proportions with respect to the row margins, i.e. divide the counts of individuals in the `paid` variable by the total of each category of the `reason` variable.
#' 
## ------------------------------------------------------------------------------------------------
prop.table(table(math$reason, math$paid), margin = 1)

#' 
#' By analogy, `margin = 2` leads to the division by the column margins, i.e. sums of both categories of the `paid` variable.
#' 
## ------------------------------------------------------------------------------------------------
prop.table(table(math$reason, math$paid), margin = 2)

#' 
#' ### Customizing visualizations 

#' 
#' In the previous sections, we discussed some basic tools for data visualizations in R, such as histograms, scatter plots, box plots or bar charts. R base graphics allows the user to create powerful and great-looking visualizations. However achieving can be quite complicated. Because of that, a dedicated called `ggplot2` was created to enable creating good-looking and informative visualziations with much simpler user interface. The [data visualization](#visualization) chapter covers this in more detail. However, in case you wanted to start preparing visualizations for other purposes than exploratory data analysis, you might find some of the tips below useful:
#' 
#' #### Changing axis labels 

#' 
#' In case of every plot in R you can change the axis labels by using the `xlab` and `ylab` arguments:
#' 
## ------------------------------------------------------------------------------------------------
plot(math$G1, math$G2, xlab = "Grade in term 1", ylab = "Grade in term 2")

#' 
#' You can also add the title by specifying the `main` argument:
#' 
## ------------------------------------------------------------------------------------------------
plot(math$G1, math$G2, 
     xlab = "Grade in term 1", ylab = "Grade in term 2",
     main = "Student grades")

#' 
#' 
#' The color of the objects in the plot can be altered using the `col` argument:
#' 
## ------------------------------------------------------------------------------------------------
plot(math$G1, math$G2, 
     xlab = "Grade in term 1", ylab = "Grade in term 2",
     main = "Student grades",
     col = "red")

#' 
#' It can also be specified as character vector, with a different color for each point:
#' 
## ------------------------------------------------------------------------------------------------
col_gender <- rep("red", nrow(math))
col_gender[which(math$sex == "F")] <- "blue"
plot(math$G1, math$G2, 
     xlab = "Grade in term 1", ylab = "Grade in term 2",
     main = "Student grades",
     col = col_gender)

#' 
#' To make it more informative, you can also add a legend using the `legend` function:
#' 
## ------------------------------------------------------------------------------------------------
col_gender <- rep("red", nrow(math))
col_gender[which(math$sex == "F")] <- "blue"
plot(math$G1, math$G2, 
     xlab = "Grade in term 1", ylab = "Grade in term 2",
     main = "Student grades",
     col = col_gender)
legend('bottomright', 
       legend = c('Female', 'Male'),
       col = c('blue', 'red'), pch = 1)

#' 
#' 
#' 
#' 
#' You can also change the limits of each of the axes, by specifying the `xlim` and `ylim` arguments
#' 
## ------------------------------------------------------------------------------------------------
col_gender <- rep("red", nrow(math))
col_gender[which(math$sex == "F")] <- "blue"
plot(math$G1, math$G2, 
     xlab = "Grade in term 1", ylab = "Grade in term 2",
     main = "Student grades", xlim = c(0, 30), ylim = c(0, 30))

#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
 