\name{sh_full}
\alias{sh_full}
\title{Seahorse Full function}
\usage{
sh_full(input, check.na = T, ocr = T)
}
\arguments{
  \item{input}{A .csv file containing all measurements for all wells of this group.}

  \item{check.na}{A logical value indicating whether columns containing NA values should be removed. Default TRUE}

  \item{ocr}{A logical value indicating if the function should use the ocr of ecar wells (1:3,7:9 or 1:6).}
}
\description{
Gives an overview of how often each well within each group of the dataset deviates from the mean +- sd of the measurement.
}
