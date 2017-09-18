#' My Configuration
#'
# My various directories:
if(! 'homedir' %in% ls(.GlobalEnv)) 
  homedir <- '/Users/Alex/';

if(! 'desktop' %in% ls(.GlobalEnv)) 
  desktop <- '/Users/Alex/Desktop/';

if(! 'downloads' %in% ls(.GlobalEnv)) 
  downloads <- '/Users/Alex/Downloads/';

if(! 'docs' %in% ls(.GlobalEnv)) 
  docs <- '/Users/Alex/Documents/';

if(! 'temp' %in% ls(.GlobalEnv)) 
  temp <- '/tmp/';

if(! 'tsci5050' %in% ls(.GlobalEnv)) 
  tsci5050 <- '/Users/Alex/Documents/2017-fall-TSCI-5050/';

#' The data file for this project
classexample01 <- paste0(tsci5050,'exampledata.csv');
