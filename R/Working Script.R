install.packages("here")
install.packages("tidyverse")
install.packages("gtsummary", dependencies = TRUE)
library(here)
library(tidyverse)
library(gtsummary)
install.packages("broom")
library(broom)
install.packages("ggplot2")
library(ggplot2)
install.packages("readr")
library(readr)

# Load data, already cleaned, but going to update some categories of variables

longbeach <- read_csv(here::here("data", "raw", "longbeach.csv"))
#dataset read in & here usage 1


#want to recolor all the primary color variables to condense, going to create/use a function

 recolor <- function(dataframe_name, input_column_name, new_column_name) {

 	color_code <- list(
	black  = c("black", "black lynx point", "black smoke", "black tabby", "black tiger"),
	blue   = c("blue"),
	brown  = c("brown", "brown tabby", "brown  tabby",	"brown tiger", "brown  tiger", "ch lynx point", "chocolate",
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

 #creating another function to relabel because its easier than creating new system

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

#among cats processed at the longbeach animal shelter was color and intake condition associated with being dead at the outcome?
#only including cats, datafile is very large


longbeach_cats <- longbeach |>
									filter(animal_type == "cat") |>
									recolor("primary_color", "color") |>
									recode_intake("intake_condition", "intake") |>
									filter(!(intake == "other"))

#saving cleaned csv

write.csv(longbeach_cats, here("data", "clean", "longbeach_cats.csv"))

longbeach_cats <- read.csv(here::here("data", "clean", "longbeach_cats.csv"))

#labelling true/false

longbeach_cats$outcome_is_dead <- factor(longbeach_cats$outcome_is_dead,

	levels = c(FALSE, TRUE),
	labels = c("Alive", "Dead")
)

#gtsummary table

tbl_summary(
	longbeach_cats,

	by = outcome_is_dead,

	include = c(color,intake),
	label = list(
	color ~ "Color",
	intake ~ "Intake Condition"
)) |>
	add_overall(col_label = "**Total** N = {N}") |>
	bold_labels() |>
	modify_spanning_header(all_stat_cols() ~ "**Outcome**") |>
	modify_footnote(update = everything() ~ NA) |>
	modify_caption("**Table 1. Characteristics of Cats**")


#multivariate logistic regression
#setting categoricals as factors
longbeach_cats$color  <- factor(longbeach_cats$color)
longbeach_cats$intake <- factor(longbeach_cats$intake)

#reference levels
levels(longbeach_cats$color)
levels(longbeach_cats$intake)

longbeach_cats$color  <- relevel(longbeach_cats$color, ref = "unknown")
longbeach_cats$intake <- relevel(longbeach_cats$intake, ref = "normal")

# logistic model
logistic_model <- glm(outcome_is_dead ~ color + intake,
											data = longbeach_cats, family = binomial()
)

tbl_regression(
	logistic_model,
	exponentiate = TRUE,
	label = list(
		color ~ "Color",
		intake ~ "Intake Condition"
	)
) |>
	bold_labels() |>
	bold_p() |>
	modify_footnote(update = everything() ~ NA) |>
	modify_caption("**Table 2. Regression of Color and Intake Condition on Outcome**")


#make figure - forest plot, best choice for model

#tidy the model, and only include significant predictor variables
clean_model <- broom::tidy(logistic_model, exponentiate = TRUE, conf.int = TRUE)
clean_model <- clean_model |>
							 filter(term == "colorblack" | term == "colorbrown" | term == "colorgrey"
							 			 |term == "intakeferal_fractious" | term == "intakemild" |
							 			 	term == "intakemoderate" | term == "intakesevere")

#forest plot creation

ggplot(data = clean_model,
			 aes(x = estimate, y = term)) +
	geom_point(size = 3) +
	geom_errorbarh(aes(xmin = conf.low, xmax = conf.high), height = 0.2) +
	geom_vline(xintercept = 1, linetype = "dashed", color = "red") +
	labs(title = "Predictors of Death at Outcome among Shelter Cats",
			 x = "Odds Ratio (95% CI)",
			 y = "Characteristics") +
	theme_minimal() +
	theme(legend.position = "none")



