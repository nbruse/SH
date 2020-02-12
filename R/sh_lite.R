# Script SH_lite
# Niklas Bruse
# 11-2-2020

sh_lite <- function(input, check.na = T, ocr = T){

  # Read input
  df <- read.csv2(input, row.names=1)

  # Define variables
  wells <- length(df)
  names_df <- names(df)
  excl <- c()
  col_na <- c()
  excl_wells <- vector("list", wells)

  # Fill list ####
  for(i in 1:wells){
    excl_wells[[i]]<-0
  }

  # Define df2 ----
  if(ocr == T){
    df2 <- df[c(1:3,7:9),]
    }else if(ocr == F){
      df2 <- df[c(1:6),]
      }else{
        stop("The ocr argument has to be either T or F (for ECAR).")
        }

  # Check for NAs ----
  if(check.na == T){
    for(j in 1:nrow(df2)){
      for(k in 1:ncol(df2)){
        if(df2[j,k] < 0){
          excl <- c(excl,names_df[k])
          col_na <- c(col_na, k)
        }
      }
    }

    # Turn all columns with a negative value to NA and check if there are
    # still sufficient colums (3) present
    df2[,col_na] <- NA
    if(sum(!is.na(df2[1,])) < 3){
      stop("After removing all negative values, there were less than three viable wells available for all measurements.
           Maybe the assay went wrong for this group? Please consider rerunning the analysis with check.na = F")
    }
  }

  # Log transform df2 --- DAS FUNKTIONIERT NOCH NET 1000 is zu hoch und ver
  if(check.na == T){
    df2[, !colSums(is.na(df2))]<-log2(df2[, !colSums(is.na(df2))])
  } else if(check.na == F){
    df2 <- df2 + abs(min(df2)) + 1
    df2 <- log2(df2)
  } else {
    stop("Something went wrong.")
  }

  # Calculate mean and standard error ----
  for(measurement in 1:nrow(df2)){

    # Reset values
    err_up <- NULL
    err_down <- NULL

    # Calculate mean and sd
    means <- (mean(as.numeric(df2[measurement,]), na.rm = T))
    sd <- (sd(as.numeric(df2[measurement,]), na.rm = T))

    # Calculate range
    err_up <- means + sd
    err_down <- means - sd

    # Iterate over all values to see if they fit
    for(value in df2[measurement,]){
      if(!is.na(value)){
        if(value > err_up){
          well_nr <- match(value, df2[measurement,])
          excl_wells[[well_nr]]<- excl_wells[[well_nr]] + 1
        }else if(value < err_down){
          well_nr <- match(value, df2[measurement,])
          excl_wells[[well_nr]]<- excl_wells[[well_nr]] + 1
        }
      }
    }
  }

  # Print out negative values that were excluded ----
  if(check.na == T){
    if(length(excl) > 0){
      cat("These wells should be excluded in Wave and from your
          analysis due to negative values: ", excl, "\n\n")
    }
  }

  # Print out excluded wells due to high/low divergence
  #excl_wells<-excl_wells[excl_wells >= treshhold] WORK IN PROGRESS
  cat("Here is an overview for all wells and how often they
    display some sort of divergence from the mean +- sd: \n\n")
  cat("\t", colnames(df2)[colSums(is.na(df2)) == 0], "\n")

  # Only use the wells that are not NA
  excl_wells <- excl_wells[colSums(is.na(df2)) == 0]

  # Print overview of wells not containing NA and their quality
  do.call(cat, c("\t", excl_wells))
}
