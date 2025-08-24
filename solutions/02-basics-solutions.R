#' ## Exercises
#' 
#' 
#' 1. The code below creates three vectors corresponding with individual's name, birth year and birth month. 
#' 
## ------------------------------------------------------------------------------------------------
year <- c(1976, 1974, 1973, 1991, 1972, 1954, 
          1985, 1980, 1994, 1970, 1988, 1951, 
          1957, 1966, 1968, 1963, 1999, 1977, 
          1984, 1998)

month <- c("February", "February", "April",
           "August", "September", "November", 
           "October", "December", "May", "March", 
           "June", "November", "October", "May", 
           "July", "August", "March", "July", 
           "October", "January")

name <- c("Thomas", "Natalie", "James", 
          "Gina", "Cate", "Rob", "Frank",
          "Tyle", "Marshall", "Ted", "Emily", 
          "Brandon", "Yasmin", "Tina", 
          "Phillip", "Natasha", "Joan", 
          "Jack", "Alice", "Barney")

#' 
#' a. Create a vector named birthdays which contains names, birth months and birth years of each person. For example, the first one should look like `"Thomas, February 1976`.
#' 
#' 
## ------------------------------------------------------------------------------------------------
#ANSWER
birthdays <- paste0(name, ", ", month, " ", year) # This works just as well with paste(), but paste0() gets rid of unwanted spaces between characters. 

#' 
#' 
#' b. Filter out the people who were born in October after the year 1980. Store their names in vector named `oct1980`
#' 
## ------------------------------------------------------------------------------------------------
#ANSWER
oct1980 <- name[year > 1980 & month == "October"] # we access the elements of the "name" vector here with the squared brackets and tell R to only give us those which conform to the criteria specified in the brackets.  

#' 
#' 
#' 
#' 
#' 
#' 2. Given the vector x <- c(5, 40, 15, 10, 11). What would output would you expect from the following functions?
#'   a. `sort(x)`
#'   b. `order(x)`
#'   c. `rank(x)`
#' 
#' Use R to verify your answers.
#' 
#' 
#' 3. Vector `country` contains the names of 6 countries and the following 4 vectors contain the countries' correspondig Expected Years of Schooling, `eys`, Mean Years of Schooling `mys`, Life Expectancy at Birth `lexp` and Per capita Gross National Income `gni`.
#' 
## ------------------------------------------------------------------------------------------------
country <- c("Argentina", "Georgia",
             "Mexico", "Philippines",
             "Turkey", "Ukraine")
eys <- c(17.6, 15.4, 14.3, 12.7, 16.4, 15.1)
mys <- c(10.6, 12.8, 8.6, 9.4, 7.7, 11.3)
lexp <- c(76.5, 73.6, 75, 71.1, 77.4, 72)
gni <- c(17611, 9570, 17628, 9540, 24905, 7994)


#' 
#' The United Nations Human Development Index (HDI) is given by the following formula:
#' 
#' HDI = $\sqrt[3]{\text{Life Expectancy Index} * \text{Education Index} * \text{Income Index}}$, where
#' 
#' Life Expectancy Index = $\frac{\text{Life Expectancy}-20}{85-20}$
#' 
#' Education Index = $\frac{\text{Mean Years of Schooling Index} + \text{Expected Years of Schooling Index}}{2}$
#' 
#' Mean Years of Schooling Index = $\frac{\text{Mean Years of Schooling}}{15}$
#' 
#' Expected Years of Schooling Index = $\frac{\text{Expected Years of Schooling}}{18}$
#' 
#' Income Index = $\frac{ln(GNIpc) - ln(100)}{ln(75,000) - ln(100)}$
#' 
#' 
#' Write R code to answer the following questions:
#' 
#' a. Calculate the HDI for each of the countries. 
#' 
## ------------------------------------------------------------------------------------------------
#ANSWER

#all of these are applying the formulae given in the exercise to the data you entered.
#life exp. index
lexp_ind <- (lexp - 20) / (85 - 20)

#education index
edu_ind <- (mys / 15 + eys / 18) / 2

#income index
inc_ind <- (log(gni) - log(100)) / (log(75000) - log(100))

#hdi
hdi <- (lexp_ind * edu_ind * inc_ind) ^ (1 / 3)


#' 
#' 
#' 
#' b. Store country names with HDI lower than 0.75 in vector `coutry_lhdi`. Print the names of the countries.
#' 
## ------------------------------------------------------------------------------------------------
#ANSWER
country_lhdi <- country[hdi < 0.75] # same logic as in 1b, we are singling out those countries which meet the criterion specified in squared brackets
country_lhdi

#' 
#' 
#' 
#' c. Store country names with HDI lower than 0.8 and GNI higher than $10000 in vector `country_hlgh`
#' 
## ------------------------------------------------------------------------------------------------
#ANSWER
country_hlgh <- country[hdi < 0.8 & gni > 10000] # same logic as in 1b, we are singling out those countries which meet the criteria specified in squared brackets
country_hlgh

#' 
#' 
#' 
#' d. Print names of the countries with HDI at least as high as HDI of Turkey (excluding Turkey).
#' 
## ------------------------------------------------------------------------------------------------
#ANSWER
country[hdi >= hdi[country == 'Turkey'] & country != 'Turkey'] # same logic as in 1b, we are singling out those countries which meet the criteria specified in squared brackets

#' 
#' 
#' 
#' 
#' e. Print names of the countries in which the Expected Years of Schooling index is higher than the Life Expectancy Index.
#' 
## ------------------------------------------------------------------------------------------------
#ANSWER
eys_ind <- eys/18 #expected years of schooling index
country[eys_ind > lexp_ind] # same logic as in 1b, we are singling out those countries which meet the criterion specified in squared brackets

#' 
#' 
#' 
#' 
#' 
#' 4. The data below contains the records of UK General Election turnout between 1964 and 2019.
#' 
## ------------------------------------------------------------------------------------------------
turnout <- c(0.771, 0.758, 0.72, 0.788, 0.728, 0.76, 0.727, 0.753, 0.777, 0.714, 0.594, 0.614, 0.651, 0.661, 0.687, 0.673)

year <- c(1964, 1966, 1970, 1974, 1974, 1979, 1983, 1987, 1992, 1997, 2001, 2005, 2010, 2015, 2017, 2019)

party <- c("Labour", "Labour", "Conservative", "Labour",
           "Labour", "Labour", "Conservative",
           "Conservative", "Conservative",
           "Conservative", "Labour", "Labour", "Labour",
           "Conservative", "Conservative", 
           "Conservative")

#' 
#' Write code to answer the following questions:
#' 
#' a. Which years had the turnout higher than 70/%?
#' 
## ------------------------------------------------------------------------------------------------
#ANSWER
year[turnout > 0.7] # same logic as in 1b, we are singling out those years which meet the criterion specified in squared brackets

#' 
#' 
#' 
#' b. Which parties won in elections with turnout below 0.65?
#' 
## ------------------------------------------------------------------------------------------------
#ANSWER
party[turnout < 0.65] # same logic as in 1b, we are singling out those parties which meet the criteria specified in squared brackets

#' 
#' 
#' 
#' 
#' c. Obtain the years in which the turnout was the lowest and the highest and store them in vector `year_minmax`.
#' 
## ------------------------------------------------------------------------------------------------
#ANSWER
year_minmax <- c(year[which.min(turnout)], year[which.max(turnout)]) #c() stands for concatenate and creates a new vector, Into this we store the results of the which.min and which.max functions. 

#or

year_minmax <- year[order(turnout)][c(1, length(year))] # this creates a new vector in which the years are ordered by turnout. You have to look at the first and last value to answer the question. 


#' 
#' 
#' 
#' 
#' d. Store the names of the parties which won in the 3 elections with the highest turnout in vector `top3`
#' 
## ------------------------------------------------------------------------------------------------
#ANSWER
top3 <- party[order(turnout, decreasing = TRUE)][1:3] # we access the vector party and specify a criterion for displaying cases. We first order order them by decreasing turnout, and then ask R to list observations 1 to 3. 

#' 
#' 
#' *The solutions for the exercises will be available here on `r config$basics`.*
#' 
#' 
 