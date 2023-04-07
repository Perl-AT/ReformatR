# [ReformatR 1.2](https://github.com/Perl-AT/ReformatR)

This [shiny](https://www.rdocumentation.org/packages/shiny/versions/1.7.4) app takes, as input, .csv reports from Med Associates [Video Freeze](https://med-associates.com/product/videofreeze-video-fear-conditioning-software/) software and makes, as output, new .csv files containing only key data from the input file, reformatted so as to be readily handleable in R and SPSS. 

## Getting Started

To open the GUI, one might 
* follow [this link](https://perl-at.shinyapps.io/reformatr/) to open the web app version of ReformatR hosted at [shinyapps.io](https://www.shinyapps.io) in one's default web browser, 
* run `shiny::runApp("~/Desktop/ReformatR.R")` in R, or `/usr/local/bin/R --vanilla --no-echo -e 'library(methods); shiny::runApp("~/Desktop/ReformatR.R", launch.browser = TRUE)'` in the terminal on Mac, or some such command to deploy the ReformatR.R script file from one's desktop or other preferred location, 
* or simply copy and paste the ReformatR.R code into R or RStudio and run it. 

Before running the ReformatR.R script on a new device, ensure that timely versions of [R](https://www.r-project.org) and the shiny package are installed on your computer. If the shiny package has not been installed, run `install.packages("shiny")` in R. This is not an issue if using the web app. 

More information on how to operate ReformatR is contained within the GUI itself in a separate "Usage" tab. 

## Getting Help and Contributing

Reach out to the maintainer for help or to make suggestions, or submit issues or pull requests on [GitHub](https://github.com/Perl-AT/ReformatR). 
Accommodation for new experiment types can be added into the existing framework *ad libitum*. 

## Dependency Management and Related Information

A goal for ReformatR has been to minimize dependencies. shiny is the only package which must be installed on a new device prior to the GUI's use. 

Regarding its development, **ReformatR** *v1.2* has been constructed and tested for reformatting reports from **Video Freeze** *v2.7.3.0* using **R** (for Mac) *v4.2.1* in **RStudio** (for Mac) *v2022.07.0+548*, using **shiny** package *v1.7.2*. It is recommended that users double-check the integrity of ReformatR's output when first running it under alternative versions of R, RStudio and shiny. 

## Changelog

#### Version 1.2 | 03.07.2023 (Andrew Perl)
* Unusable 'Launcher' and 'Install_shiny' apps have been deleted. 
* Reformatting of all experiment types now yields both percent freezing and average motion data for each component. No changes have been made to how or what values are reported with respect to previous versions since v0.2, but new data are now reported by the output which earlier versions did not provide. Experiment and Trial columns are also now reported. 
* Footers are more informative. 
* Input .csv files can be faithfully reformatted regardless of whether their empty rows are ignored by R or not, an added degree of flexibility necessary to combat the so-far unpredictable and contradictory two ways by which R has been seen to handle input files. 

#### Version 1.1 | 01.31.2023 (Andrew Perl)
* Updated 10 min Pre-Exposure and Immediate Shock experiments to report 'Avg Motion Index' data.
* The Acquisition/Tone Test now reports 'tone,' 'shock' and 'trace' component averages.
* Added 'Launcher' and 'Install_shiny' apps for ease of use in macOS.

#### Version 1.0 | 01.25.2023 (Andrew Perl)
* Updated to reformat additional experiment types.
* Output files now contain informative footers.
* Fixed the `actionButton` (🙌) and other minor quirks.

#### Version 0.2 | 10.20.2022 (Andrew Perl)
* Updated to accommodate corrected .cmp component file for 5 min/30 sec Context Test reports.
* Addition of an 'average' column to 5 min/30 sec Context Test output tables.

#### Version 0.1 | 09.23.2022 (Andrew Perl)
* Reformating for Acquisition/Tone and 5 min/30 sec Context Tests facilitated.

---

###### Author/Maintainer: Andrew Perl (perlat@nih.gov | atperl123@gmail.com | [Perl-AT](https://github.com/Perl-AT))
