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
if(! 'classexample01' %in% ls(.GlobalEnv)) 
  stop(
'
Message from your course director...

Please look at how the classexample01 variable is set in the example.config.R
file and update your own config.R file to match that.'
) else dat01<-read_csv(classexample01);
#' ### Data dictionary
#' A lot of what you do when you prepare the data for analysis will be
#' selecting groups of columns and rows. So it's likely that creating 
#' a data dictionary will save you the effort of manually writing column
#' names or row filters over and over.
#' 
#' # What type of data is in each column?
#' 
#' 1. What are the column names?
names(dat01);
#' What are the column types? (the `for` version)
dct01.for <- c();
for( ii in names(dat01) ) 
  dct01.for <-c (dct01.for,class(dat01[[ii]]));
#' The `sapply` version
dct01 <- sapply(dat01,class);
dct01 <- data.frame(column=names(dct01),class=dct01,stringsAsFactors = F);
#dct01$column <- as.character(dct01$column);
#' A way to find and save for later the names of all the numeric, character,
#' and date columns, respectively.
dct01$num<- dct01$class=="numeric";
dct01$char <- dct01$class=="character";
dct01$date <- dct01$class=="Date";
dct01$meta <- F;
#' Here we create a meta column which will be TRUE for variables that are not
#' supposed to be directly used in analysis. "Housekeeping" variables.
#' `grepl` returns TRUE when the value of the vector in the second argument,
#' in this case the column named `'column'`, is matched by the regular expression
#' in the second argument, in this case `'_unit$|_info$'` (ends with _unit or 
#' ends with _info). Otherwise it returns FALSE. This results in a vector of 
#' TRUE/FALSE values. When we have a vector of TRUE/FALSE values inside a pair 
#' of single brackets, `[ ]`, on the left side of the comma 
#' `dct01[ c(T,F,F,T,T,F,T) , ... ]` it means that only the rows corresponding 
#' to TRUE will be returned. To the right of the comma we specify the column/s. 
#' So by itself `dct01[grepl('_unit$|_info$',dct01$column),'meta']` would return 
#' the values of the `'meta'` column for the rows whose name listed in `'column'`
#' ends with _unit or _info. But notice that we have the assignment arrow `<-` 
#' pointing _at_ this expression. Some R expressions, such as `names(...)` and 
#' `levels(...)` can be on the receiving end of an assignment. They take whatever
#' value is on the right of them and modify one of their arguments using that
#' value. Subsetting expressions like `$`, `[ ]`, and `[[ ]]` can accept 
#' assignment of new values. This is what we are doing here-- assigning a TRUE
#' value to the `'meta'` column for every row whose names in `'column'` ends with
#' _unit or _info.
dct01[grepl('_unit$|_info$',dct01$column),'meta'] <- T;
#' We also assign a TRUE to the `'meta'` column for the first three values 
#' because in this example we happen to know that they are study-IDs or dates.
#' As mentioned before, instead of having a TRUE/FALSE vector to the left of the
#' comma we can have a numeric vector specifying exactly which rows to include
#' and that's what we are doing here.
dct01[1:3,'meta'] <- T;
#' Now our data dictionary, `dct01` has a column, `'meta'`, which tells us which
#' values not to plot or analyze directly, even if they happen to be numeric.
#' 
#' ## For next time:
#' 
#' * Pick a column from dat01 _or your own dataset_
#' * How many NA (not available) values does it have?
#' * What type of data is it?
#' * Plot histogram of it.
#' * Plot a scatterplot of that variable versus `age_at_visit_days`
#' * Get a count of unique values
#' * Get a summary of it... if it's a character, convert it to a factor
#' * Is this a possible response, possible predictor, both, or a 'housekeeping' variable (neither)?
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
dat02 <- dat01;
dat02[,grep('^v',dct01[ !dct01$meta & dct01$char , 'column' ],val=T)] <- dat02[,grep('^v',dct01[ !dct01$meta & dct01$char , 'column' ],val=T)] %>% sapply(function(xx) !is.na(xx),simplify=F);
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
sampled <- sample(unique(dat02$patient_num),30);
dat03 <- subset(dat02,patient_num %in% sampled);
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
#
#' # Regression!
#' 
#' Let's make a heatmap of just the numeric variables..
#' 
#' The compact version...
dat01[   dct01[[1]][dct01[[3]]]    ] %>% as.matrix() %>% cor(use='pair') %>% heatmap(symm = T);
#' The expanded version but giving the exact same result
heatmap(
  cor(
    as.matrix(
      dat01[           # this is our data.frame
        dct01[[ 1 ]][  # this is the data dictionary (column 1)
          dct01[[ 3 ]] # this is also a column from the data dictionary
        ]               # this one selects just the numeric column names
      ]
    )
    ,use='pair'  # use='pair' means it will do correlations on just the non-missing pairs of variables
    )  
,symm=TRUE); # symm=TRUE tells heatmap that it's plotting something symmetric

#' Here are our numeric predictor variables
dct01[[1]][dct01[[3]]][-1];

#' Our first linear model! Using oxygen saturation to predict age
lm01 <- lm(
  "age_at_visit_days ~ v003_Strtn_LNC_2710_2_num"
  , dat01);
#' What if we want to predict O2 saturation (LOINC code 2710-2, you don't need to actually know that though)
#' as a function of age?
lm01 <- update(lm01, "v003_Strtn_LNC_2710_2_num ~ age_at_visit_days");
