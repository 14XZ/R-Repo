# ============================ Import data from SQL database ===========================================
install.packages("RMySQL")
library(RMySQL)

# establish connection
library(DBI)
#The first argument has to be a DBIdriver object, that specifies how connections are made
con <- dbConnect(RMySQL::MySQL(), 
                 dbname = "tweater", 
                 host = "courses.csrrinzqubik.us-east-1.rds.amazonaws.com", 
                 port = 3306,
                 user = "student",
                 password = "datacamp")

#list and import tables
dbListTables(con) #see what tables the database contains.

dbReadTable(con, "users") #show data in the "users" table.

dbDisconnect()

# Get table names
table_names <- dbListTables(con)

# Import all tables 
tables <- lapply(table_names, dbReadTable, conn = con)


#filtering while importing
con <- dbConnect(RMySQL::MySQL(),
          dbname = "company",
          host = "courses.csrrinzqubik.us-east-1.rds.amazonaws.com",
          port = 3306,
          user = "student",
          password = "datacamp")

dbListTables(con)

#this way more efficient when using large database or database that limit query numbers
dbGetQuery(con, "SELECT name FROM employees WHERE started_at > \"2012-09-01\"")

#SQL: SELECT variable FROM dataset WHERE condition
specific <- dbGetQuery(con, "SELECT message FROM comments WHERE tweat_id = 77 AND user_id > 4")
short <- dbGetQuery(con, "SELECT id, name FROM users WHERE CHAR_LENGTH(name) < 5")

#Joining in SQL
"SELECT name, post FROM users INNER JOIN tweats on users.id = user_id WHERE date > "2015-09-19\""

#keep fethcing record
# Send query to the database
res <- dbSendQuery(con, "SELECT * FROM comments WHERE user_id > 4")

while(!dbHasCompleted(res)) {
  chunk <- dbFetch(res, n = 1)
  print(chunk)
  }

#============================================= HTTP data =============================================
library(readr)
url_csv <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/swimming_pools.csv"

download.file(url, dest_path)

# Load the readxl and gdata package
library(readxl);library(gdata)


# Specification of url: url_xls
url_xls <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/latitude.xls"

# Import the .xls file with gdata: excel_gdata
excel_gdata <- read.xls(url_xls)

# Download file behind URL, name it local_latitude.xls
download.file(url_xls,"local_latitude.xls")

# Import the local .xls file with readxl: excel_readxl
excel_readxl <- read_excel("local_latitude.xls")


# ================= HTTP ======================
# Load the httr package
library(httr)

# Get the url, save response to resp
url <- "http://www.example.com/"

resp <- GET(url)

# Print resp
print(resp)

# Get the raw content of resp: raw_content
raw_content <- content(resp, as = "raw")

# Print the head of raw_content
head(raw_content)

# Get the url
url <- "http://www.omdbapi.com/?apikey=ff21610b&t=Annie+Hall&y=&plot=short&r=json"


# Print resp
resp <- GET(url)
print(resp)

# Print content of resp as text
content(resp, as = "text")


#                       ======================== API and JSON =========================
# Load the jsonlite package
library(jsonlite)

# wine_json is a JSON
wine_json <- '{"name":"Chateau Migraine", "year":1997, "alcohol_pct":12.4, "color":"red", "awarded":false}'

# Convert wine_json into a list: wine
wine <- fromJSON(wine_json)

# Print structure of wine
str(wine)

# foreign package
library(foreign)
# Specify the file path using file.path(): path
path <- file.path("worldbank/edequality.dta")
edu_equal_1 <- read.dta(path)
edu_equal_2 <- read.dta(path, convert.factors = FALSE)
edu_equal_3 <- read.dta(path, convert.underscore = TRUE)



#                                       SQL query 
SELECT * FROM people LIMIT 10 # select all the column from people table up to 10 rows

SELECT DISTINCT country FROM films #Get all the unique countries represented in the films table.

SELECT COUNT(*) FROM people; #count the number of rows in all column of people table.
  
SELECT title, release_year FROM films WHERE language = 'Spanish' AND release_year < 2000

# Multiple Conditions
SELECT title, release_year
FROM films
WHERE (release_year >= 1990 AND release_year < 2000)
AND (language = 'French' OR language = 'Spanish')

#Between Operator
SELECT title, release_year FROM films 
WHERE (release_year BETWEEN 1990 and 2000)
AND (budget > 100000000)
AND (language = 'Spanish' OR language = 'French')

#IN operator
SELECT title, release_year
FROM films
WHERE (release_year IN (1990, 1993, 1995, 1998))
AND duration > 120

# CHECK FOR NULL
SELECT COUNT(*)
FROM people
WHERE birthdate IS NULL

# find people who are alive
SELECT name 
FROM people 
WHERE deathdate IS NULL


# LIKE operator
SELECT name
FROM companies
WHERE name LIKE 'Data%'; 
#The % wildcard will match zero, one, or many characters in text.
#For example, the following query matches companies like 'Data', 'DataC' 'DataCamp', 'DataMind', and so on

SELECT name
FROM companies
WHERE name LIKE 'DataC_mp';
#The _ wildcard will match a single character. For example, the following query matches companies like 'DataCamp', 'DataComp', and so on

SELECT name
FROM people
WHERE name LIKE '_r%'
#Get the names of people whose names have 'r' as the second letter. 

#Aggregate functions
SELECT AVG(budget) #average
FROM films

SELECT MAX(budget)
FROM films;

SELECT SUM(budget)
FROM films;


#You can also use the NOT LIKE operator to find records that don't match the pattern you specify.


SELECT title, (gross - budget) AS net_profit # To alias, you use the AS keyword, which you've already seen earlier in this course.
FROM films

SELECT AVG(duration)/60.0 AS avg_duration_hours
FROM films

SELECT count(deathdate)*100.0/COUNT(*) AS percentage_dead
FROM people


SELECT (MAX(release_year) - MIN(release_year))/10 AS number_of_decades
FROM films

#ORDER BY operator
SELECT title
FROM films
ORDER BY release_year DESC;

SELECT name 
FROM people
ORDER BY name

#order by 2 variable
SELECT birthdate, name
FROM people
ORDER BY birthdate, name

#GROUP BY operator
SELECT sex, count(*)
FROM employees
GROUP BY sex

SELECT release_year, country, MAX(budget)
FROM films
GROUP BY release_year, country
ORDER BY release_year, country

SELECT release_year
FROM films
GROUP BY release_year
HAVING COUNT(title) > 10

SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year >1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
ORDER BY AVG(gross) DESC


SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year >1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
ORDER BY AVG(gross) DESC

#JOIN tables in SQL
SELECT title, imdb_score
FROM films
JOIN reviews
ON films.id = reviews.film_id
WHERE title = 'To Kill a Mockingbird';
