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


longbeach$color_con <- if(primary_color = )


# create basic table stratified by sex and use helper function to find sleep variables
#then label and get rid of missing
#then add p-values
tbl_summary(
	longbeach,

	by = sex_cat,

	include = c(
		race_eth_cat, region_cat, income, starts_with("sleep")
	),

	label = list(
		race_eth_cat ~ "Race/ethnicity",
		region_cat ~ "Region",
		sleep_wkdy ~ "Sleep on Weekdays",
		sleep_wknd ~ "Sleep on Weekends",
		income ~ "Income"
	),
	statistic = list(starts_with("sleep") ~ "min = {min}; max = {max}",
									 income ~ "{p10} to {p90}"),
	digits = list(starts_with("sleep") ~ c(1, 1),
								income ~ c(3, 3))
	|>
		add_p(test = list(
			all_continuous() ~ "t.test",
			all_categorical() ~ "chisq.test"
		)) |>
		add_overall()



	df$Status <- ifelse(df$Status == TRUE, "Yes", "No")
