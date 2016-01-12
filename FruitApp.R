# This function creates the base dataset with the information coming from the http://nutritiondata.self.com/. 
# For simplification purposes and facilitate the understanding of the code for the taks, each vector was created manually, but in the future it could be created a function to get the data directly from the web pages. 

Fruit_Database <- function() {
    #Initial vectors to build the dataset that is going to be built. 
    fruits <- c("Apple", "Banana", "Pineapple", "Pear", "Strawberry", "Tangerine", "Orange", "Kiwi", "Watermelon", "Melon")
    measures <- c("Calories", "Fiber", "Completeness_Score", "Fullness_Score", "Nutritious", "%Carb", "%Fat", "%Prot")

    # All the data is coming from the following sources, the data is based on 100 grams portion: 
    #Apple: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/1809/2 
    Apple <- c(52,2,32,3.3, 2.7, 0.95, 0.03, 0.02)
    #Banana: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/1846/2 
    Banana <- c(89,3,42,2.5, 2.8, 0.93, 0.03, 0.04)
    #Pineapple: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/2019/2 
    Pineapple <- c(50,1,49,3.3, 3.3, 0.94, 0.02, 0.04)
    #Pear: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/2005/2 
    Pear <- c(58,3,35,3.1, 2.7, 0.96, 0.02, 0.02)
    #Strawberry: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/2064/2
    Strawberry <- c(32,2,60,4.3, 3.9, 0.85, 0.08, 0.07)
    #Tangerine: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/1978/2 
    Tangerine <- c(53,2,53,3.2, 3.8, 0.90, 0.05, 0.05)
    #Orange: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/1966/2 
    Orange <- c(47,2,57,3.5, 3.9, 0.91, 0.02, 0.07)
    #Kiwi: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/1934/2 
    Kiwi <- c(61,3,55,3, 4, 0.87, 0.07, 0.06)
    #Watermelon: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/2072/2
    Watermelon <- c(30,0,52,4.5, 3.8, 0.89, 0.04, 0.07)
    #Melon: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/1955/2
    Melon <- c(28,1,58,4.5, 3.7, 0.84, 0.03, 0.13)
    
    #Build Data Matrix and Data Matrix Portion to be used in the comparisons. 
    Data_Matrix <- rbind(Apple, Banana, Pineapple, Pear, Strawberry, Tangerine, Orange, Kiwi, Watermelon, Melon)
    colnames(Data_Matrix) <- measures
    
    #Convert the matrix in a data frame and create the column with the name of the fruit. 
    Data_Matrix <- as.data.frame(Data_Matrix)
    Data_Matrix$Fruit <- fruits
    
    #Create the fruit as a Factor.     
    Data_Matrix$Fruit<- as.factor(Data_Matrix$Fruit)
    return(Data_Matrix)
}


# This function creates the dataset adapted to standard consumption portion according to the following criteria: 
    #   Medium fruit: Apple, Pear, Banana, Kiwi, Orange, Tangerine
    #   1 Cup: Pineapple, Strawberry, Melon, Watermelon. 

# The ratios established for each fruits are the ratio between 100 grams portion and the standard portion of consumption. 
# Just calories and fiber are adapted, since the other criterias are standard and independent of the size of the portion. 

Fruit_Database_Portion <- function(Data_Matrix) {
    
    fruit_portion_factor <- c(95/52,105/89,82/50,103/58,49/32,47/53,62/47,46/61,46/30,48/28)
    Data_Matrix_Portion <- Data_Matrix
    Data_Matrix_Portion[,1] <- Data_Matrix_Portion[,1] * fruit_portion_factor
    Data_Matrix_Portion[,2] <- Data_Matrix_Portion[,2] * fruit_portion_factor
    Data_Matrix_Portion<- as.data.frame(Data_Matrix_Portion)
    return(Data_Matrix_Portion)
}

# This function prepares the dataset to be used by the server.R file. It requires 4 variables that are equivalent to the 4 inputs provided by the user. 

Prepare_Data <- function(dataset, Fruit1, Fruit2, Variable) {
    
    #If Fruit 1 and Fruit 2 include all fruits, just fruit 1 is considered to avoid duplication. 
    if (Fruit1=="all" && Fruit2=="all") 
    {
        Data1 <- dataset[dataset$Fruit!=Fruit2,]
        Data2 <- NULL
        
        #Since there is not a main fruit for comparison, there is not distinction among categories. 
        Data1$Category <- 'All Fruits' 
    }
    else
    {
        
        if (Fruit1 != "all" && Fruit2 != "all") 
        {
            #Subset the specific fruits selected in Fruit 1 and Fruit 2 inputs in the User Interface. 
                Data1 <- dataset[Fruit1,]
                Data2 <- dataset[Fruit2,]
        }
        else
        {
            
            if (Fruit1 == "all")
            {
                #If Fruit 1 is all and Fruit 2 is a specific fruit. The Data2 contains Fruit 2 and Data1 all fruits except Fruit 2. 
                Data2 <- dataset[Fruit2,]
                Data1 <- dataset[dataset$Fruit!=Fruit2,]
            } 
            else
            {
                #If Fruit 2 is all and Fruit 1 is a specific fruit. The Data1 contains Fruit 1 and Data2 all fruits except Fruit 1. 
                Data1 <- dataset[Fruit1,]
                Data2 <- dataset[dataset$Fruit!=Fruit1,]
            }
        }        
        # The field category is used to identify the category given by the user through Fruit 1 and Fruit 2 input varables. 
        Data1$Category <- 'Fruit 1' 
        Data2$Category <- 'Fruit 2'
    }
    
    #Both dataset are combined to create the final dataset. 
    Data <- rbind(Data1, Data2)
    
    #If Fruit 1 and Fruit 2 are the same, just the first is selected to avoid duplication. 
    if (Fruit1==Fruit2 && Fruit1 != "all")
    {
        Data <- subset(Data,Category=="Fruit 1")
    }
    
    #If variable Calories is choosen, the dataset is ordered increasing because the fruit with less calories is considered the best. 
    if (Variable=="Calories")
    {
        Data <- Data[order(Data[,Variable],decreasing=FALSE),]
    }
    #If any other variable rather than Calories is choosen, the dataset is ordered decreasing because the fruit with more Fiber, Fullness Factor and so on is considered the best. 
    else
    {
        Data <- Data[order(Data[,Variable],decreasing=TRUE),]
    }

    #The columns of the dataset are organized with the Category, then the evaluated Variable and then the other variables in the dataset. 
    Data <- Data[,c("Category",  Variable, setdiff(names(Data), c(Variable, "Fruit", "Category")),"Fruit")]
    
    #Return the transformed dataset. 
    return(Data)
}
