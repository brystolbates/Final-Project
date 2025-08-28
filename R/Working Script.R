install.packages("here")
install.packages("tidyverse")
install.packages("gtsummary", dependencies = TRUE)
library(here)
library(tidyverse)
library(gtsummary)


# Load data, already cleaned

longbeach <- read_csv(here::here("data", "longbeach.csv") #dataset read in & here usage 1
)

num_categories <- length(unique(longbeach$intake_type))
print(num_categories)


tbl_summary(
	longbeach,

	by = outcome_is_dead,

	include = c(animal_type, intake_type, outcome_type, primary_color)
)
