install.packages("here")
install.packages("tidyverse")
install.packages("gtsummary", dependencies = TRUE)
library(here)
library(tidyverse)
library(gtsummary)


# Load data, already cleaned, but going to update some categories of variables

longbeach <- read_csv(here::here("data", "raw", "longbeach.csv")) #dataset read in & here usage 1


#want to recolor all the primary color variables to condense, going to create/use a function

 recolor <- function(dataframe_name, input_column_name, new_column_name) {

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
	spotted  = c("dapple", "blue brindle", "blue merle", "blue tick", "brown brindle",
							 "brown merle", "liver tick", "red merle", "yellow brindle"),
	white    = c("white"),
	yellow   = c("apricot", "blonde", "gold", "yellow"),
	unknown  = c("unknown", "NA")
)

 	dataframe_name$new_column_name <- "other"

 	for (name in names(color_code)) {
 		match_rows <- dataframe_name$input_column_name %in% color_code[[category]]
 		dataframe_name$new_column_name[match_rows] <- category
 		}

 return(dataframe_name)
}


recolor(longbeach,primary_color,color)


#only including dogs and cats, datafile is very large
longbeach_cd <- longbeach
								<| filter(longbeach, animal_type == "dog" | animal_type == "cat")
								<| mutate(recolor(longbeach, primary_color, new_column_name))

#gtsummary table

tbl_summary(
	longbeach_cd,

	by = animal_type,

	include = c(outcome_is_dead, was_outcome_alive, primary_color)
)
