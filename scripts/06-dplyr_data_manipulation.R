#' # Data Manipulation 

#' 
#' 
#' 
#' 
#' 
#' 
#' ## Content 
#' 
#' While we have already discussed some methods for data manipulation, such as indexing, subsetting and modifying data frames, the majority of R users approach this task using a dedicated collection of packages called `tidyverse`, introduced by Hadley Wickham, a statistician from New Zealand. While it may seem like this chapter covers tools for performing task that you are already familiar with, `tidyverse` follows a different philosophy than traditional R, and has a lot of advantages including better code readability and efficiency. As before, to install and load the package, simply run the code below. Remember, that you only need to call `install.packages` once, to download all the required files from CRAN. `library` needs to be called every time you start a new R session to attach the library functions to your working environment. 
#' 
#' 
#' 
#' 
#' 
#' ### Reading the data 

#' 
#' In this chapter, we will use the same dataset we've used in the [exploratory analysis chapter](#exploratory), which presents individual-level information about a sample of students. However, `tidyverse` offers an improved set of functions for reading in the data, as part of the `readr` subpackage - they work fairly similar to `read.csv` introduced before, however have some advantages (for example they read character columns to `character` vectors, rather than `factors` without having to include the `stringsAsFactors` argument, which was discussed in [chapter 3](reading-from-csv). All the `readr` reading functions start with `read_` and are used for different file types. The most usual one is `read_csv` (which you can use in exactly the same way as `read.csv`), however in this case we use `read_delim`, which allows us to read file with any delimiter. In case of the `math` dataset each row is separated by a semicolon (which you can check by opening the file via a notebook app). Because of that we specify for the second `delim` argument as in the example below:
#' 
## ------------------------------------------------------------------------------------------------
math <- read_delim("data/student/student-mat-data.csv", delim = ";")

#' 
#' As you can see, running the function returns a message, which shows the specification of each column that was read - `col_character` refers to `character` columns, while `col_double()` means `numeric` columns. You could force each column to be read as a specific type. For example, you may want a character column to be read as factors in some of the cases - for example sex. As mentioned above, the default setting of `read_` functions is to read all numbers as numeric variables and all text as character variables. 
#' 
## ------------------------------------------------------------------------------------------------
class(math$sex)

#' 
#' 
#' To read the `sex` column as factor, we can read the data again, this time specifying the `col_types` argument. The `col_types` argument takes a `list` as input, in which we specify the type of selected columns, for example sex = col_factor() to tell:
#' 
## ------------------------------------------------------------------------------------------------
math <- read_delim("data/student/student-mat-data.csv", delim = ";",
                 col_types = list(sex = col_factor(levels = c("M","F"))))
class(math$sex)

#' 
#' You may wonder why not simply use the `as.factor` or `factor` function:
#' 
## ------------------------------------------------------------------------------------------------
math$sex <- factor(math$sex, levels = c("M","F"))

#' 
#' This is exactly equivalent, however the previous way of doing this is much more explicit and concise. Anyone (including you) who reads your analysis will immedietaly know which columns have you specified to be which type.
#' 
#' The final facet of the `readr` package functions is that they load the data as a slightly different data type than the normal `read.csv`
#' 
## ------------------------------------------------------------------------------------------------
math <- read.csv("data/student/student-mat-data.csv", sep = ";")
class(math)

#' 
## ------------------------------------------------------------------------------------------------
math <- read_delim("data/student/student-mat-data.csv", delim = ";",
                 col_types = list(sex = col_factor(levels = c("M","F"))))
class(math)

#' 
## ------------------------------------------------------------------------------------------------
is_tibble(math)
is.data.frame(math)

#' 
#' The data comes loaded as a `tibble` (tbl for short). Tibbles are a special kind of data frames implemented by the `tidyverse` package - the only thing you need to know about them for know, is that _everything that you learned about data frames so far applies to tibbles_. They offer some improvements, which will not be discussed here.
#' 
#' 
#' ### The pipe operator 

#' 
#' Perhaps the most imporant innovation offered by the `tidyverse` package is the so-called _pipe operator_ `%>%`. Its use may feel a bit quirky at first, but it is extremely useful and is widely used by most of modern R users.
#' 
#' As you have learned so-far, R evaluates each function from inside out. For example, we can get the sum of missing values in a data frame by running:
#' 
## ------------------------------------------------------------------------------------------------
sum(is.na(math))

#' 
#' This essentially performs two steps - first, runs `is.na` on the math data frame, which returns a table filled with logical values, `FALSE` when a given entry is not missing and `TRUE` when it is. Then `sum` takes this table as input and adds up the values in it (treating `FALSE` as 0 and `TRUE` as 1). In many cases, such statements can get long, difficult to read and error-prone, especially when keyword arguments are specified. 
#' 
#' The same operation may be be done using the pipe operator. In this case, rather than evaluating the sequence of functions from within, they are evaluated left to right. The `%>%` operator can be understood as a way of _passing the output of the thing on the left to the thing on the right as the first argument:
#' 
## ------------------------------------------------------------------------------------------------
math %>% is.na() %>% sum()

#' 
#' In this example, the `math` data frame is passed to the `is.na` function, and then the output is passed to the `sum` function, which returns exactly the same result. As in the case of the regular call, you may store the output in a variable:
#' 
## ------------------------------------------------------------------------------------------------
number_missing <- math %>% is.na() %>% sum()
number_missing

#' 
#' Before continuing we drop the missing observations:
#' 
## ------------------------------------------------------------------------------------------------
math <- math[complete.cases(math), ]

#' 
#' 
#' 
#' While this may feel slightly unintuitive in this case, it comes in very handy when performing long sequences of operations on data, as we will see in the following sections.
#' 
#' 
#' ### Dataset manipulation 

#' 
#' Three key functions are most commonly used for dataset manipulation in the `tidyverse` package: `mutate`, `select` and `filter`, coming from the `dplyr` sub-package. They are used as follows:
#' - `mutate` is used to modify and create columns in data frames
#' - `select` is used to select columns by name
#' - `filter` is used to select rows given a set of logical values
#' 
#' All three functions take the data frame as the first argument. For example, we can create a new column, grade_average by adding together grades for all three years and dividing them by 3:
#' 
## ------------------------------------------------------------------------------------------------
math <- mutate(math, average = (G1 + G2 + G3)/3)

#' 
#' 
#' 
#' Again, this is equivalent to:
#' 
## ------------------------------------------------------------------------------------------------
math$average <- (math$G1 + math$G2 + math$G3)/3

#' 
#' 
#' As both operations create a variable called `average` by adding `G1`, `G2` and `G3` toegether, and dividing them by three. Not however, that in case of `mutate` there's no need to specify the `$` opearator, as you pass the `math` data frame as the first arguments, so the function knows that the `G1`, `G2` and `G3` names refer to this particular data frame. The `mutate` function returns the same data frame, but with the additional column `average`. Most commonly, it is used with the pipe operator:
#' 
## ------------------------------------------------------------------------------------------------
math <- math %>% mutate(average = (G1 + G2 + G3)/3)

#' 
#' In this case, through the `%>%` we pass the `math` data frame to `mutate`, which creates a new column and returns the updated data.frame, which is stored in `math`. 
#' 
#' `filter` allows you to filter rows of the data frame, which is an operation similar to indexing. For example, we can get students with average grade higher than 10 by:
#' 
## ------------------------------------------------------------------------------------------------
math %>% filter(average > 18)

#' 
#' This entire operation could be done in one step, by:
#' 
## ------------------------------------------------------------------------------------------------
math %>%
  mutate(average = (G1 + G2 + G3)/3) %>%
  filter(average > 18)

#' 
#' Note that this time we haven't modified the data frame - the variable `average` is created only temporarily, so that we can use it as a filter.
#' 
#' 
#' 
#' This query shows a bit too many columns. Suppose we wanted to narrow our search and only see the guardian of the students with average higher than 18. We could use the `select` function, which simply selects the _column_ of the data frame by name:
#' 
#' 
## ------------------------------------------------------------------------------------------------
math %>%
  mutate(average = (G1 + G2 + G3)/3) %>%
  filter(average > 18) %>%
  select(guardian)

#' 
#' This leaves us with a data frame of one column, showing guardians of the students with the best marks.
#' 
#' 
#' ### Reshaping data 

#' 
#' It's not common for social scientific to be longitudinal in nature. This means, that data in a given unit of observation (for example country, household or an individual) is observed on multiple variable (for example GDP, income, well-being) over a period of time. Such data can come in two formats - `long` and `wide`. 
#' 
#' **Wide data format** -  in the wide data format, each column represents a variable - for example, the table presented below presents grades of three students over three academic years in the wide format. Each column represents a separate year.
#' 
#' 
#' 
#' 
#' **Long data format** - in the long data format, a separate column represents the name of the variable and a separate one - value of the corresponding variable. This format is sometimes more useful for particular types of analysis such as panel data models and for visualization. You can see the student scores in the long format below:
#' 
#' 
#' 
#' 
#' We can see an example of such data by loading the dataset `gdp.csv`, which contains GDP per capita over several years for couple of European countries:
#' 
## ------------------------------------------------------------------------------------------------
gdp <- read_csv("data/world_bank/gdp.csv")

#' 
#' 
## ------------------------------------------------------------------------------------------------
head(gdp)

#' 
#' We can see that the data contains country names, as well as GDP values in years between 2000 and 2015 in the wide format. To reshape the data into the long format, we can use the `pivot_longer` function, which comes with the `tidyr` package, another element of the `tidyverse` suite. In pivot longer, we specify the dataset name as the first argument (which is usually piped to the function), followed by the column names that contain the wide-format variables (assuming that they are in order, this can be specified with a names of the left-most and right-most variable, separated by a colon). Note that in this example, we also use the inverse quotation marks, since the variable are named using numbers. The `names_to` argument specifies tha name of the variable which will be used to store the names of the re-formatted variables (in our example - years) and the `value_to` argument specifies the name of the variable which will be used to store values (GDP per capita).
#' 
## ------------------------------------------------------------------------------------------------
gdp_long <- gdp %>% pivot_longer(`2000`:`2019`, 
                                 names_to = "year", values_to = "gdp_pc")
head(gdp_long)

#' 
#' As you can see, the function produces data in a long format, with only 4 columns, but 140 rows, as opposed to the wide data which consists of only 7 rows, but 22 columns. 
#' 
#' 
#' In some cases, your data might come in a long format, yet you might want to reshape it into long. This can be done using the `pivot_wider` function. This works exactly opposite to `pivot_longer`. We first specify the data by piping it to the function and then use the `names_from` argument to specify the name of the variable containing the variable names and `value_from` to specify the variable containing the values. We end up obtaining the same data frame that we started with.
#' 
## ------------------------------------------------------------------------------------------------
gdp_wide <- gdp_long %>% pivot_wider(names_from = "year", values_from = "gdp_pc")
head(gdp_wide)

#' 
## ------------------------------------------------------------------------------------------------
all.equal(gdp_wide, gdp)

#' 
#' 
#' ### Joining 

#' 
#' The final data manipulation technique that we will discuss in this chapter is joining. In many cases we will have the dataset coming in two or more separate file, each containing different variables for the same unit for observations. This is the case with all the data coming from [World Bank Open Data](https://data.worldbank.org/), where information about each indicator comes in a separate csv file. For example, suppose we have data on GDP and population density of some countries:
#' 
## ------------------------------------------------------------------------------------------------
gdp <- read_csv("data/world_bank/gdp.csv")
pop <- read_csv("data/world_bank/pop_dens.csv")

#' 
## ------------------------------------------------------------------------------------------------
head(gdp)

#' 
## ------------------------------------------------------------------------------------------------
head(pop)

#' 
#' Suppose we want to analyze the relationship between population density and gdp per capita. To do that, it would be convenient to merge these two datasets into one, containing the variables `gdp` and `pop_dens`. We can achieve this by using _joins_. 
#' 
#' First, we pivot the data into the long format:
#' 
## ------------------------------------------------------------------------------------------------
gdp_long <- gdp %>% pivot_longer(`2000`:`2019`, 
                                 names_to = "year", values_to = "gdp_pc")
pop_long <- pop %>% pivot_longer(`2000`:`2019`, 
                                 names_to = "year", values_to = "pop_dens")

#' 
#' Note that the countries in the two datasets are different:
#' 
## ------------------------------------------------------------------------------------------------
unique(gdp_long$country)

#' 
## ------------------------------------------------------------------------------------------------
unique(pop_long$country)

#' 
## ------------------------------------------------------------------------------------------------
identical(unique(gdp_long$country), unique(pop_long$country))

#' 
#' To join two data frames, we need an ID variable (or a set of variables) that will identify observations and allow us to join them. In the example, the `country` and `year` variables are a perfect candidate, since each corresponds to one observation from a given country in a given period. We would then say that we _join the two datasets on country and year_. s
#' 
#' There are three fundamental ways in which we can approach this:
#' 
#' - **Inner join** is used to join only the observations where the variables we are joining on which appear in both datasets. The rows where the identifying variables don't match any observations in the other dataset are dropped from the resulting dataset. This join is used when we care primarily about the completeness of our data. The order of the dataframes does not matter when performing inner join.
#' 
## ------------------------------------------------------------------------------------------------
dat <- inner_join(gdp_long, pop_long, by = c("country", "ccode", "year"))
head(dat)

#' 
#' We can see that the new dataframe `dat` contains both `gdp_pc` and `pop_dens` variables. Furthermore, only the countries present in both datasets were kept:
#' 
## ------------------------------------------------------------------------------------------------
unique(dat$country)

#' 
#' - **Left join** is used to join only the observations where the variables we are joining appear in the first dataset (the one on the _left_ of the joining function). This is done primarily when we care about keeping all the observations from the first (left) dataset. The observations where no corresponding identifying values were found are turned into missing values:
#' 
## ------------------------------------------------------------------------------------------------
dat <- left_join(gdp_long, pop_long, by = c("country", "ccode", "year"))
head(dat)

#' 
#' As we can see in this example, the resulting dataset contains missing values for the countries that were not present in the `pop_long` dataset. All the countries from the `gdp_long` dataset were kept:
#' 
## ------------------------------------------------------------------------------------------------
all.equal(unique(gdp_long$country), unique(dat$country))

#' 
#' 
#' - **Full join** - joining observations from both data frames and producing missing values whenever there's an observation missing in one of them. 
#' 
## ------------------------------------------------------------------------------------------------
dat <- full_join(gdp_long, pop_long, by = c("country", "ccode", "year"))
head(dat)

#' 
#' As a result of a `full_join`, all countries including in either of the datasets are kept:
#' 
## ------------------------------------------------------------------------------------------------
unique(c(dat$country))
unique(c(gdp_long$country, pop_long$country))

#' 
#' There are some other joining techniques, such as **Filtering joins** (`semi_join` and `anti_join`), as well as `nest_join`. You can read more about these in the documentation by typing `?join` into the console.
#' 
#' 
#' ### Aggregating data 

#' 
#' While we have discussed summary statistics that can be used to summarize data, it's often very useful to compare their values across group, rather than only look at one number to describe an entire dataset. The `tidyverse` allows us to calculate summary statistics of variables through the `summarise` function. For example, to get the average GDP of countries in our data:
#' 
## ------------------------------------------------------------------------------------------------
gdp_long %>% summarise(gdp_avg = mean(gdp_pc))

#' 
#' This is no different from using `gdp_long$gdp_pc %>% mean()`, other than it returns a tibble rather than a scalar value. However, the `summarize` function is most powerful in conjunction with the `group_by` function. As the name suggests,  `group_by` function divides the data frame into groups using one of the variables. On the surface, it doesn't appear to alter much:
#' 
## ------------------------------------------------------------------------------------------------
gdp_long_groupped <- gdp_long %>% group_by(country)
gdp_long_groupped

#' 
#' 
## ------------------------------------------------------------------------------------------------
pop_long %>%
  group_by(country) %>%
  summarise(avg_pop = mean(pop_dens, na.rm = TRUE), 
            sd_pop = sd(pop_dens, na.rm = TRUE))

#' 
#' Similarily, we could compare the country's average, maximum and minimum GDP growth over the past years:
#' 
## ------------------------------------------------------------------------------------------------
gdp_long %>% 
  group_by(country) %>%
  mutate(gdp_growth = (gdp_pc - lag(gdp_pc)) / lag(gdp_pc)) %>%
  summarise(avg_growth = mean(gdp_growth, na.rm = TRUE), 
            max_growth = max(gdp_growth, na.rm = TRUE), 
            min_growth = min(gdp_growth, na.rm = TRUE)) %>%
  arrange(-avg_growth)

#' 
#' In this case, we first group the data frame by country. We then use `mutate` to compute `gdp_growth` by subtracting GDP from one year before (calculated using the `lag` function) and dividing this difference by the lagged GDP. Note that the `mutate` function also applies the computation according to the grouping defined in the `group_by` - the `lag()` is computed _within_ each country. We then use `summarise` to apply the functions. Finally, we use `arrange` to sort the output according to the negative value of the average GDP growth, i.e. in decreasing order. 
#' 
#' Since the behaviour of `group_by` affects many operations performed on a dataframe, it is important to call `ungroup()` at the end of our operations if we assign the data frame to a new name - performing operations on groupped tibbles can lead to suprising results. Coming back to our example, suppose we wanted to obtain the deviation of each country's GDP growth from the global mean of this growth. First, we would obtain the growths:
#' 
## ------------------------------------------------------------------------------------------------
gdp_growths <- gdp_long %>% 
                group_by(country) %>%
                mutate(gdp_growth = (gdp_pc - lag(gdp_pc)) / lag(gdp_pc))

#store demeaned values:
dem <- gdp_growths %>% 
  mutate(growth_dem = gdp_growth - mean(gdp_growth, na.rm = TRUE))

#stored demeaned values calculated after ungrouping
dem_ungr <- gdp_growths %>% 
  ungroup() %>%
  mutate(growth_dem = gdp_growth - mean(gdp_growth, na.rm = TRUE))

all.equal(dem$growth_dem, dem_ungr$growth_dem)

#' 
#' We can see using the `all.equal` function, that the resulting variables are different. This is because, if the tibble is still groupped, the `mutate(growth_dem = gdp_growth - mean(gdp_growth, na.rm = TRUE))` expression subtracts the _group mean_ from each observation, wheres if it's ungrouped, it calculates the _global mean_ and subtracts it. While it may seem trivial in this example, forgetting to ungroup a tibble is a common error and it is _crucial to remeber to ungroup the tibble after finishing performing operations on it_. Also note that calling `group_by()` on an already groupped tibble discards the previous groupping and applies the new one instead.
#' 
#' 
#' 
#' 
#' 
#' 
#' 
 