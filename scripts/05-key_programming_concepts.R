#' # (PART) ADVANCED DATA MANIPULATION 

#' 
#' # Key Programming Concepts 

#' 
#' 
#' 
#' 
#' 
#' 
#' ## Content
#' 
#' To make the data analysis more efficient, it is crucial to understand some of the crucial programming concepts. In the first part of this section we discuss for loops and if statements. These are so-called "control flow statements", which are common to almost all programming languages. The second part will discuss the creation and basic usage of functions. Finally, the third part will go through the `sapply()` function family, a common tool used in R to apply functions over objects multiple times. 
#' 
#' ### Control flow statements 

#' 
#' ### For loops 

#' 
#' For loops are essentially a way of telling the programming language "perform the operations I ask you to do N times". A for loop in R beginns with an `for()` statement, which is followed by an opening curly brace `{` in the same line - this is esentially *opening the for-loop*. After this, usually in a new line, you place the code which you want to execute. Then, in the last line you *close the for loop* by another curly brace `}`. You can execute the for loop by placing the cursor either on the for statement (first line) or the closing brace (last line) and executing it as any other code. Below, you can see the for loop printing the string `"Hello world!"` 5 times
#' 
## ------------------------------------------------------------------------------------------------
for(i in 1:5) {
  print("Hello world")
}

#' 
#' The `i` in the for statements is the variable that will sequentially take all the values of the object (usually a vector) specified on the right hand side of the `in` keyword. In majority of the cases, the object is a sequence of integers, as in the example below, where `i` takes the values of each element of the vector `1:5` and prints it.
#' 
## ------------------------------------------------------------------------------------------------
for(i in 1:5) {
  print(i)
}

#' 
#' A for loop could be used to add a constant to each element of a vector:
#' 
## ------------------------------------------------------------------------------------------------
x <- c(4, 5, 1, 2, 9, 8, 0, 5, 3)
x
#for all integers between 1 and length of vector x:
for(i in 1:length(x)) { 
  x[i] <- x[i] + 5
}
x

#' 
#' However, in R this is redundant, because of **vectorization** (see the [section on vectors](#vectors) from chapter 2). The above statement os equivalent to:
#' 
## ------------------------------------------------------------------------------------------------
x <- c(4, 5, 1, 2, 9, 8, 0, 5, 3)
x + 5

#' 
#' This is not only simpler, but also more efficient. 
#' 
#' Another, more practical aplication of the for loop could examine all columns of a data frame for missing values, so that:
#' 
## ------------------------------------------------------------------------------------------------
dev <- read.csv("data/un_data/dev2018.csv",
                stringsAsFactors = FALSE)
missing <- numeric() #create empty numeric vector
for (i in 1:length(dev)){
  missing[i] <- sum(is.na(dev[,i])) #get sum of missing for ith column
  names(missing)[i] <- names(dev)[i] #name it with ith column name
}
missing

#' 
#' From this, we can see that there are 0 misisng values in the country name, 1 missing value in the expected years of schooling variable and, 3 missing values in gni and life expectancy and 5 missing values in mean years of schooling.
#' 
#' 
#' 
#' While this is a bit more useful than the previous example, R still offers a shorthand method for such problems, which is discussed in more detail in the [last part of this chapter](#apply-family). In general, due to the phenomena of vectorization, for loops are rarely used in simple data analysis in R. However, they are a core element of programming as such, therefore it's important to understand them. In fact, vectorization is made possible only because of for loops being used by R in the background - simply their faster and more efficient versions.
#' 
#' 
#' ### If statements 

#' 
#' If statements are another crucial programming concept. They essentially allow performing computation *conditionally* on a logical statement. In other words, depending on a [logical expression](logical-values-and-operators) an operation is performed or not. If loops in R are constructed in the following way:
#' 
#' 
#' 
#' 
#' Where `logical_expression` must an expression that evaluates to a logical value, for example `X > 5`, `country == "France"` or `is.na(x)`. `operations` are performed if and only if the `logical_expression` evaluates to `TRUE`. The simples possible example would be
#' 
## ------------------------------------------------------------------------------------------------
x <- 2
if (x > 0) {
  print("the value is greater than 0")
}

x <- -2
if (x > 0) {
  print("the value is greater than 0")
}

#' 
#' 
#' If is naturally complemented by the `else` clause, i.e. the operations that should be performed otherwise. The general form of such statement is:
#' 
#' 
#' 
#' 
#' In this case, R first checks if the `logical_expression` evaluates to `TRUE`, and if it doesn't, performs the `other_operations`. For example:
#' 
## ------------------------------------------------------------------------------------------------
x <- -2
if (x > 0) {
  print("the value is greater than 0")
} else {
  print("the value is less or equal than 0")
}

#' 
#' Finally, `else if` allows to provide another statement to be evaluated. The general form of such statement would be:
#' 
#' 
#' 
#' 
#' Here, R first checks the `logical_statement`, if it's `FALSE` then it proceeds to check the `other_logical_statement`. If the second one is `TRUE` if performs the `other_operation` and if it's `FALSE` it proceeds to perform the `yet_another_operation`. An extension of the previous example:
#' 
## ------------------------------------------------------------------------------------------------
x <- 2
if (x > 0) {
  print("The value is positive")
} else if (x < 0) {
  print("The value is negative") 
} else {
  print("The value is 0")
}

#' 
#' IF-ELSE statments can be used to conditionally replace values. For example, suppose that we want to create a variable that is 1 when country is France and 0 otherwise. We could do that by:
#' 
## ------------------------------------------------------------------------------------------------
dev$france <- 0
for (i in 1:nrow(dev)) {
  if (dev$country[i] == "France") {
    dev$france[i] <- 1
  }
}

dev$france[dev$country == "France"]

#' 
#' Again, because of vectorization, R offers a shorthand for this, through the `ifelse()` function:
#' 
## ------------------------------------------------------------------------------------------------
dev$france <- ifelse(dev$country == "France", 1, 0)
dev$france[dev$country == "France"]

#' 
#' 
#' When you look at the documentation  `?ifelse`, you can see that it takes three arguments - `test`, `yes` and `no`. The `test` argument is the logical condition - same as `logical_statement` in the `if`, with the small subtle difference that it can evaluate to a logical vector rather than one single logical value. The `yes` argument is the value returned by the function if the `test` is `TRUE` and the `no` argument is returned when `test` is `FALSE`. You can fully see this in the example below:
#' 
#' 
## ------------------------------------------------------------------------------------------------
ifelse(c(TRUE, FALSE, FALSE, TRUE), "yes", "no")
ifelse(c(TRUE, FALSE, FALSE, TRUE), 1, 0)

#' 
#' 
#' ### Functions 

#' 
#' R is known as a *functional programming language* - as you have already seen, almost all of the operations performed are done using functions. It is also possible to create our own, custom functions by combining other functions and data structures. This is done using the `function()` keyword. The general syntax of a function looks as follows:
#' 
#' 
#' 
#' 
#' As with any R object, you can use almost any name instead of `function_name`. Arguments are separeted by commas (in the above example `arg1`, `arg2`) - these are the objects you pass to your function on which you perform some arbitrary `operations`. Again, the arguments can have arbitrary names, but you need to use them within the function consistently. Finally, most of the functions return a value - this is the last object called within the function (`output` in the above example).
#' 
#' After creating the function we can run it, exactly the same way as we would with any of R's built-in functions. A simple example could return the number of missing values in an object:
#' 
## ------------------------------------------------------------------------------------------------
count_na <- function(x) {
  sum(is.na(x))
}

count_na(dev$mys)

#' 
#' We could also implement our own summary statistics function, similar to `describe()` discussed in [the previous chapter](#exploratory):
#' 
## ------------------------------------------------------------------------------------------------
summary_stats <- function(x) {
  if (is.numeric(x)) {
    list(Mean = mean(x, na.rm = TRUE), 
                SD = sd(x, na.rm = TRUE), 
                IQR = IQR(x, na.rm = TRUE))
  } else if (is.character(x)) {
    list(Length = length(x), 
                  Mean_Nchar = mean(nchar(x)))
  } else if (is.factor(x)) {
  list(Length = length(x), 
       Nlevels  = length(levels(x)))
  }
}

#' 
#' Let's walk through the above function Given a vector `x`, the function :
#' 1. Checks whether `x` is a numeric vector. If so, returns a list of it's mean, standard deviation and interquartile range.
#' 2. Else, checks if `x` is a character vector. If so, returns a list containng its length and average number of characters.
#' 3. Else, checks if `x` is a factor. If so returns a list containing its length and average number of character.
#' 
#' We can see how it works below:
#' 
## ------------------------------------------------------------------------------------------------
summary_stats(c(1, 2, 3, 10))
summary_stats(dev$country)
summary_stats(as.factor(dev$country))

#' 
#' 
#' #### Keyword arguments 

#' 
#' Many of the functions used in R come with so-called *default* arguments - this was already mentioned in [sorting](#sorting). When defining our own functions, we can make use of that functionality as well. For example, the `count_na` example can be modified in the following way:
#' 
## ------------------------------------------------------------------------------------------------
count_na <- function(x, proportion = TRUE) {
  num_na <- sum(is.na(x))
  if (proportion == TRUE) {
    num_na/length(x)
  } else {
    num_na
  }
}

#' 
#' The `proportion` argument controls whether the function returns the number of NAs as value or as proportion of the entire vector:
#' 
## ------------------------------------------------------------------------------------------------
count_na(dev$gni)
count_na(dev$gni, proportion = TRUE) #same as above
count_na(dev$gni, proportion = FALSE)

#' 
#' 
#' There are couple of reasons why functions are frequently applied when analyzing data:
#' 1. *To avoid repetition* - often, you need to perform the same operation repeatedly - sometimes on a dataframe with tens or hunderds of columns or even multiple data frames. To avoid re-writing the same code over and over again (which always increases the chance of an error occuring).
#' 2. *To enhance clarity* - when you perform a long and complicated series of operations on a dataset, it's often much easier to break it down into functions. Then when you need to come back to your code after a long time, it is often much easier to see `recode_missing_values(data)` appear in your code, with the `record_missing_values` function defined somewhere else, as you don't need to go through your code step by step, but only understand what particular functions return.
#' 3 *To improve performance* - while most of the operations we've seen in R take fractions of seconds, larger data can often lead to longer computation times. Functions can be combined with other tools to make computation more elegant and quicker - some of these methods are discussed in the next section.
#' 
#' 
#' ### Sapply 

#' 
#' Recall the code we used to check each column of our data frame for missingness in the [for loops section](for-loops):
#' 
## ------------------------------------------------------------------------------------------------
missing <- numeric() #create empty numeric vector
for (i in 1:length(dev)){
  missing[i] <- sum(is.na(dev[,i])) #get sum of missing for ith column
  names(missing)[i] <- names(dev)[i] #name it with ith column name
}

#' 
#' We could re-write it using our new knowledge of functions, such that:
#' 
## ------------------------------------------------------------------------------------------------
count_na <- function(x) {
  sum(is.na(x))
}

missing <- numeric()
for (i in 1:length(dev)) {
  missing[i] <- count_na(dev[,i])
  names(missing)[i] <- names(dev)[i]
}
missing

#' 
#' While this may look a bit more fancy, in fact more code was used to perform this operation and it doesn't differ too much in terms of clarity. The exact same result can be achieved using the `sapply()` function. `sapply()` takes two arguments - an R object, such as a vector and a data frame and a function. Then, it applies the function to each element of this object (i.e. value in case of vectors, column/variable in case of data frames). 
#' 
## ------------------------------------------------------------------------------------------------
sapply(dev, count_na)

#' 
#' The result is exactly the same as in the previous case. `sapply()` used the `count_na` function on each columns of the `dev` dataset.
#' 
#' When using short, simple functions, `sapply()` can be even more concise, as we can defined our function without giving it a name. In the example below, instead of defining `count_na` separately, we define it directly within the `sapply()` call (i.e. inside the parentheses). This yields the same result. 
#' 
## ------------------------------------------------------------------------------------------------
sapply(dev, function(x) sum(is.na(x)))

#' 
#' 
#' Consider the function below. What do you expect it to return? Try going through each element of the code separately. You can check how the `rowSums` command works by typing `?rowSums` into the R console.
#' 
## ------------------------------------------------------------------------------------------------
quartile <- function(x) {
  quantiles <- quantile(x, c(0.25, 0.5, 0.75), na.rm = TRUE)
  comparisons <- sapply(quantiles, function(y) y <= x)
  rowSums(comparisons) + 1
}

#' 
#' The function takes a vector as input and computes three quantiles of its values - 25%, 50%, 75%. You may recall from the [previous chapter](#exploratory) that quantiles are cut points that divide a variable into ranges of equal proportions in the data set. The resulting `quantiles` vector consists of three values, corresponding with thre three quantiles. We then use `sapply` on these three values to compare each of them with the value of the `x` vector. As a result, we obtain a 3 x n array, where n is length of `x`. For each of the values of `x` we get three logical values. Each of them is `TRUE` when the corresponding value of x was larger than the quantile and `FALSE` if the corresponding value of x was lower than the quantile. We can then sum the results by row, using `rowSums`. Our final result is a vector with values of 0, 1 and 2. Its value is 0 if the corresponding value of x was less than all quartiles, 1 if it was greater or equal than the .25, 2 if it was greater or equal than 0.5 and 3 if it was greater or equal than all of them. We then finally add 1 to each, so that they correspond to true quartile numbers (1st quartile, rather than 0th quartile, etc).
#' 
#' We can then use the `split` function, which takes a data frame and a vector as input and splits the data frame into several parts, each with the same value of the splitting variable. As a result, we obtain `dev_split` dataset, which stores 4 data frames, each only with countries in the respective quantile of expected years of schooling.
#' 
## ------------------------------------------------------------------------------------------------
dev_split <- split(dev, quartile(dev$eys))
head(dev_split[[1]])

#' 
#' You can then look at descriptive statistics of each of the quartiles using:
#' 
## ------------------------------------------------------------------------------------------------
sapply(dev_split, summary)

#' 
#' 
#' While working an R and looking for help online, you may stumble upon other variants of the `sapply()` functions. Essentially, all R functions with `apply` in their name serve the same purpose - applying a function to each element of an object. `lapply()` is a less user friendy version of `sapply()`, which always returns a list, not a vector. `vapply()` forces the user to determine the type of the output, which makes its behaviour more predictible and slightly faster. `tapply()` applies the function to data frame by group determined by another variable - a similar procedure to what we did using `split()` and `sapply()`, but in less steps.
#' 
#' 
#' 
#' 
#' 
#' 
 