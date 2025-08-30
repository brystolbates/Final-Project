install.packages("here")
install.packages("tidyverse")
install.packages("gtsummary", dependencies = TRUE)
library(here)
library(tidyverse)
library(gtsummary)


# Load data, already cleaned, but going to update some categories of variables

longbeach <- read_csv(here::here("data", "raw", "longbeach.csv")) #dataset read in & here usage 1



#gtsummary table

tbl_summary(
	longbeach,

	by = outcome_is_dead,

	include = c(animal_type, intake_type, outcome_type, primary_color)
)


#want to recolor all the primary color variables to condense, going to create/use a function

#recolor_animals <- function(dataframe_name, input_column_name, new_column_name) {}



color_code <- list(
	black  = c("black", "black lynx point", "black smoke", "black tabby", "black tiger"),
	blue   = c("blue"),
	brown  = c("brown", "brown tabby",	"brown tiger", "ch lynx point", "chocolate",
						 "chocolate point", "liver", "red", "red point", "ruddy", "sable"),
	tan    = c("buff", "cream", "cream point", "cream tabby", "cream tiger",
						 "ct lynx point", "fawn", "flame point", "tan","wheat"),
	green  = c("green"),

	grey   = c("blue cream", "blue lynx point", "blue point", "blue tabby", "gray",
					 "grey","gray tabby","gray tiger", "lilac lynx point", "lilac point",
					 "lilac_cream point", "lynx point", "point", "seal", "seal point", "silver",
					 "silver lynx point", "silver tabby", "st lynx point"),
	multi   = c("calico", "calico dilute", "calico point", "calico tabby", "snowshoe",
						"torbi", "tortie", "tortie dilute", "tortie point", "tricolor"),
	orange   = c("orange","orange tabby", "orange tiger" , "peach"),
	pink     = c("pink"),
	spotted  = c("dapple", ends_with("brindle", "merle","tick") ),
	white    = c("white"),
	yellow   = c("apricot", "blonde", "gold", "yellow"),
	unknown  = c("unknown", "NA")
	)

#longbeach_test <- longbeach
#			|> mutate(

#		region_cat = factor(region, labels = c("Northeast", "North Central", "South", "West")),
#		sex_cat = factor(sex, labels = c("Male", "Female")),
		race_eth_cat = factor(race_eth, labels = c("Hispanic", "Black", "Non-Black, Non-Hispanic")),
		eyesight_cat = factor(eyesight, labels = c("Excellent", "Very good", "Good", "Fair", "Poor")),
		glasses_cat = factor(glasses, labels = c("No", "Yes"))
	)


}
