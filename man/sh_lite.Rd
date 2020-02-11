\name{sh_lite}
\alias{sh_lite}
\title{Seahorse Lite function}
\usage{
sh_lite(input, check.na = T, ocr = T)
}
\arguments{
  \item{input}{A .csv file containing all measurements for all wells of this group.}

  \item{check.na}{A logical value indicating whether columns containing NA values should be removed. Default TRUE}

  \item{ocr}{A logical value indicating if the function should use the ocr of ecar wells (1:3,7:9 or 1:6).}
}
\description{
The main function sh_lite() gives an overview of how often each well within the dataset deviates from the mean +- sd of the measurement.
}
