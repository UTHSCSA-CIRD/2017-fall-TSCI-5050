#' ---
#' title: "TSCI 5050: Introduction to Data Science: Homework 2"
#' author: "Alex F. Bokov"
#' date: "10/31/2017"
#' ---
#' Please copy this file to `YOURNAME_hw02.R` then commit it as usual
#' by issuing the following commands in the bash shell (not in R):
#' 
#' `git co YOURBRANCH`
#' 
#' `git ci YOURNAME_hw02.R -m "Added homework #2"`
#' 
#' `git push`
#' 
#' Repeat the above whenver you make changes to this file. You may work 
#' with other people on this homework, just make sure to credit each other
#' on your individual homework sheets.
#' 
#' First we load the `run.R` file using the `source('run.R')`
#' command but we don't display it in the formatted output to
#' keep it from cluttering up the document.
#+ echo=FALSE, message=FALSE,results='hide'
source('run.R');
#' 
#' `run.R` already creates a dct01 table, so we just need to add columns
#' 
#' ## 1. Missing and Unique Values
#' 
#' > Create a column in dct01 (the data dictionary table) that contains the fraction of missing values and another for the number of unique values
#' 
#' Hints for that student:
#' 
#' * Read the following help pages: `?sapply`, `?sum`, `?is.na`
#' * Remember these rules:
#'     * `FOO <- summary` creates a an object named `FOO` which is a function that
#'     is identical to the built-in function `summary`
#'     `FOO(1:10)` is identical to `summary(1:10)`. `FOO` is a valid second argument
#'     for `sapply(...)`. __`FOO()` is _not_ a valid second argument for `sapply(...)`,
#'     keep reading to understand why.__
#'     * `BAR <- summary(1:10)` creates an object named `BAR` containing the results
#'     of `summary(1:10)` which in this case happens to be table of summary statistics.
#'     `BAR` is _not_ a valid second argument to `sapply(...)` because it is not an
#'     actual function-- it is the result of a function. Exactly like `sqrt(4)` is 
#'     not a function, but rather the number `2`, though `sqrt` is a function.
#'     * `BAZ <- summary()` will give you an error because `summary` requires
#'     something to summarize. `summary()` is therefore also _not_ a valid second 
#'     argument for `sapply(...)` (just like `FOO()` was not). Even if instead of 
#'     `summary()` we were using something that doesn't require an argument like `getwd()`
#'     it still cannot be used as a second argument for `sapply(...)` because it's
#'     not a function, it's a value that gets returned by that function (but you
#'     could use `getwd` as a second argument because `getwd` _is_ a function)
#'     * `BAT <- function(xx,...){}` creates an object named `BAT` which is a 
#'     function that does nothing. `BAT` is a valid (albeit useless) second argument
#'     to `sapply(...)`. `BAT()` is _not_. Are you starting to see the pattern yet?
#'     * `BAX` <- function(xx,...){summary(xx)} creates function `BAX` that returns 
#'     the same result as the built-in function `summary` but technically speaking
#'     is not exactly the same as `summary`. `BAX` is a valid second argument for 
#'     `sapply(...)` though there's no reason to use it instead of `summary` itself.
#'     `BAX()` is not a valid second argument to `sapply(...)`.
#'     * `BAY <- function(xx,...){summary(log(xx))}` creates function `BAY` that
#'     returns a summary _of the natural log of its first argument_. Now this is
#'     a novel combination of functions that is _not_ redundant with any existing R 
#'     function. Which of the following are valid second arguments for `sapply(...)`?
#'        *BAY is a valid second argumet*
#'        * `BAY` 
#'         * `BAY()`
#'         * `BAY(1:10)`
#'     * `function(xx,...){summary(log(xx))}` seems to just print out the code you
#'     just typed in on your console. If you type `BAY`, from the above example,
#'     into your console you will get an identical output. Try running
#'     `class(function(xx,...){summary(log(xx))})` and then try `class(BAY)`. What
#'     do they both say? Except one of them gets dumped to your console and forgotten
#'     whereas the other is retained as an object and can be reused later. 
#'         * __Remember that in R anyplace where you can use a value, you can 
#'         substitute a function that returns that type of value.__ For example 
#'         if `2.71828182845905 - 2` is valid then `exp(1) - 2` will also be 
#'         valid, as will `exp(2) - 2` (though the latter will give a different 
#'         result than the first two).
#'         * This implies that if `BAY(1:10)` returns a result then despite how
#'         wierd it looks `function(xx,...){summary(log(xx))}(1:10)` should not
#'         only work but it should return the same result! It actually doesn't, 
#'         because of the rules governing the order of operations, but
#'         you can force `function(xx,...){summary(log(xx))}` to all run before 
#'         `(1:10)` by using parentheses just as you would in `(10-2)/3` vs 
#'         `10-2/3`. So try it-- what happens when you run 
#'         `(function(xx,...){summary(log(xx))})(1:10)`? What about `(BAY)(1:10)`?
#'         * What happens when you run `sapply(...)` with, say, the `mtcars` 
#'         built-in data.frame as its first argument and 
#'         `function(xx,...){summary(log(xx))}`? Why did that work? All along I 
#'         kept saying that 
#'         `BAT()` is not a valid second argument, `BAT(5)` is not a valid 
#'         second argument and so on and yet here we are using something followed
#'         by parentheses and arguments yet it works?! The reason it works 
#'         is that the actual requirement is for the second argument to be a 
#'         function. Most of the time expressions that look like `BAH()` return
#'         some kind of value that is not a function. But a few do return a 
#'         function and that's what makes them valid for use with `sapply()`.
#'         The most common such expression is `function(...){...}` with 
#'         arguments instead of the first `...` and one or more commands instead
#'         of the second `...` and that is what we are using here. In R this is 
#'         called an anonymous function and in computer science in general it is
#'         also called a lambda function.
#' * You can add a new column to a `data.frame` using any of the following. All give the same result.
#' Pay close attention to quotes (`'`), commas (`'`), dollar signs (`$`) and 
#' how many brackets (`[`,`]`) there are and where they are. This is very 
#' important.
#'     + `FOO$BAR <- BAZ`
#'     + `FOO[['BAR']] <- BAZ`
#'     + `FOO[,'BAR'] <- BAZ`
#' * If the column name (in the above example, `FOO`) already exists then it will
#' be replaced with a value you assign to it instead of a new column being created.
#' * Remember that `dat01` is actual data and for each *column* in `dat01` there 
#' exists a *row* that describes it in `dct01`. That is what it means that `dct01`
#' is the data dictionary for `dat01`. 
#' * If something is a TRUE/FALSE vector, it also behaves like a 0/1 vector, which
#' means you can do arithmetic on it.
#'     * The `mean()` of a vector of 1s and 0s is the same as the fraction of the 
#'     values that are 1.
#'     * The `sum()` of a vector of 1s and 0s is the same as the count of 
#'     values that are 1.
#'     * If you subtract the fraction positive from 1 you get the fraction negative.
#'     
#' ### Answer:
#' 
#' dct01['color']<-NA
#' View(dct01 )
#' unique (unlist (lapply (dct01, function (x) which (is.na (x)))))


#' ## 2. Pattern Matching
#' 
#' > Create a column in dct01 with a FALSE for every value of the 'column' column 
#' that contains the strings '_date','_unit','_info', or 'patient' (these are the 
#' non-analytic columns) and TRUE otherwise. Create another that is TRUE whenever 
#' the previous column is true and in addition the class is character 
#' (or char == TRUE).
#' 
#' Hints for the student:
#' 
#' * Read the help page for `?grepl`. 
#'     * Pay special attention to the `pattern` and `x` sub-sections of the 
#'     `Arguments` section. 
#'     * Pay special attention to the first three paragraphs of the `Value` section
#'     * Ignore the other parts of the help page, they go into the weeds and are 
#'     confusing.
#'     * Once you can answer the following questions, you know what you need for
#'     this step:
#'         * Let's say you want to look for all values containing the pattern `'ba'`
#'         and your vector of values is `c('foo','bar','baz','bzz')`. Which should 
#'         the `pattern` argument argument be and which should the `x` argument
#'         be?
#'         * How do you get a logical vector with `TRUE` for each match and a 
#'         `FALSE` otherwise (i.e. c(`FALSE`,`TRUE`,`TRUE`,`FALSE`)?
#'         * How do you get a numeric vector telling you the positions of the 
#'         matching items in your vector (i.e. `c(2,3)`)?
#'         * How do you get a character vector telling you the actual values that
#'         match the pattern? What should that vector look like?
#'* Regular expressions are a whole topic unto themselves but here are some
#'     quick and dirty rules/examples to get you started:
#'     * In R, regular expressions are always character values, so they have
#'         quotes around them. `grepl(ba,...)` will give an error unless you also happen to
#'         have some variable that is named `ba`. Even if you do have such a
#'         variable, it needs to have a character value. If that condition is met
#'         then the value of that variable will be used as your regular expression
#'         pattern (regexp for short).
#'     * `'ba'` is a regexp that will match anything that
#'         contains `'ba'` anywhere.
#'     * `^'ba'` will only match things that start with `'ba'`, so `'bar'` 
#'         matches but `'foobar'` does not.
#'     * `'ba$'` will only match things that end with `'ba'` so `'baba'` matches
#'         but `'bar'` does not.
#'     * This implies that `^$` matches the empty character value `''` and that's
#'         exactly what it does.
#'     * `'b.a'` will match anything (represented by '.') that has exactly 
#'         one character of any sort in between a `'b'` and an `'a'`. So `'bla'` 
#'         and `'b a'` match but `'blla'`, `'b  a'`, and `'bar'` do not. What will
#'         `'b..a'` match?
#'     * `'b\\.a'` will match anything containing `'b.a'`, i.e. the `'\\'` 
#'         preceding the `'.'` makes it get interpreted as an ordinary period 
#'         character. So `'\\'` is known as an escape sequence.
#'         * The following characters are special and need to be preceded 
#'             with a `'\\'` escape sequence if you want to match their literal 
#'             values: 
#'             `^`,`$`,`[`,`]`,`(`,`)`,`?`,`|`,`.`
#'         * Generally normal characters should not be escaped in this manner
#'             because some of them _acquire_ some kind of special significance 
#'             when you do that!
#'         * The `\` character is extra-special because of its escape sequence
#'             role. If you want to match the literal `\` character you have to 
#'             put `'\\\\'` in your pattern! It gets worse. `\` is one of the few
#'             characters that also has a special meaning in ordinary character
#'             strings. So the character vector in which you are searching for 
#'             `\` also needs to have this character escaped. You do this with
#'             `'\\'`. Putting it all together, if you want to find the pattern
#'             that looks like "b\a" you would need to do `grep('b\\\\a','b\\a')`
#'             but if there aren't things like `'bxa'` or `'b a'` that would cause
#'             ambiguities, it often is simpler to just use `grep('b.a','b\\a')`
#'      * `'b|a'` will match any occurrence of `'b'` or of `'a'`. All the
#'             following match: `'b'`, `'a'`,`'ba'`,`'ab'`,`'wertweraEUgd'`. In order to
#'             not match, a value has to not contain any `'a'`s or `'b'`s at all.
#'             So `'wertweraEUgd'` and `E` do not match.
#'      * `'^b|^a'` will match only values that start with a `'b'` or an
#'             `'a'` (see the part above about the `'^'` special character. So 
#'             `'brr'` and `'arr'` match but `'fan'` and `'zbb'` do not.
#'             The same reasoning applies to `'$'` (again, see above).
#' * Putting this all together, if you have a vector of character values you should
#' now be able to return a `TRUE` for each value that matches a pattern, or several
#' patterns delimited by a `'|'` in your regexp, and if you want to make sure they
#' occur at the ends of their respective strings you know that you can put a `'$'`
#' at the end of each one.
#' * Reminder: if you have two logical vectors `FOO <- c(T,T,F)` and `BAR <- c(T,F,T)`
#' then you can do further logical operations on those vectors.
#'     * What do you get with `FOO & BAR`, and why?
#'     * What do you get with `FOO | BAR`, and why?
#'     * What do you get with `!FOO` and `!BAR` and why?
#' * `any(...)` takes any number of logical vectors as arguments and returns a single 
#' `TRUE` if any value in any of the vectors is true, otherwise it returns a `FALSE`.
#' If any of the values happen to be `NA` (missing) then it instead returns `NA`. You
#' can cause it to ignore the `NA`s by including as the final (optional) argument
#' `na.rm = FALSE`.
#' 
#' ## Answer: 
#' grep("_date", dct01, value = T)
#' grep("_unit", dct01, value = T)
#' grep("_info", dct01, value = T)
#' grep("patient", dct01, value = T)
#' 
