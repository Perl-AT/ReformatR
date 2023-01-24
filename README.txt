ReformatR 0.2

################

This Shiny app takes, as input, the .csv reports from Video Freeze, 
and makes, as output, new .csv files with only key data from the input file, reformatted. 

For Acquisition/Tone Test reformatting 
("3 Tone Acquisition 75 Sheryl protocol" with "3 TS DelayToneAquandTest Sheryl" component file), 
* output values for all 3 shocks are "Avg Motion Index", and 
* output values for all other components are "Pct Component Time Freezing". 

For Context Test reformatting 
("Context Test 5 min" protocol with "5minContext30secbinsFIXED" component file), 
* output values for all components are "Pct Component Time Freezing". 

################

Before use: 
* Ensure R and the "shiny" package are installed on your computer. 
* If "shiny" package has not been installed, run 
  > install.packages("shiny")
  in R. 

To use: 
* open the ReformatR.R app in R or RStudio and run the code, 
* upload intended input file, 
* select nature of the experiment, "Acquisition/Tone Test" or "Context Test". 
* type the number of animals used in the selected experiment's file, 
* hit the "Generate reformatted table" button, 
* double check the table displayed in the main panel for obvious errors, 
* type the intended name for the output file, and 
* hit the "Save reformatted file" button, and select a destination for the file. 

-- Andrew Perl (perlat@nih.gov)

################

Updates: 

0.1 -- 09.23.2022 (Andrew Perl)
* First usable version

0.2 -- 10.20.2022 (Andrew Perl)
* Updated to accommodate use of corrected .cmp component file for context test reports
* Addition of column for averages of each animal's Pct freezing values across all 30s bins in context test reports
* Minor label changes