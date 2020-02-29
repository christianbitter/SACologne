rm(list = ls());

library(ggplot2);
library(dplyr);

data_fp <- c("data/Vornamen_Koeln_2010.csv",
             "data/Vornamen_Koeln_2011.csv",
             "data/Vornamen_Koeln_2012.csv",
             "data/Vornamen_Koeln_2013.csv",
             "data/Vornamensstatistik_2014_0.csv",
             "data/Vornamen_Koeln_2015.csv",
             "data/Vornamen_Koeln_2016.csv",
             "data/Vornamen_Koeln_2017.csv",
             "data/Vornamen_2018_KOeln.csv"
             );

years   <- 2010:2018;
seps    <- c(",", ",", ",", ",", ";", ";", ";", ";", ";")
data_df <- NULL;

for (i in 1:length(data_fp)) {
  fp_i <- data_fp[i];
  year_i <- years[i];
  sep_i  <- seps[i];
  
  cat("Processing:", fp_i, "\r\n");
  
  df_i      <- read.csv(fp_i, stringsAsFactors = F, sep = sep_i);
  df_i$year <- year_i;
  
  if (is.null(data_df)) { 
    data_df <- df_i;
  } else {
    data_df <- data_df %>% bind_cols(df_i);
  }
}

data_df <- 
  data_df %>% 
  select(firstname = vorname, 
         count = anzahl, 
         sex = geschlecht, 
         year) %>% 
  dplyr::mutate(year = as.factor(year),
                sex = as.factor(sex));

# for simplicity sake start to track 3 names across time
data_df %>%
  dplyr::filter(firstname %in% c("Sophie", "Anna", "Mia")) %>%
  dplyr::select(firstname, count, year) %>%
  dplyr::group_by(firstname) %>%
  summarize(mean_count = median(count)) %>% 
  dplyr::inner_join(data_df, by = "firstname") %>%
  ggplot(aes(x = year, y = count, group = firstname)) + 
  geom_bar(stat = "identity", fill = "gray") +
  geom_hline(aes(yintercept = mean_count), linetype = 4, alpha = .5, colour = "red") + 
  facet_wrap(firstname ~ .) + 
  theme_light() + 
  theme(axis.text.x = element_text(angle = 90));
