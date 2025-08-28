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

recolor_animals <- function(dataframe_name, input_column_name, new_column_name) {}



color_code <- c(
	"black"              = "black",
	"black lynx point"   = "black",
	"black smoke"        = "black",
	"black tabby"        = "black",
	"black tiger"        = "black",

	"blue"               = "blue",

	"brown"              = "brown",
	"brown tabby"        = "brown",
	"brown tiger"        = "brown",
	"ch lynx point"      = "brown",
	"chocolate"          = "brown",
	"chocolate point"    = "brown",
	"liver"              = "brown",
	"red"                = "brown",
	"red point"          = "brown",
	"ruddy"              = "brown",
	"sable"              = "brown",

	"buff"               = "tan",
	"cream"              = "tan",
	"cream point"        = "tan",
	"cream tabby"        = "tan",
	"cream tiger"        = "tan",
	"ct lynx point"      = "tan",
	"fawn"               = "tan",
	"flame point"        = "tan",
	"tan"                = "tan",
	"wheat"              = "tan",

	"green"              = "green",

	"blue cream"         = "grey",
	"blue lynx point"    = "grey",
	"blue point"         = "grey",
	"blue tabby"         = "grey",
	"gray"               = "grey",
	"gray tabby"         = "grey",
	"gray tiger"         = "grey",
	"lilac lynx point"   = "grey",
	"lilac point"        = "grey",
	"lilac_cream point"  = "grey",
	"lynx point"         = "grey",
	"point"              = "grey",
	"seal"               = "grey",
	"seal point"         = "grey",
	"silver"             = "grey",
	"silver lynx point"  = "grey",
	"silver tabby"       = "grey",
	"st lynx point"      = "grey",

	"calico"             = "multi",
	"calico dilute"      = "multi",
	"calico point"       = "multi",
	"calico tabby"       = "multi",
	"snowshoe"           = "multi",
	"torbi"              = "multi",
	"tortie"             = "multi",
	"tortie dilute"      = "multi",
	"tortie point"       = "multi",
	"tricolor"           = "multi",

	"orange"             = "orange",
	"orange tabby"       = "orange",
	"orange tiger"       = "orange",
	"peach"              = "orange",


	"pink"               = "pink",

	"blue brindle"       = "spotted",
	"blue merle"         = "spotted",
	"blue tick"          = "spotted",
	"brown brindle"      = "spotted",
	"brown merle"        = "spotted",
	"dapple"             = "spotted",
	"liver tick"         = "spotted",
	"red merle"          = "spotted",
	"yellow brindle"     = "spotted",

	"white"              = "white",

	"apricot"            = "yellow",
	"blonde"             = "yellow",
	"gold"               = "yellow",
	"yellow"             = "yellow",

	"unknown"            = "unknown",
	"NA"                 = "unknown"
)

longbeach_test <- longbeach
			|> mutate(

		region_cat = factor(region, labels = c("Northeast", "North Central", "South", "West")),
		sex_cat = factor(sex, labels = c("Male", "Female")),
		race_eth_cat = factor(race_eth, labels = c("Hispanic", "Black", "Non-Black, Non-Hispanic")),
		eyesight_cat = factor(eyesight, labels = c("Excellent", "Very good", "Good", "Fair", "Poor")),
		glasses_cat = factor(glasses, labels = c("No", "Yes"))
	)


}
