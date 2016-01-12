library(ggplot2)

Fruit_Database <- function() {
    #Initial vectors to build the dataset that is going to be built. 
    fruits <- c("Apple", "Banana", "Pineapple", "Pear", "Strawberry", "Tangerine", "Orange", "Kiwi", "Watermelon", "Melon")
    measures <- c("Calories", "Fiber", "Completeness_Score", "Fullness_Score", "Nutritious", "%Carb", "%Fat", "%Prot")
    # All the data is coming from the following source: 
    #Apple: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/1809/2 (Medium fruit)
    Apple <- c(52,2,32,3.3, 2.7, 0.95, 0.03, 0.02)
    #Banana: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/1846/2 (Medium fruit)
    Banana <- c(89,3,42,2.5, 2.8, 0.93, 0.03, 0.04)
    #Pineapple: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/2019/2 (1 cup)
    Pineapple <- c(50,1,49,3.3, 3.3, 0.94, 0.02, 0.04)
    #Pear: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/2005/2 (Medium fruit)
    Pear <- c(58,3,35,3.1, 2.7, 0.96, 0.02, 0.02)
    #Strawberry: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/2064/2 (1 cup)
    Strawberry <- c(32,2,60,4.3, 3.9, 0.85, 0.08, 0.07)
    #Tangerine: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/1978/2 (Medium fruit)
    Tangerine <- c(53,2,53,3.2, 3.8, 0.90, 0.05, 0.05)
    #Orange: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/1966/2 (Medium fruit)
    Orange <- c(47,2,57,3.5, 3.9, 0.91, 0.02, 0.07)
    #Kiwi: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/1934/2 (Medium fruit)
    Kiwi <- c(61,3,55,3, 4, 0.87, 0.07, 0.06)
    #Watermelon: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/2072/2 (1 cup)
    Watermelon <- c(30,0,52,4.5, 3.8, 0.89, 0.04, 0.07)
    #Melon: http://nutritiondata.self.com/facts/fruits-and-fruit-juices/1955/2 (1 cup)
    Melon <- c(28,1,58,4.5, 3.7, 0.84, 0.03, 0.13)
    
    #Build Data Matrix and Data Matrix Portion to be used in the comparisons. 
    Data_Matrix <- rbind(Apple, Banana, Pineapple, Pear, Strawberry, Tangerine, Orange, Kiwi, Watermelon, Melon)
    colnames(Data_Matrix) <- measures
    
    Data_Matrix <- as.data.frame(Data_Matrix)
    Data_Matrix$Fruit <- fruits
    
    Data_Matrix$Fruit<- as.factor(Data_Matrix$Fruit)
    return(Data_Matrix)
}

Fruit_Database_Portion <- function(Data_Matrix) {
    fruit_portion_factor <- c(95/52,105/89,82/50,103/58,49/32,47/53,62/47,46/61,46/30,48/28)
    Data_Matrix_Portion <- Data_Matrix
    Data_Matrix_Portion[,1] <- Data_Matrix_Portion[,1] * fruit_portion_factor
    Data_Matrix_Portion[,2] <- Data_Matrix_Portion[,2] * fruit_portion_factor
    Data_Matrix_Portion<- as.data.frame(Data_Matrix_Portion)
    return(Data_Matrix_Portion)
}

Prepare_Data <- function(dataset, Fruit1, Fruit2, Variable) {
    
    if (Fruit1=="all" && Fruit2=="all") 
    {
        Data1 <- dataset[dataset$Fruit!=Fruit2,]
        Data2 <- NULL
        Data1$Category <- 'All Fruits' 
    }
    else
    {
        if (Fruit1 != "all" && Fruit2 != "all") 
        {
                Data1 <- dataset[Fruit1,]
                Data2 <- dataset[Fruit2,]
        }
        else
        {
            if (Fruit1 == "all")
            {
                Data2 <- dataset[Fruit2,]
                Data1 <- dataset[dataset$Fruit!=Fruit2,]
            } 
            else
            {
                Data1 <- dataset[Fruit1,]
                Data2 <- dataset[dataset$Fruit!=Fruit1,]
            }
        }        
        Data1$Category <- 'Fruit 1' 
        Data2$Category <- 'Fruit 2'
    }
    
    Data <- rbind(Data1, Data2)
    if (Fruit1==Fruit2 && Fruit1 != "all")
    {
        Data <- subset(Data,Category=="Fruit 1")
    }
    
    if (Variable=="Calories")
    {
        Data <- Data[order(Data[,Variable],decreasing=FALSE),]
    }
    else
    {
        Data <- Data[order(Data[,Variable],decreasing=TRUE),]
    }
    
    Data <- Data[,c("Category",  Variable, setdiff(names(Data), c(Variable, "Fruit", "Category")),"Fruit")]
    
    return(Data)
}
