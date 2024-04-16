#### Hide packages ####
library(macleish)
library(tidyverse)
library(ggplot2)
library(mosaic)
library(mdsr)
library(dplyr)
library(backports)
library(rvest)
library(googlesheets4)
library(dplyr)
library(quantmod)
library(tidyverse)
library(partykit)
library(caTools)
library(randomForest)
library(corrplot)
library(mosaic)
library(nortest)
library(ggcorrplot)
library(car)
 
#### end ####

#Getting data from google sheets
library(googlesheets4)
data <- read_sheet("https://docs.google.com/spreadsheets/d/1G4KqoBvGLbBbeRahI6Z202x0vR-ldpS0SVY3MK19Jgw/edit#gid=481177231")

glimpse(data)
corrplot(cor(data[,c(8:23)]),method="color")
ggcorrplot(cor(data[,c(8:23)]), hc.order = TRUE, type = "lower",
           lab = TRUE)
full_model <- lm(PIE~ GP+OFFRTG+DEFRTG+`TS%`, data=data)
vif(full_model)

################################################################################
###################### Decision TREE ###########################################
################################################################################

#Decision tree classifies the dependent variable and tells what are rules we should follow for classification
# Split data into 70% training and 30% testing sets 
# We need to evaluate accuracy of model. So we generate model with training data and evaluate it by comparing it with testing data
ind <- sample.split(data$NETRTG, 0.7)
train_data <- data[ind, ]
test_data <- data[!ind, ]

# Plot decision tree
tree1 <- ctree(NETRTG ~ `TS%` + GP + MIN+`REB%` + PACE + `AST%` + `TO RATIO`, mincriterion = 0, data=train_data)
tree1
plot(tree1, type="simple")

# Evaluate the model
predicted_1 <- predict(tree1, test_data, type = "response")

# Create confusion matrix
cm_1 <- table(test_data$PIE, predicted_1)
cm_1
accuracy_1 = 100 * sum(diag(cm_1))/sum(cm_1)
accuracy_1

#Diagonal values give correct predictions. So if we divide sum of diagonal values by sum of all values, we get accuracy. I multiplied that by 100 to find percentage.


################################################################################
###################### Clustering    ###########################################
################################################################################
library(dbscan)
individual <- read_sheet("https://docs.google.com/spreadsheets/d/1mZegLEUDZWXeHRBIhGYPi5edfQcrj99j2vWQDPUV53U/edit#gid=0")
glimpse(individual)

dfCluster <- individual %>% select(Player, `3P%`, `2P%`, `FT%`, `ORB%`, `DRB%`, OWS, DWS, Ht)
head(dfCluster)
dfCluster <- drop_na(dfCluster)
head(dfCluster)
x <- as.matrix(dfCluster[, 2:9])

k = 4
minPts = 3
kNNdist(x, k, all = FALSE)

kNNdistplot(x, k, minPts) #"elbow" at 17.5

db <- dbscan(x, eps = 4, minPts = 2)
db

pairs(x, col = db$cluster + 1L)


opt <- optics(x, eps = 4, minPts = 2)
opt
opt <- extractDBSCAN(opt, eps_cl = 4)
plot(opt)

# Extract cluster labels
cluster_assignments <- db$cluster

# Add cluster assignments to dfCluster as a new column
dfCluster$Cluster <- cluster_assignments
individual$Cluster <- cluster_assignments


# Filter out players in cluster 0 and create a table with only PlayerYr and Cluster
final_table <- dfCluster %>% 
  dplyr::select(Player, Cluster)
print(final_table)

################################################################################
###################### Random Forest ###########################################
################################################################################
#Decision tree classifies the dependent variable and tells what are rules we should follow for classification
# Split data into 80% training and 20% testing sets 
splitIndex <- createDataPartition(data$VORP, p = 0.8, list = FALSE)
train_data <- data[splitIndex, ]
test_data <- data[-splitIndex, ]
# Generate random forest
attach(train_data)
varImpPlot(rf)

library(caret)

# Now you can train your model on 'train_data' and test it on 'test_data'
rf_model <- randomForest(VORP ~ I(G*GS)+`2P%`+`3P%`+ train_data$`FG%` +Age+ORB+DRB+AST+STL+BLK+TOV+PF,ntree = 1000, mtry = 4,data= train_data)
rf_model
predicted_rf <- predict(rf_model, test_data)
predicted_rf

# Evaluate Model Performance
predicted_values <- predict(rf_model, newdata = test_data)
actual_values <- test_data$VORP

# Calculate MSE and RMSE
mse <- mean((predicted_values - actual_values)^2)
rmse <- sqrt(mse)
# Calculate MAE
mae <- mean(abs(predicted_values - actual_values))

# Output performance metrics
print(paste("MSE:", mse))
print(paste("RMSE:", rmse))
print(paste("MAE:", mae))

# For model diagnostics, you could plot actual vs predicted values
plot(actual_values, predicted_values, main = "Actual vs Predicted VORP",
     xlab = "Actual VORP", ylab = "Predicted VORP")

test_data$predicted_VORP <- predicted_rf
view(test_data[c("Player", "VORP")])
