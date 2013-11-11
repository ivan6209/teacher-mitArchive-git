#Harvard-MIT Division of Health Sciences and Technology
#HST.951J: Medical Decision Support, Fall 2005
#Instructors: Professor Lucila Ohno-Machado and Professor Staal Vinterbo

################################################################################
#
# File:         experiment.r
# RCS:          $Header: $
# Description:  Experiment example
# Author:       Staal Vinterbo
# Created:      Fri Dec 02 20:15:14 2005
# Modified:     Mon Dec 12 13:46:12 2005 (Staal Vinterbo)
# Language:     ESS[S]
# Package:      N/A
# Status:       Experimental
#
# (c) Copyright 2005, Staal Vinterbo.
#
################################################################################
#
# Usage: 
# 1) download the following files to a directory named 'data' under your
#    R directory (the directory where you keep your R programs, selected
#    by File->Change Dir or getwd() and setwd() ):
#    MIT specific web links removed.
#
# 2) open the two .res files with Excel (or something similar) and remove the first
#    column with header "Description". Then remove rows 2 and 3.
#    Save the resulting files under their original names.
#
# 3) Dowload the fuzzy classification software and install in your R directory. MIT specific web links removed.
#    
# 4) put this file in your R directory.
# 5) start R and do
#    > source("experiment.r")
#

source('gcl/gcl.r')
library(nnet)

# lrc below only works for binary outcomes...
lrc <- function(InDataFrame,...){
  TrainingData <- as.data.frame(InDataFrame)
  nc <- ncol(TrainingData)
  predictors <- colnames(TrainingData)[1:min(nc - 1, nrow(TrainingData)-2)]
  outcome <- colnames(TrainingData)[nc]
  formulaText <- paste(paste(outcome, " ~ "), paste(predictors, collapse="+"))
  formula <- as.formula(formulaText)
  lrmodel <- glm(formula, family = binomial(link = logit), data=TrainingData)
  return(makefun(function(x, model){
                 p <- predict.glm(model, as.data.frame(x), type="response", se.fit=FALSE)
                 cs <- cbind(1-p,p)
                 colnames(cs) <- c(0,1)
                 return(cs)
               }, list(model=lrmodel)))
}

# nrc below only works for binary outcomes...
nrc <- function(InDataFrame, nunits=ceiling(ncol(InDataFrame)/5),alpha=0.001,
                MaxNWts=1500,...){
  nips <- ncol(InDataFrame) - 1
  ncls <- length(unique(InDataFrame[, ncol(InDataFrame)]))
  nw <- nips*nunits + ncls*nunits + 1
  
  cat("Inputs:", nips , "\n")
  cat("Nclasses", ncls  , "\n")
  cat("MaxNWts:", MaxNWts, "\n")
  cat("alpha:", alpha, "\n")
  if(nw > MaxNWts){
    cat("  Max number of weights (", MaxNWts, ") exeeded: ", nw, "!\n")
    no <- nunits
    nunits <- floor((MaxNWts - 1)/(nips + ncls))
    cat("  Adjusting # hidden nodes to:", nunits, " (old:", no, ")\n")
  }
  cat("nunits:", nunits, "\n")
  cat("N Wts:", nw <- nips*nunits + ncls*nunits + 1, "\n")
  
  TrainingData <- as.data.frame(InDataFrame)
  nc <- ncol(TrainingData)
  nn <- nnet(TrainingData[,-nc],
             TrainingData[, nc, drop=F],
             size=nunits,
             entropy=T,
             trace=F, decay=alpha,MaxNWts=MaxNWts) 
  return(makefun(function(x, model){
    p <- predict(model, x)
    cs <- cbind(1-p,p)
    colnames(cs) <- c(0,1)
    return(cs)  # here is why only for binary outcomes...
  }, list(model=nn)))
}


filtgcor <- function(golub, ngenes=nrow(golub) - 2){
  corrs <- abs(apply(golub, 2, cor, golub[,ncol(golub)], method="kendall"))
  corrs[ncol(golub)] <- 0
  o <- order(corrs, decreasing=T)
  incl <- o[1:ngenes]
  return(golub[,c(incl, ncol(golub))])
}

# make probability proxies out of memberships or similar prediction beliefs
pmem <- function(m)
  t(apply(m, 1, function(x) x/sum(x)))


#assumes first column is acc number, i.e., description column has been deleted
getgolubdata <- function(fname){
  gdata <- read.delim(fname)
  incl <- sapply(gdata[2,], is.numeric)
  cn <- as.vector(gdata[,1])
  cn <- gsub("[-\/+\*]","_", cn) # get rid of -/+* in colnames
  gdata <- t(gdata[, incl])
  colnames(gdata) <- cn
  return(gdata)
}


goodseed <- 885090
myexperiment <- function(golub, folds=8, seed=sample(1:1000000, 1)){
  # read data
  cat("Data ", nrow(golub), "rows, with", ncol(golub), "genes.\n")

  # filter genes
  ngenes <- nrow(golub) - 2
  cat("Filtering data...\n")
  
  golub.f <- filtgcor(golub)
  cat("done.\n")
  cat("Selected the", ngenes, "highest correlated genes.\n")

  res <- c()
  
  cat("Doing", folds, "fold CV...\n")
  rescv <- cvcomp(golub.f, tcl, nrc, ci.eval, folds=folds, seed=seed, cv.verbose=F, t.nlev=3)
  res <- c(res, rescv)  

  cat("Doing 5x2 fold CV...\n")  
  res52 <- cv52(golub.f, tcl, nrc, ci.eval, cv.verbose=F, t.nlev=3, seed=seed)
  res <- c(res, res52)
  return(res)
}


calp <- function(preds, acts, bins=10, do.plot=F,...){
  n <- length(preds)
  bsize <- ceiling(n/bins)
  o <- order(preds)
  g <- rep(1:bins, 1, n, each=bsize)
  p <- t(sapply(unique(g),
           function(x,g,a,b)
           c(sum(a[g==x])/sum(g==x), sum(b[g==x])/sum(g==x)), g, preds[o], acts[o]))
  if(do.plot)
    plot(p, xlim=c(0,1), ylim=c(0,1), ...)
  return(p)
}




################# The Experiment

cat("Reading data...\n")
train <- getgolubdata("data/ALL_vs_AML_train_set_38_sorted.res")
test <-  getgolubdata("data/Leuk_ALL_AML.test.res")

traincls <- unlist(read.table("data/ALL_vs_AML_train_set_38_sorted.cls",
                              fill=T)[2,],use.names=F)
testcls <- unlist(read.table("data/Leuk_ALL_AML.test.cls",
                              fill=T)[2,],use.names=F)
train <- cbind(train, class=traincls)
test <- cbind(test, class=testcls)

cat("Filtering training set...\n")
train.f <- filtgcor(train)

cat("Repeating Original Classification Task:\n---------------------------------\n")
cat("*Fuzzy Tree:\n")
tf <- tcl(train.f, t.nlev=3)
cat(tf())
cat(" Performance on Training Set:", ci.eval(tf, train.f), "\n")
cat(" Performance on Test Set:", ci.eval(tf, test), "\n")
cat(" Plotting calibration plot for Fuzzy tree on test data.\n")
calp(pmem(tf(test))[,2], test[,ncol(test)], do.plot=T,
     main="Calibration: Fuzzy Tree on Test Data",
     type="l", xlab="Prediction", ylab="Actual")


cat("\n*Neural Network:\n")
nf <- nrc(train.f)
cat(" Performance on Training Set:", ci.eval(nf, train.f), "\n")
cat(" Performance on Test Set:", ci.eval(nf, test[,colnames(train.f)]), "\n")

cat("Doing 8 fold CV and 5x2 CV performance comparison:\n----------------------------------\n")
res <- myexperiment(rbind(train, test))

cat("\n\n8 fold CV T test:\n")
print(res$tt)
cat("  Plotting boxplots of performances for the two classifiers...\n")
boxplot(res$tcis, res$lcis, names=c("Fuzzy Tree", "Neural Network"),
        ylab="C-Index", main="8-CV Performance")

cat("\n5x2CV Results:\n")
print(res$m)
cat("5x2CV mean CI difference:", mean(res$m[,5:6]), "\n")
cat("5x2CV F test P-value:", res$p, "\n")
cat("The probability that any observed difference in performance is by chance is:",
    1 - res$p, "\n")
cat("That's all folks...\n")






