[![DOI](https://zenodo.org/badge/239782432.svg)](https://zenodo.org/badge/latestdoi/239782432)

# SH package
This package contains the sh_full() function that helps you to assess the quality of the different wells and groups in your Seahorse run. 

To cite it, please use the DOI above. 

## How to use SH
Open up R and install devtools by typing
```
install.packages("devtools")
```
Then make sure to download SH from this repository
```
library(devtools)
install_github("nbruse/SH")
```
The SH package is now available in your R studio enviroment. You can attach it to your session with the command
```
library(SH)
```
The main function of this package is sh_full() that requires a .csv file containing the measurements for each well of the groups you want to test. 
Please make sure to export your data on the PC of the Seahorse analyzer to make sure it contains a "Rate (Columns)" tab. Here, you can just copy+paste
the OCR or ECAR groups (depending on your assay) into a new .csv file. An [example file](https://github.com/nbruse/SH/blob/master/Example.csv) is
supplied in the repository. The different groups should be divided by an empty column and the very first row should contain the group names, the second
row well names.

To run the function on your data it just requires the destination of the input file
```
sh_full("~/R/a_test_project/my_input.csv")
```
but we can also play around with some arguments, for example the assay argument defines the wells that are considered as __important__. 
The default is mitostress or 'ms' which takes well 1 until 3 and 7 to 9 into consideration. For glycolysis data please use assay = 'gs'. 
```
sh_full("~/R/a_test_project/my_input.csv", assay = 'gs')
```
If you want to define custom wells ignore the assay argument and use custom instead. E.g. if you'd want to prioritize the wells 1, 5, 6 and 7 
you could do that by changing the function to
```
sh_full("~/R/a_test_project/my_input.csv", custom = c(1,5:7))
```
The function checks your wells for negative values by default. Wells containing one in at least one are disabled and not considered for the 
calculations of mean and standard deviation. It will also warn you if there are not sufficient (<3) wells available to make the calculations.
In this case, you could consider disabling the negative value check, by changeing the check.min argument.
```
sh_full("~/R/a_test_project/my_input.csv", check.min = F)
```
Everytime you run the function, the output is directly printed to your command line. The well names correspond to the well names on your plate,
just like the group names. 
```
Group Name: RPMI donor 1 
Divergence from mean +- sd: 
 	 B02 B03 B04 B05 B06 
	 3 0 6 0 0
 ------------------------------------------------------------------- 
Group Name: RPMI ICI Donor 2 
!Excluded due to negative values in at least one measurement:  C04 
Divergence from mean +- sd: 
 	 C02 C03 C05 C06 
	 2 2 0 3
 ------------------------------------------------------------------- 
```
This output shows us that for the first group, well B04 and B02 show a high frequency of divergence (B03 even in six of six measurements)
and that in the second group C04 contains a negative value and is therefore excluded. The results change of course if the prioritized wells 
or the check.min argument are altered. 
If you would like to save the output, make sure to use the save.out argument. By switching it to TRUE, the date as well as the output of each run
are saved into your desired output while, the name of which you can define by using the save.name argument. Please note that this option **appends**
to the destination, which means that if you run sh_full multiple times without changing the output file, it will not be overwritten, but every run
will be added together with the date.
```
sh_full("~/R/a_test_project/my_input.csv", save.out = T, save.name = "my_output.txt")
```


If you encounter any bugs or problems, please don't hesitate to contact me via Niklas.Bruse@radboudumc.nl.
