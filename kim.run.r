#' ---
#' title: "TSCI 5050: Introduction to Data Science"
#' author: "Alex F. Bokov"
#' date: "09/02/2017"
#' ---
#' ## Load libraries
#+ warning=FALSE, message=FALSE
message('Starting in directory ',getwd());
rq_libs <- c(
  'compiler'                              # just-in-time compilation
  ,'survival','MASS','Hmisc','zoo','coin' # various analysis methods
  ,'readr','dplyr','stringr','magrittr'   # data manipulation & piping
  ,'ggplot2','ggfortify','grid','GGally'  # plotting
  ,'stargazer','broom','janitor','tableone');                  # table formatting
rq_installed <- sapply(rq_libs,require,character.only=T);
rq_need <- names(rq_installed[!rq_installed]);
if(length(rq_need)>0) install.packages(rq_need,repos='https://cran.rstudio.com/',dependencies = T);
sapply(rq_need,require,character.only=T);
#' Turn JIT to max: pre-compile all closures, `for`, `while`, and `repeat` loops
#not needed yet
#enableJIT(3);
#' ## Load local config file
#' This file stores the configurations specific to your local computer
#' At the moment mostly paths to commonly used folders. Note the attempt at a 
#' new user-friendly error message telling you what to do if it doesn't work.
message('Loading local configurations');

if(! 'config.R' %in% list.files()) stop(sprintf(
"
Message from your course director...

There needs to be a config.R file in the same directory as this script. If you
haven't made one yet, or can't find yours, copy example.config.R to config.R
(copy, not move) and edit the paths to match your own (especially the user name).
You are currently in the following directory: 
%s"
,getwd())) else source('./config.R');
#' ## Load custom functions
#' An important part of this class will be not only learning to run
#' R commands, but learning to wrap them together into functions.
#' The `functions.R` file will be where you will store the functions 
#' you  write, so you can re-use them in a different project.
#source('./functions.R');
#' 
#' ## R: Anatomy of a Language, practice
#' 
cleftpatients<-5;controlegroup<-7;controlegroup - cleftpatients;
missingteeth<-3
rsults <- (controlegroup - cleftpatients)^missingteeth
rsults

mssimgteeth<- 3
missingteeth<- 3
rsults*missingteeth
if((controlegroup%%5)>5) {
  print("hello");
  print("world");} else{print("foo")} 
if((controlegroup%%3)>2) {
  
}
#' ## Load data
#' 
#' ### Main data file
#' The path to your data file should be set in your `config.R` script, above.
#' Name this object `dat01` (use a short name because you will be typing it a lot)
#' Here too I added an error message that tells you what you should actually do
#' to fix the error. Alas, most R code is less verbose in its explanations.
# if(! 'classexample01' %in% ls(.GlobalEnv)) 
#   stop(
# '
# Message from your course director...
# 
# Please look at how the classexample01 variable is set in the example.config.R
# file and update your own config.R file to match that.'
# ) else 
dat01<-read_tsv(myexample);
#' ### Data dictionary
#' A lot of what you do when you prepare the data for analysis will be
#' selecting groups of columns and rows. So it's likely that creating 
#' a data dictionary will save you the effort of manually writing column
#' names or row filters over and over.
#' 
#' #' What type of data is in each column?
dic01<-'';

dic01 <- sapply(dic01, class)
dic01 <- data.frame(name=names(dic01), class=dic01)

dat02 <- data.frame(t(dat01[,-1]))
names(dat02) <- data.frame(dat01)[,1]
#' 
#' select column
dat02[,2]
#' numeric?
is.numeric(dat02$TMEM131)
#' check all columns
sapply(dat02, is.numeric)
#' names of columns
output <- sapply(dat02, is.numeric)
names(output)
names(output)[c(5,6)]
#' plots a scatter plot
dat02[,2] %>% plot()
#' pch changes the shape of the points (+ or . )
dat02[,2] %>% plot(pch='.')
#' 
#' "col="  selects colors
#' #000000
#' first two indicate red, next two indicate green, last two indicates blue
#' 
#' "cex="  Changes size of the points 
#' 
#' 
#' Questions to consider:
#' 
#' * What columns will never be needed for analysis?
#' * What columns will be among your predictors ("independent" variables
#'   as they used to be called... i.e. the "x" side of the model)
#' * What column or columns will your outcomes (aka responses, "dependent"
#'   variables, the "y" side of the model)
#' * What columns are factors (i.e. have discrete values such as 
#'   sex, ethnicity, language, etc.) Are any of the factors 
#'   supposed to be ordered?
#' * What columns are supposed to be numeric? If they are accompanied 
#'   by units are the units always the same or do they need to be 
#'   standardized by you?
#' * What columns are supposed to be TRUE/FALSE (in R this data type 
#'   is called `logical`)?
#' * What columns are supposed to be dates? Are you sure you need dates
#'   or can you convert them into integers (e.g. days since birth, days
#'   since enrollment)?
#' * If you have multiple measurements per subject, which columns are 
#'   subject IDs? Which columns indicate time? Which other columns can
#'   vary within the same individual?
#' * Are there any columns that you will need to combine together into 
#'   new columns?
#' * Are there any columns you need to transform in some other way?
#'  
#' ## Transform data
#' Make a copy of your original data file. Do all your transformations
#' on the copy. Don't hard-code column names, but rather pull sets of
#' column names from the data dictionary that you will create.
#' 
#' If you create completely new columns of data, give them a distinctive
#' prefix, so it's easy to see that they were added during analysis rather
#' than being part of the original data. I like to use `a_` for 'analytic'
#' 
#' ### Create longitudinal variables if necessary
#' If you have repeated measures, you might need to create new columns 
#' that depend on previous or future values (examples: time until event, time 
#' since start, first ocurrence, difference from previous value, censoring
#' indicators)
#' 
#' ## Create a developmental random subset of your data
#' If you develop your statistical models (not just fitting them, but
#' all decisions you make after viewing the data) and then test hypotheses on
#' the same dataset, your hypotheses will be biased toward false positives. 
#' If your goal is prediction, your predictions will look more accurate than
#' they will actually be in a real-life setting.
#' 
#' Therefore, very early in the process you need to create a random subset
#' of your data and use only it for all your trial and error, visualization,
#' transformation, until you're sure you've got a model you trust enough that
#' you're willing to accept its results whatever they may be. Only then should
#' you plug the hold-out portion of your data into your model and see how it
#' fares.
#' 
#' If you have repeated measures, you will need to sample by subject ID
#' and keep all the rows for the subjects that are randomized to your 
#' development set.
#' 
#' ## Explore and visualize your _developmental_ dataset
#' 
#' * What variables look like they are correlated with each other?
#'   Are these correlations linear or non-linear?
#' * What variables have skewed distributions?
#' * What variables have a lot of missing values?
#' * What variables almost never change in value?
#' * Is there anything else that jumps out at you as odd?
#' 
#' This is a good point at which to create a cohort table that 
#' summarizes your dataset.
#' 
#' ## Decide on the type of model to fit to your data.
#' * If it's time to event, then probably some sort of survival 
#'   model such as `coxph()` from the `survival` library
#' * If you only know whether or not an event occurred but not when,
#'   then you'll have to settle for logistic regression using `glm()`
#' * If you don't even have individual outcomes, just the frequency
#'   of occurrence you may have to use Poisson regression, also via
#'   `glm()` but with different arguments.
#' * If you are measuring a numeric outcome rather than a discrete
#'   event, you could start with a linear model via `lm()`
#' * If you measure each subject several times, you may need to use
#'   a mixed effect model, via `lme()` from the `nlme` library.
#' * There are many other cases but the above hopefully cover the
#'   most common ones you will encounter.
#'   
#' ## Having decided on a model, you need to select variables
#' 
#' ### Univariate
#' Hopefully you already have a-priori variables chosen based on
#' previous studies and theory. Fit these one at a time and see
#' how the models look. As usual, we do not hard-code our values.
#' We create a generic model object and then automatically cycle
#' through our predictor variables updating the model object with
#' each of them in turn. This will make more sense by the time we
#' get to this section.
#' 
#' This is also the section where we will check our assumptions 
#' about model validity.
#' 
#' ### Multi-Variable
#' You might have an entire set of variables and even interaction 
#' terms based on prior studies and theory. Having checked for and 
#' hopefully addressed problems at the univariate level, you are 
#' are ready to fit a multi-variable model.
#' 
#' During this section we will talk about interaction terms
#' 
#' This model also needs to be checked for validity and goodness
#' of fit and adjusted as needed.
#' 
#' ### Stepwise selection
#' How do you know that you picked the best main effects and
#' interactions for your data? How do you know if your model is 
#' too simple to tell the real story, or needlessly complex? If
#' time permits, we will use `stepAIC()` to attempt to select the
#' optimal set of predictor terms.
#' 
#' ## Presenting and interpreting your preliminary results
#' 
#' Here we will output result tables from your models and format
#' them for presentation and publication.
#' 
#' ## Still not sure? Let's try resampling.
#' 
#' By definition there is only one first time that you get to 
#' analyze your hold-out data. After that it's not hold-out data
#' anymore. So if you're not ready to make the leap yet, you could
#' try resampling your developmental data and re-analyzing it
#' (this is the part where having well organized, modular, reusable
#' code really makes a difference).
#' 
#' ## Take the plunge: testing your model against hold-out data
#' 
#' Refactor whatever cleanup code you needed to write for the 
#' developmental data so that it can be re-run on the hold-out
#' data either as functions or as short sequences of commands 
#' that will not need a lot of editing. And... see how you do!
#' 
#' 
