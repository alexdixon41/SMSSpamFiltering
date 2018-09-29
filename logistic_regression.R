library(Amelia)            # for checking for missing data
library(ROCR)              # for plotting ROC curve
library(caret)             # for cross-validation and confusion matrix

dataset <- read.csv('output.csv')
sapply(dataset, function(x) sum(is.na(x)))          # check for empty values
sapply(dataset, function(x) length(unique(x)))      # check how many unique values

missmap(dataset, main="Missing values vs observed")    # show plot of missing values

data <- dataset                 # no values missing so include all data

# check that categorical variables are factors
is.factor(data$contains_currency)
is.factor(data$spam)

# make data$spam a factor (categorical variable)
data$spam <- factor(data$spam)
is.factor(data$spam)        # TRUE

# check encoding of factors
contrasts(data$contains_currency)

# ------------------------------------------------------------------------------------------
# check CDF plots of features for justification
split <- split(data, data$spam)         # split dataset into spam and ham

# frame each sublist
spam <- data.frame(split$'TRUE')      
ham <- data.frame(split$'FALSE')

# plot cdf curves for digit_strings from both spam and ham subsets
digit_strings_split <- data.frame(x=c(spam$digit_strings, ham$digit_strings), grp=factor(rep(1:2, c(747, 4827))))
ggplot(digit_strings_split, aes(x, colour=grp)) +
  stat_ecdf() +
  scale_colour_hue(name="Legend", labels=c('Spam', 'Ham')) +
  labs(x="Digit Strings", title="CDF Plot for Digit Strings Feature")

# plot cdf curves for contains_currency from both spam and ham subsets
contains_currency_split <- data.frame(x=c(spam$contains_currency, ham$contains_currency), grp=factor(rep(1:2, c(747, 4827))))
ggplot(contains_currency_split, aes(x, fill=grp)) +
  geom_bar() +
  scale_fill_hue(name="Legend", labels=c('Spam', 'Ham')) +
  xlab("Contains Currency")
  
  
# plot cdf curves for msg_length from both spam and ham subsets
msg_length_split <- data.frame(x=c(spam$msg_length, ham$msg_length), grp=factor(rep(1:2, c(747, 4827))))
ggplot(msg_length_split, aes(x, colour=grp)) +
  stat_ecdf() + 
  scale_colour_hue(name="Legend", labels=c('Spam', 'Ham')) +
  labs(x="Message Length", title="CDF Plot for Message Length Feature")

#plot cdf curves for keyword_count from both spam and ham subsets
keyword_count_split <- data.frame(x=c(spam$keyword_count, ham$keyword_count), grp=factor(rep(1:2, c(747, 4827))))
ggplot(keyword_count_split, aes(x, colour=grp)) +
  stat_ecdf() +
  scale_colour_hue(name="Legend", labels=c('Spam', 'Ham')) +
  labs(x="Keyword Count", title="CDF Plot for Keyword Count Feature")

# ------------------------------------------------------------------------------------------
# 10 Folds Cross-Validation
train_control <- trainControl(method="cv", number=10)    # use cross-validation with 10 folds
model <- train(spam ~ ., data=data, trControl=train_control, method="glm", family="binomial")
print(model)

fitted.results <- predict(model, data)
print(fitted.results)

# use ROCR library to plot ROC curve
p <- predict(model, newdata=data)
p <- ifelse(p == 'TRUE', 1, 0)    # make p binary numeric
pr <- prediction(p, data$spam)
prf <- performance(pr, measure="tpr", x.measure="fpr")
plot(prf)

confusionMatrix(factor(fitted.results), factor(data$spam), positive=levels(reference)[2])
# ------------------------------------------------------------------------------------------
# 5 Folds Cross-Validation
train_control <- trainControl(method="cv", number=5)    # cross-validation with 5 folds
model <- train(spam ~ ., data=data, trControl=train_control, method="glm", family="binomial")
print(model)

fitted.results <- predict(model, data)
print(fitted.results)

# plot ROC
p <- predict(model, newdata=data)
p <- ifelse(p == 'TRUE', 1, 0)   # make p binary numeric
pr <- prediction(p, data$spam)
prf <- performance(pr, measure="tpr", x.measure="fpr")
plot(prf)

# show confusion matrix
confusionMatrix(factor(fitted.results), factor(data$spam), positive=levels(reference)[2])
# ------------------------------------------------------------------------------------------
# Training Set
train <- data[1:4000,]
test <- data[4001:5574,]

model <- glm(spam ~ ., family=binomial(link='logit'), data=train)
print(model)

fitted.results <- predict(model, test)
fitted.results <- ifelse(fitted.results > 0.5, 'TRUE', 'FALSE')   # if probability > 0.5, set prediction to 'TRUE', else 'FALSE'

# plot ROC
p <- predict(model, test)
pr <- prediction(p, test$spam)
prf <- performance(pr, measure="tpr", x.measure="fpr")
plot(prf)

confusionMatrix(factor(fitted.results), factor(test$spam), positive=levels(reference)[2])
