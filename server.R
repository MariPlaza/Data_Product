#The file server.R defines the calculations to update the outputs of the application based on the provided inputs. 

#Step 0: Load required libraries. 
library(shiny) #For the app. 
library(ade4) #For triangle graphs
library(ggplot2) #For graphs

#The required functions to load and format the dataset to be used are contained in FruitApp.R
source("FruitApp.R")

#This two functions create the datasets for normal 100 grams portion (Data Matrix) and for the standard consumption portion. 
#The stantards consumption portion is a median fruit for: apple, pear, kiwi, tangerine, orange and banana. The other fruits considered 1 cup as the standard portion. 

Data_Matrix <- Fruit_Database()
Data_Matrix_Portion <-Fruit_Database_Portion(Data_Matrix)


# Define server logic to calculate the 3 outputs of the application. 
shinyServer(function(input, output) {
    
    #Column Order defines the name of the column in the dataset according to the input 2 in UI. 
        ColumnOrder <- reactive({
            switch(input$variable,
                   "Calories" = "Calories", 
                   "Fiber" = "Fiber", 
                   "Completeness Score" = "Completeness_Score", 
                   "Fullness Score" = "Fullness_Score", 
                   "Nutritious" = "Nutritious", 
                   "% Carb" = "%Carb", 
                   "% Fat" = "%Fat", 
                   "% Prot" = "%Prot")
        })
    
    #Dataset input defines which dataset is going to be used according to the input 1 in UI. 
        datasetInput <- reactive({
            switch(input$dataset,
               "100 Grams" = Data_Matrix,
               "Standard Portion" = Data_Matrix_Portion)
        })
        
        
    #It performs the calculations to build the text that represents the result in the comparison. 
        formulaText <- reactive({
            
            #It uses the function prepare_data to give format to the dataframe that is going to be used in the calculations. 
            #This function requires 4 parameters that are the 4 inputs of the application. It returns a sorted dataset according to the given nutritional criteria (input 2 or ColumnOrder)
            dataset<- Prepare_Data(datasetInput(),input$Fruit1, input$Fruit2, ColumnOrder())
            
            
            if (input$Fruit1=="all" && input$Fruit2=="all") 
            {
                #When Fruit 1 and Fruit 2 have all fruits, the appplication returns the best fruit among all based on the selected nutritional criteria. 
                
                paste("WINNER: ", dataset[1,"Fruit"],"The best fruit in this comparison in terms of ", input$variable, "is ", dataset[1,"Fruit"])
            }
            else
            {
                if (input$Fruit1 != "all" && input$Fruit2 != "all") 
                {
                    if (input$Fruit1==input$Fruit2)
                    {
                        #When Fruit 1 and Fruit 2 are the same, there is no comparison to make, so the information is presented but there is not a winner or specific recommendation.  
                        
                        paste("This is the information for: ", dataset[1,"Fruit"])
                    }
                    else
                    {
                        #When Fruit 1 and Fruit 2 are two specific fruits, the appplication returns the best fruit among these two options based on the selected nutritional criteria. 
                        paste("WINNER: ", dataset[1,"Fruit"],"The best fruit among ", input$Fruit1, "and ", input$Fruit2, "in terms of ", input$variable, "is ", dataset[1,"Fruit"])
                    }
                }
                else
                {
                    if (input$Fruit1 == "all")
                        {
                            BaseFruit <-  input$Fruit2    
                        } 
                        else
                        {
                            BaseFruit <-  input$Fruit1
                        }
                        
                        #When Fruit 1 or Fruit 2 are specific fruits and the other is all, the appplication returns the best fruit among all fruits and it provides the ranking for the specific fruit selected based on the selected nutritional criteria. 
                        
                        paste("WINNER: ", dataset[1,"Fruit"],"The ", BaseFruit, "ranked in position ", which(dataset$Fruit == BaseFruit), " in terms of ", input$variable, "compared with the other fruits")   
                }        
            }
        })
        
        # It returns the formula text for printing as a caption in the output 1 of the UI. 
        output$caption <- renderText({
            formulaText()
        })
        
        # It returns the plot presented in the output 2 of the UI. 
        output$Plot <- renderPlot({
            
            #It uses the function prepare_data to give format to the dataframe that is going to be used in the calculations. 
            #This function requires 4 parameters that are the 4 inputs of the application. It returns a sorted dataset according to the given nutritional criteria (input 2 or ColumnOrder)
            
            
            DataPlot <- Prepare_Data(datasetInput(),input$Fruit1, input$Fruit2, ColumnOrder())
            
            
            if (input$variable=="Calories")
            {
                # If the selected criteria is Calories, a graph plot is created comparing calories (Y-Axis) among the selected fruits (X-Axis). 
                FinalPlot <- ggplot(DataPlot, aes(Fruit, Calories, color = Category))   + geom_bar(fill="White", stat="identity") 
                FinalPlot <- FinalPlot + ggtitle("Calories Comparison")  
                FinalPlot <- FinalPlot + labs(x="Fruit",y="Calories") 
                FinalPlot <- FinalPlot + theme(panel.grid.major = element_line(colour = "white")) + theme_bw() + theme(legend.position="top")
            }
            else
            {
                if (input$variable=="Fiber")
                {
                
                # If the selected criteria is Fiber, a graph plot is created comparing fiber (Y-Axis) among the selected fruits (X-Axis). 
                    FinalPlot <- ggplot(DataPlot, aes(Fruit, Fiber, color = Category))   + geom_bar(fill="White", stat="identity") 
                    FinalPlot <- FinalPlot + ggtitle("Fiber Comparison")
                    FinalPlot <- FinalPlot + labs(x="Fruit",y="Fiber") 
                    FinalPlot <- FinalPlot + theme(panel.grid.major = element_line(colour = "white")) + theme_bw() + theme(legend.position="top")
                }
                else
                {
                    if (input$variable=="Completeness Score")
                    {
                    
                    # If the selected criteria is Completeness Score, a graph plot is created comparing Compleness Score (Y-Axis) among the selected fruits (X-Axis). 
                        FinalPlot <- ggplot(DataPlot, aes(Fruit, Completeness_Score, color = Category))   + geom_bar(fill="White", stat="identity") 
                        FinalPlot <- FinalPlot + ggtitle("Completeness Score Comparison")
                        FinalPlot <- FinalPlot + labs(x="Fruit",y="Completeness Score") 
                        FinalPlot <- FinalPlot + theme(panel.grid.major = element_line(colour = "white")) + theme_bw() + theme(legend.position="top")
                    }
                    else
                    { 
                        if (input$variable=="Fullness Score" || input$variable=="Nutritious") {
                    
                        # If the selected criteria is Fullness Score or Nutritious, a scatter plot is created graphing Fullness Score (X-Axis) and Nutritious (Y-Axis) for each of the selected fruits (Points) 
                            FinalPlot <- ggplot(DataPlot, aes(Fullness_Score, Nutritious, color=Category, label=Fruit))  + geom_point(stat="identity") 
                            FinalPlot <- FinalPlot + ggtitle("Nutritious vs Fullness Factor Comparison")  +geom_text(aes(label=Fruit),hjust=0, vjust=0)
                            FinalPlot <- FinalPlot + labs(x="Fullness Score",y="Nutritious") + scale_x_continuous(limits = c(0, 5)) + scale_y_continuous(limits = c(0, 5))
                            FinalPlot <- FinalPlot + theme(panel.grid.major = element_line(colour = "white")) + theme_bw() + theme(legend.position="top")
                            
                        }
                        else
                        {
                        # If the selected criteria is % Carb, % Protein or % Fat, a triangle plot is created graphing these 3 variables: % Carb (Left-Side), % Protein (Base) and % Fat (Right-Side) for each of the selected fruits (Points).  
                            # The triangle plot requires a specific data structure. DataPlotTriangle has the required structure. 
                            DataPlotTriangle <- cbind.data.frame(DataPlot$'%Carb', DataPlot$'%Prot', DataPlot$'%Fat')
                            row.names(DataPlotTriangle) <- DataPlot$Fruit
                            colnames(DataPlotTriangle) <- c("Carb", "Prot", "Fat")
                            FinalPlot <- triangle.plot(DataPlotTriangle, label = row.names(DataPlotTriangle), clab = 1, show = FALSE, scale = FALSE, min3 = c(0.8,0,0), max3=c(1,0.1,0.15))
                        }
                    }

                }
            }
            FinalPlot
        })
        
        #It calculates output 3, which represents the table at the end in the right panel. 
        
        output$view <- renderTable({
            DataPlot <- Prepare_Data(datasetInput(),input$Fruit1, input$Fruit2, ColumnOrder())
            head(DataPlot, n=10)
        })
        
        
})

