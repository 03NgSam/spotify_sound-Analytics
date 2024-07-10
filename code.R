 library(readxl)
 ids_project <- read_excel("ids_project.xlsx")
 View(ids_project) 
 library(readxl)
 library(dplyr)
 library(ggplot2)
 
 spotify_data <- read_excel("/cloud/project/ids_project.xlsx")
 artist_streams <- spotify_data %>%
   group_by(`artist`) %>%     
   summarise(Total_Streams = sum(streams, na.rm = TRUE)) %>%     
   arrange(desc(Total_Streams))
 top_10_artists <- head(artist_streams, 10)
 ggplot(top_10_artists, aes(x = reorder(artist, -Total_Streams), y = Total_Streams)) +
   geom_bar(stat = "identity", fill = "skyblue") +
   labs(title = "Top 10 Artists with the Most Streams",
        x = "artist",
        y = "Total_Streams") +
   theme(axis.text.x = element_text(angle = 45, hjust = 1))
 
 songs_by_year <- spotify_data %>%
   group_by(ryear) %>%
   summarise(Total_Songs = n())
 songs_by_year <- mutate(songs_by_year, Percentage = (Total_Songs / sum(Total_Songs)) * 100)
 ggplot(songs_by_year, aes(x = "", y = Percentage, fill = as.factor(ryear))) +
   geom_bar(stat = "identity", width = 1.5) +
   geom_text(aes(label = paste0(round(Percentage), "%")), position = position_stack(vjust = 0.5)) +
   
   coord_polar("y") +
   labs(title = "Percentage of Songs Released (2019-2023)",
        fill = "Year",
        x = NULL,
        y = NULL) +
   theme_minimal() +
   theme(axis.text = element_blank(),
         axis.title = element_blank(),
         panel.grid = element_blank())
 
 songs_by_artist <- spotify_data %>%
   group_by(artist) %>%
   summarise(Num_Songs = n())
 top_artist <- songs_by_artist %>%
   top_n(1, wt = Num_Songs)
 top5_artists <- songs_by_artist %>%
   top_n(5, wt = Num_Songs)
 install.packages("viridis")
  library(viridis)
 color_palette <- viridis(5)
 
 ggplot(top5_artists, aes(x = reorder(artist, -Num_Songs), y = Num_Songs, fill = artist)) +
   geom_bar(stat = "identity") +
   geom_text(aes(label = Num_Songs), vjust = -0.5, size = 3) +
   scale_fill_manual(values = color_palette) +  
   labs(title = "Top 5 Artists with the Most Songs",
        x = "Artist",
        y = "Number of Songs") +
   theme(axis.text.x = element_text(angle = 45, hjust = 1))
 
 top5_playlists <- spotify_data %>%
   arrange(desc(in_spotify_playlists)) %>%
   head(5)
 
 top5_charts <- spotify_data %>%
   arrange(desc(in_spotify_charts)) %>%
   head(5)
 
 install.packages("plotly")
 library(plotly)
 
 
 plot_playlists <- plot_ly(data = top5_playlists, x = ~in_spotify_playlists, y = ~in_spotify_charts, 
                           text = ~paste("Name: ", track_name, 
                                         "<br>Artist: ", artist, 
                                         "<br>Artist Count: ", artist_count,
                                         "<br>Released Year: ", ryear,
                                         "<br>Released Month: ", rmonth,
                                         "<br>Streams: ", streams,
                                         "<br>BPM: ", bpm,
                                         "<br>Key: ", key,
                                         "<br>Mode: ", mode),
                           hoverinfo = "text", mode = "markers") %>%
   add_markers(size = 10, color = ~track_name) %>%
   layout(title = "Top 5 Songs in Spotify Playlists",
          xaxis = list(title = "Number of Playlists"),
          yaxis = list(title = "Number of Charts"),
          showlegend = FALSE)
 
 plot_charts <- plot_ly(data = top5_charts, x = ~in_spotify_playlists, y = ~in_spotify_charts, 
                        text = ~paste("Name: ", track_name,                       "<br>Artist: ", artist, 
                                      "<br>Artist Count: ", artist_count,
                                      "<br>Released Year: ", ryear,
                                      "<br>Released Month: ", rmonth,
                                      "<br>Streams: ", streams,
                                      "<br>BPM: ", bpm,
                                      "<br>Key: ", key,
                                      "<br>Mode: ", mode),
                        hoverinfo = "text", mode = "markers") %>%
   add_markers(size = 10, color = ~track_name) %>%
   layout(title = "Top 5 Songs in Spotify Charts",
          xaxis = list(title = "Number of Playlists"),
          yaxis = list(title = "Number of Charts"),
          showlegend = FALSE)
 
 subplot(plot_playlists, plot_charts, nrows = 1)
 
 #1.regression 
 linear_model <- lm(
   streams ~  artist_count + bpm,
   data = spotify_data
 )
 summary(linear_model)
 
 #2 decison tree
 install.packages("randomForest")
 library(randomForest)
 
 rf_model <- randomForest(in_spotify_playlists ~ artist_count + ryear + rmonth + key + bpm, data = spotify_data)
 print(rf_model)
 
 #3.demionality reduction
 
 pca_model <- prcomp(spotify_data[, c("artist_count", "ryear", "rmonth", "bpm")], scale. = TRUE)
 
 # Print the summary of the PCA model
 print(summary(pca_model))
 
 plot(pca_model)
 
 # Add labels and title
 title("Scree Plot for PCA", side = 3, line = 3)
 mtext("Principal Component", side = 1, line = 3)
 mtext("Proportion of Variance Explained", side = 2, line = 4)
 
#4. recommendation 
 install.packages("recommenderlab")
 install.packages("recosystem")
 
 library(recommenderlab)
 library(recosystem)
 
 spotify_matrix <- as(spotify_data[, c("artist", "ryear", "bpm", "key")], "realRatingMatrix")
 
 # Create a recommendation system
 rec_system <- Recommender(spotify_matrix, method = "UCBF")
 
 # Get recommendations for each track
 recommendations_list <- predict(rec_system, newdata = spotify_matrix, n = 5)
 
 # Print the recommendations
 print(recommendations_list)
 
 
