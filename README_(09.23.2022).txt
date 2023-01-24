This Shiny app takes, as input, the .csv reports from Video Freeze, 
and makes, as output, a new .csv file with key data from the input file, reformatted. 

For Acquisition/Tone Test reformatting 
("3 Tone Acquisition 75 Sheryl protocol" with "3 TS DelayToneAquandTest Sheryl" component file), 
* output values for all 3 shocks are "Avg Motion Index", and 
* output values for all other components are "Pct Component Time Freezing". 

For Context Test reformatting 
("Context Test 5 min" protocol with "5minContext30secbins component file), 
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
* hit the "Save reformatted file" button, and select a destination fo the file. 

-- Andrew Perl (perlat@nih.gov)

Updated 09.23.2022