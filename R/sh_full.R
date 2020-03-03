# Script SH_full
# Niklas Bruse
# 03-03-2020

sh_full <- function(input,
                    check.min = T,
                    assay = "ms",
                    save.out = F,
                    custom,
                    save.name = "output.txt"){

  df_input<-read.csv2(input, header = F, row.names = 1, stringsAsFactors = F)

  # Add NA column to the end of dataframe
  empty <- NA
  df_input <- cbind(df_input,empty)

  # Define start position for each dataframe divided by NAs
  lastPos = 1

  # Iterate through all dfs divided by NA columns
  for(i in colnames(df_input)[colSums(is.na(df_input)) > 0]){

    # Get index of NA column
    posNA<-grep(paste0("^",i,"$"), colnames(df_input))
    dfclean <- df_input[,lastPos:posNA-1]
    name_df <- as.character(dfclean[1,1])
    df3 <- dfclean[2:nrow(dfclean),]
    colnames(df3) <- as.character(unlist(df3[1,]))

    # This is the final dataframe
    # Check whether the whole df is numeric, if not make it numeric
    df <- df3[-1, ]
    if(!isTRUE(sapply(df, is.numeric))){
      df[]<- sapply(df[],function(x) as.numeric(gsub(",",".",x)))
    }

    ### This is where the magic starts (old sh_lite fuction) ####
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

    # Define df2 ####
    if(assay == "ms"){
      df2 <- df[c(1:3,7:9),]
    }else if(assay == "gs"){
      df2 <- df[c(4:9),]
    }else if(assay == "custom"){
      if(is.numeric(custom) == T){
        df2 <- df[custom,]
      }else{
        stop("Please make sure to supply a numeric vector for the custom variable.")
      }
    }else{
      stop("Please make sure to choose either 'ms', 'gs' or 'custom'.")
    }

    # Check for NAs ####
    if(check.min == T){
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
      df2[,unique(col_na)] <- NA
      if(sum(!is.na(df2[1,])) < 3){
        stop("After removing all negative values, there were less than three viable wells available for all measurements.
           Maybe the assay went wrong for this group? Please consider rerunning the analysis with check.min = F")
      }
    }

    # Log transform df2
    if(check.min == T){
      df2[, !colSums(is.na(df2))]<-log2(df2[, !colSums(is.na(df2))])
    } else if(check.min == F){
      df2 <- df2 + abs(min(df2)) + 1
      df2 <- log2(df2)
    } else {
      stop("Something went wrong.")
    }

    # Calculate mean and standard error ####
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

    # Print out negative values that were excluded ####
    cat(name_df,"\n")
    if(check.min == T){
      if(length(excl) > 0){
        cat("!Excluded due to negative values in at least one measurement: ", unique(excl), "\n")
      }
    }

    # Print out excluded wells due to high/low divergence
    cat("Divergence from mean +- sd:","\n","\t", colnames(df2)[colSums(is.na(df2)) == 0], "\n")

    # Only use the wells that are not NA
    excl_wells <- excl_wells[colSums(is.na(df2)) == 0]

    # Print overview of wells not containing NA and their quality
    do.call(cat, c("\t", excl_wells))
    cat("\n","-------------------------------------------------------------------","\n")

    # Save output to text file
    if(save.out == T){
      # Attach names to excl_wells for printout
      names(excl_wells)<-colnames(df2)[colSums(is.na(df2)) == 0]
      save.list <- list("Groupname"=name_df, "Excl.min"=unique(excl), "Wells"=excl_wells)
      capture.output(str(save.list), file = save.name, append = T)
    }

    # Jump to the next df surrounded by NAs
    lastPos = posNA+2
  }
}
