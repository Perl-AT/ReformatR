# [ReformatR 1.1](https://github.com/Perl-AT/ReformatR)

This "shiny" app takes, as input, .csv reports from Med Associates Video Freeze and makes, as output, new .csv files containing only key data from the input file, reformatted so as to be readily handleable in R and SPSS. 

## Getting Started

Download one of the compressed files listed as assets under the latest release of ReformatR, and decompress the file. 
The resulting "ReformatR-1.1" folder should contain: 
* a copy of this README document, 
* the ReformatR script itself in a .R file, 
* a "Launcher" app, and 
* an "Install_shiny" app. 

Before running the GUI on a new device, ensure that recent versions of R and the [shiny](https://www.rdocumentation.org/packages/shiny) package are installed on your computer. 
If the shiny package has not been installed, 
* run `install.packages("shiny")` in R, 
* or, if using a Mac, double-click the Install_shiny app to install the package through [CRAN](https://CRAN.R-project.org/package=shiny). For the Install_shiny app to run, it must be located in the ReformatR-1.1 folder, and this folder must be located on the user's desktop. 

## Usage

To open the GUI, either 
* open the ReformatR.R file in R or RStudio and run the script -- a new window ought to appear -- 
* or, if using a Mac, double-click the Launcher app to start a ten-minute session in your default browser. The session will run for the full ten minutes unless manually cancelled, even if the GUI's tab is closed. For the Launcher app to run, it must be located in the ReformatR-1.1 folder, and this folder must be located on the user's desktop. 

More information on how to operate ReformatR is contained within the GUI itself in a separate "Usage" tab. 

## Getting Help and Contributing

Reach out to the maintainer for help or to make suggestions, or submit issues or pull requests on [GitHub](https://github.com/Perl-AT/ReformatR). 
Accommodation for new experiment types can be added into the existing framework *ad libitum*. 

## Dependency Management and Related Concerns

**ReformatR 1.1** has been constructed and tested for reformatting reports from **Video Freeze** *v2.7.3.0* using **R** (for Mac) *v4.2.1* in **RStudio** (for Mac) *v2022.07.0+548*, and using the **shiny** package *v1.7.2*. It is recommended that users double-check the integrity of ReformatR's output when first running it under alternative versions of R, RStudio and shiny. 

## Changelog

#### Version 1.1 | 01.31.2023 (Andrew Perl)
* Updated 10 min Pre-Exposure and Immediate Shock experiments to report Avg Motion Index.
* The Acquisition/Tone Test now reports tone, shock and trace component averages.
* Added Launcher and Install_shiny apps for ease of use in macOS.

#### Version 1.0 | 01.25.2023 (Andrew Perl)
* Updated to handle reformatting for three additional experiment types.
* Output files now contain informative footers.
* Fixed the `actionButton` (🙌) and other minor quirks.

#### Version 0.2 | 10.20.2022 (Andrew Perl)
* Updated to accommodate corrected .cmp component file for 5 min/30 sec Context Test reports.
* Addition of 'average' column to 5 min/30 sec Context Test output tables.

#### Version 0.1 | 09.23.2022 (Andrew Perl)
* Reformating for Acquisition/Tone and 5 min/30 sec Context Tests facilitated.

---

###### Author/Maintainer: Andrew Perl (perlat@nih.gov | atperl123@gmail.com | [Perl-AT](https://github.com/Perl-AT))
