# https://www.offenedaten-koeln.de/dataset/vornamen
# https://www.offenedaten-koeln.de/dataset/geburten-und-sterbef%C3%A4lle
# https://opendata.stackexchange.com/questions/46/multinational-list-of-popular-first-names-and-surnames

rm(list = ls());

library(ggplot2);
library(dplyr);
library(reshape2);
library(log4r);

# similar to cologne_names we process everything into a columnar structure
data_out_fp <- "data/firstnames_cologne_2010_to_2018.csv";

if (!file.exists(data_out_fp)) {
  # log4r::debug()
  
  cat("Creating Output file\r\n");
  
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
  
  years   <- c(2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018);
  seps    <- c(",", ",", ",", ",", ";", ";", ";", ";", ";")
  data_df <- NULL;
  
  # we are only going to focus on firstnames in their first position
  # i.e. sophia occurs in position 1, 2 or 3 like sophia, maria sophia, and maria-anna sophia
  # consequently, we are going to care only about the first case
  
  for (i in 1:length(data_fp)) {
    fp_i <- data_fp[i];
    year_i <- years[i];
    sep_i  <- seps[i];
    v_i    <- sprintf("Y%s", year_i);
  
    cat("Processing:", fp_i, "\r\n");
    
    df_i <- read.csv(fp_i, stringsAsFactors = F, sep = sep_i);
    
    if (!("position" %in% names(df_i))) {
      df_i <- 
        df_i %>%
        dplyr::mutate(position = 1);
    }
    
    df_i <- 
      df_i %>%
      dplyr::select(firstname = vorname, count = anzahl, sex = geschlecht, position) %>%
      dplyr::mutate(year = year_i) %>%
      dplyr::filter(firstname != "", position == 1);
    
    if (is.null(data_df)) {
      data_df <- df_i;
    } else {
      data_df <-
        data_df %>%
        dplyr::bind_rows(df_i);
    }
  }
  
  # filter empty names
  data_df <- 
    data_df %>% 
    dplyr::group_by(firstname, sex) %>%
    dplyr::summarise(med = median(count)) %>%
    dplyr::inner_join(data_df, by = c("firstname", "sex"));
  
  data_df <- 
    data_df %>%
    dplyr::group_by(firstname, sex) %>%
    dplyr::summarise(spread = IQR(count)) %>%
    dplyr::inner_join(data_df, by = c("firstname", "sex"));
  
  write.table(x = data_df, file = data_out_fp, sep = ";", 
              append = F, row.names = F, col.names = T);
}

# median absolute difference
data_df <- read.csv(file = data_out_fp, sep = ";", header = T, stringsAsFactors = F);



plot_title <- "Cologne First Names";
plot_caption <- "(c) Christian Bitter 2020";

unique_names <- unique(data_df$firstname);
unique_sex   <- unique(data_df$sex);
unique_year  <- unique(data_df$year); 

data_df %>%
  dplyr::filter(firstname == "Sophia") %>%
  ggplot(aes(x = year, y = count)) + 
  geom_point() + 
  geom_hline(aes(yintercept = med)) +
  geom_ribbon(aes(ymin = count - spread, ymax = count + spread), 
              alpha = .5, fill = "lightblue") + 
  stat_smooth(se = F) + 
  labs(x = "Year", y = "Count",
       title = plot_title, caption = plot_caption,
       subtitle = paste("Yearly, median (gray) and IQR (shaded region) occurrence of first name Sophia in Cologne.", "Loess trend line is shown in blue.", 
                        sep = "\n")) +
  theme_light();
