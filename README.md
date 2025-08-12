# 🎵 Spotify Data Analytics & Machine Learning in R

This project analyzes Spotify song data, visualizes trends, and applies basic machine learning techniques such as regression, decision trees, PCA, and recommendations.

---

## 📌 Features

1. **Data Loading & Cleaning** – Reads Excel data using `readxl`.
2. **Exploratory Data Analysis (EDA)** –

   * Top 10 artists by streams (bar chart)
   * Song release year distribution (pie chart)
   * Top 5 artists by number of songs (bar chart with Viridis colors)
3. **Interactive Visualizations** – Using **plotly** for:

   * Top 5 songs in Spotify playlists
   * Top 5 songs in Spotify charts
4. **Machine Learning Models** –

   * **Linear Regression** to predict streams based on `artist_count` & `bpm`
   * **Random Forest** to predict playlist appearances
   * **PCA** for dimensionality reduction and scree plot visualization
   * **Recommendation System** using `recommenderlab` & `recosystem`

---

## 📂 Requirements

Install the required R packages:

```r
install.packages(c(
  "readxl", "dplyr", "ggplot2", "viridis",
  "plotly", "randomForest", "recommenderlab", "recosystem"
))
```

---

## 🚀 How to Run

1. **Place your dataset** (Excel file) in your working directory, e.g. `ids_project.xlsx`.
2. Open the script in RStudio or your R environment.
3. Update the file path in:

   ```r
   spotify_data <- read_excel("ids_project.xlsx")
   ```
4. Run the script **section by section** to generate visualizations and models.

---

## 📊 Visualizations

### 1️⃣ Top 10 Artists by Streams

Generates a bar chart showing the top 10 artists.

```r
ggplot(top_10_artists, aes(x = reorder(artist, -Total_Streams), y = Total_Streams)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Top 10 Artists with the Most Streams",
       x = "Artist", y = "Total Streams") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

### 2️⃣ Songs Released by Year (2019–2023)

Creates a pie chart of song release distribution.

```r
ggplot(songs_by_year, aes(x = "", y = Percentage, fill = as.factor(ryear))) +
  geom_bar(stat = "identity", width = 1.5) +
  coord_polar("y") +
  labs(title = "Percentage of Songs Released (2019-2023)", fill = "Year") +
  theme_minimal()
```

### 3️⃣ Top 5 Artists by Song Count (Viridis Colors)

Shows top 5 most productive artists.

```r
ggplot(top5_artists, aes(x = reorder(artist, -Num_Songs), y = Num_Songs, fill = artist)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = viridis(5)) +
  labs(title = "Top 5 Artists with the Most Songs")
```

### 4️⃣ Interactive Plot – Top Songs in Playlists & Charts

Displays two interactive scatterplots side-by-side using Plotly.

```r
subplot(plot_playlists, plot_charts, nrows = 1)
```

---

## 🤖 Machine Learning Models

* **Linear Regression:** Predicts streams
* **Random Forest:** Predicts playlist appearances
* **PCA:** Visualizes variance explained
* **Recommendation System:** Suggests similar tracks

---

## 📌 Notes

* Ensure your Excel dataset contains **columns**: `artist`, `streams`, `ryear`, `rmonth`, `artist_count`, `bpm`, `key`, `mode`, `in_spotify_playlists`, `in_spotify_charts`, `track_name`.
* For best experience, run in **RStudio** so plots and interactive graphs are shown properly.
