\name{sh_full}
\alias{sh_full}
\title{Seahorse Full function}
\usage{
sh_full(input, check.min=T, assay="ms", save.out=F, custom=NULL, save.name="output.txt")
}
\arguments{
  \item{input}{A .csv file containing all measurements for all wells of the groups to analyze.}

  \item{check.min}{A logical value indicating whether columns containing NA values should be removed. Default TRUE}

  \item{assay}{Either 'ms' for mitrostress or 'gs' for glycolysis stress. Default 'ms'
  but is overwritten by 'custom' argument.}

  \item{save.out}{Saves the output of the analysis to a .txt document. New results will be appended to the file. Default FALSE}

  \item{custom}{Please use for custom well priority. Has to be a numeric vector (e.g. custom = c(1:2,5:8))}

  \item{save.name}{A string to a .txt file to which the output should be appended.
  The default saves the output in the project folder, this can however be changes by adding other destinations. Default "output.txt"}
}
\description{
Gives an overview of how often each well within each group of the dataset deviates from the mean +- sd of the measurement.
}
