#https://www.offenedaten-koeln.de/dataset/geburten-und-sterbef%C3%A4lle

rm(list = ls());

library(ggplot2);
library(dplyr);
library(reshape2);
library(log4r);


# similar to cologne_names we process everything into a columnar structure
data_fp <- c(
  "data/2010_GeburtenSterbefaelle_Insgesamt.csv",
  "data/2011_GeburtenSterbefaelle_Insgesamt.csv",
  "data/2012_GeburtenSterbefaelle_Insgesamt.csv",
  "data/2013_Geburten_Sterbefaelle_Gesamt.csv",
  "data/2014_Geburten_Sterbefaelle_Gesamt.csv"
);

data_df <- NULL;

for (i in 1:length(data_fp)) {
  fp_i <- data_fp[i];
  df_i <- read.csv(file = data_fp[1], header = T, stringsAsFactors = F);
  names(df_i) <- c("Unit", "Birth", "BirthRate1000Citizen", "FertilityRate", 
                   "MotherAvgAgeFirstBirth", "Death", "DeathRate1000Citizen");
  
  if (is.null(data_df)) {
    data_df <- df_i;
  } else {
    data_df <- data_df %>% dplyr::bind_rows(df_i);
  }
}
