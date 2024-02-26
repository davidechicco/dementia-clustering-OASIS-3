setwd(".")
options(stringsAsFactors = FALSE)
cat("\014")
set.seed(11)

list.of.packages <- c("pacman")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos='http://cran.us.r-project.org')

library("pacman")
p_load("stringr","kml3d", "dplyr")
SAVE_CLUSTERING_PLOT_TO_FILE <- FALSE

source("./utils.r")

num_to_return <- 1
upper_num_limit <- 100000
exe_num <- sample(1:upper_num_limit, num_to_return)

thisK <- 4
cat("number of clusters = ", thisK, "\n", sep="")
thisRedrawingNumber <- 1

# theseDataFilRdsFiles <- c("../data/OASIS-3_processed_Luca_e_Claudia_2024-02-14/V2_visits3years.rds",
#                          "../data/OASIS-3_processed_Luca_e_Claudia_2024-02-14/V2_visits4years.rds",
#                          "../data/OASIS-3_processed_Luca_e_Claudia_2024-02-14/V2_visits5years.rds")

theseDataFilRdsFiles <- c("../data/OASIS-3_processed_Luca_e_Claudia_2024-02-14/V2_visits3years.rds")

# theseDataFiles <- c("../data/OASIS-3_processed_Giovanni_2024-02-14/visits3years.rds", "../data/OASIS-3_processed_Giovanni_2024-02-14/visits4years.rds", "../data/OASIS-3_processed_Giovanni_2024-02-14/visits5years.rds")

# theseDataFiles <- c("../data/OASIS-3_processed_Giovanni_2024-02-14/visits3years.rds")

# theseDataFilRdataFiles <- c("../data/OASIS-3_processed_Luca_e_Claudia_2024-02-14/V2_visits3years.RData",
#                            "../data/OASIS-3_processed_Luca_e_Claudia_2024-02-14/V2_visits4years.RData",
#                            "../data/OASIS-3_processed_Luca_e_Claudia_2024-02-14/V2_visits5years.RData")

theseDataFilRdataFiles <- c("../data/OASIS-3_processed_Luca_e_Claudia_2024-02-14/V2_visits3years.RData")

data_years <- NULL

for(thisDataFile in theseDataFilRdataFiles) {

    # thisDataFile <- "../data/OASIS-3_processed_Luca_e_Claudia_2024-02-14/V2_visits4years.rds"
    # data_years <- readRDS(file = thisDataFile)
    load(thisDataFile)
    cat("The script just read the ", thisDataFile, " file\n", sep="")
    kml3d(data_years, nbClusters=thisK, nbRedrawing=thisRedrawingNumber, toPlot="none")

    datasetName <- str_split(str_split(thisDataFile, "/")[[1]][4], ".RData")[[1]][1]


    command <- "rm ./*.Rdata"
    system(command)
    cat("Executed: ", command, "\n")

    if(thisK == 2) { data_years@"c2" %>% print() }
    else if(thisK == 3) { data_years@"c3" %>% print() }
    else if(thisK == 4) { data_years@"c4" %>% print() }
    else if(thisK == 5) { data_years@"c5" %>% print() }



    #plot(data_years,3,parTraj=parTRAJ(col="clusters"))

    if(SAVE_CLUSTERING_PLOT_TO_FILE) {

        outputResultsFileName <- paste0("../results/kml3d/", datasetName, "_", thisK, "clusters_time", this_moment_formatted(),".pdf")
        pdf(outputResultsFileName,         # File name
            width = 0, height = 10, # Width and height in inches
            bg = "white",          # Background color
            colormodel = "cmyk",    # Color model (cmyk is required for most publications)
            paper = "A4")          # Paper si

        # png(outputResultsFileName)
        # jpeg("my_plot.jpeg", quality = 75)


        plot(data_years, thisK, parTraj=parTRAJ(col="clusters"), toPlot="traj")

        dev.off()
        cat("saved file ", outputResultsFileName, "\n", sep="")
    }

}

# dev.copy2pdf()
