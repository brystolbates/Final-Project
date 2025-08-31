install.packages("here")
install.packages("tidyverse")
install.packages("gtsummary", dependencies = TRUE)
library(here)
library(tidyverse)
library(gtsummary)


# Load data, already cleaned, but going to update some categories of variables

longbeach <- read_csv(here::here("data", "raw", "longbeach.csv"))
#dataset read in & here usage 1


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

 	dataframe_name[[new_column_name]] <- "other"

 	for (name in names(color_code)) {
 		match_rows <- dataframe_name[[input_column_name]] %in% color_code[[name]]
 		dataframe_name[[new_column_name]][match_rows] <- name
 		}

 return(dataframe_name)
}

 #creating another function to relabel becuase its easier than creating new system

 recode_intake <- function(dataframe_name, input_column_name, new_column_name) {

 	intake_code <- list(
 		normal  = c("normal"),
 		mild   = c("behavior mild", "ill mild", "injured mild" ),
 		moderate  = c("behavior moderate", "ill moderatete", "injured moderate"),
 		severe    = c("behavior severe", "ill severe", "injured severe"),
 		feral_fractious = c("feral", "fractious")
 	)

 	dataframe_name[[new_column_name]] <- "other"

 	for (name in names(intake_code)) {
 		match_rows <- dataframe_name[[input_column_name]] %in% intake_code[[name]]
 		dataframe_name[[new_column_name]][match_rows] <- name
 	}

 	return(dataframe_name)
 }

#among cats processed at the longbeach animal shelter was color and intake condition associated with being alive at the outcome?
#only including cats, datafile is very large
longbeach_cats <- longbeach |>
								 filter(animal_type == "cat") |>
								 recolor("primary_color", "color") |>
							 	 recode_intake("intake_condition", "intake") |>
								 filter(!(intake == "other"))

#saving cleaned csv

write.csv(longbeach_cats, here("data", "clean", "longbeach_cats.csv"))

#gtsummary table

tbl_summary(
	longbeach_cats,

	by = outcome_is_dead,

	include = c(color,intake),

label = list(
	color ~ "Color",
	intake ~ "Intake Condition"

))






|>
	add_p(test = list(
		all_continuous() ~ "t.test",
		all_categorical() ~ "chisq.test"
	)) |>
	add_overall()
