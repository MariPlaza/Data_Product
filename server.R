library(shiny)
library(ade4)
library(ggplot2)
# We tweak the "am" field to have nicer factor labels. Since this doesn't
# rely on any user inputs we can do this once at startup and then use the
# value throughout the lifetime of the application
# Load of the Dataset to be used. 

source("FruitApp.R")
Data_Matrix <- Fruit_Database()
Data_Matrix_Portion <-Fruit_Database_Portion(Data_Matrix)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
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
        datasetInput <- reactive({
            switch(input$dataset,
               "100 Grams" = Data_Matrix,
               "Standard Portion" = Data_Matrix_Portion)
        })
        # Show the first "n" observations
        output$view <- renderTable({
            DataPlot <- Prepare_Data(datasetInput(),input$Fruit1, input$Fruit2, ColumnOrder())
            head(DataPlot, n=10)
        })
        # xxx
        formulaText <- reactive({
            dataset<- Prepare_Data(datasetInput(),input$Fruit1, input$Fruit2, ColumnOrder())
            
            if (input$Fruit1=="all" && input$Fruit2=="all") 
            {
                paste("WINNER: ", dataset[1,"Fruit"],"The best fruit in this comparison in terms of ", input$variable, "is ", dataset[1,"Fruit"])
            }
            else
            {
                if (input$Fruit1 != "all" && input$Fruit2 != "all") 
                {
                    if (input$Fruit1==input$Fruit2)
                    {
                        paste("This is the information for: ", dataset[1,"Fruit"])
                    }
                    else
                    {
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
                        paste("WINNER: ", dataset[1,"Fruit"],"The ", BaseFruit, "ranked in position ", which(dataset$Fruit == BaseFruit), " in terms of ", input$variable, "compared with the other fruits")   
                }        
            }
        })
        
        # Return the formula text for printing as a caption
        output$caption <- renderText({
            formulaText()
        })
        

        output$Plot <- renderPlot({
            DataPlot <- Prepare_Data(datasetInput(),input$Fruit1, input$Fruit2, ColumnOrder())
            if (input$variable=="Calories")
            {
                FinalPlot <- ggplot(DataPlot, aes(Fruit, Calories, color = Category))   + geom_bar(fill="White", stat="identity") 
                FinalPlot <- FinalPlot + ggtitle("Calories Comparison")  
                FinalPlot <- FinalPlot + labs(x="Fruit",y="Calories") 
                FinalPlot <- FinalPlot + theme(panel.grid.major = element_line(colour = "white")) + theme_bw() + theme(legend.position="top")
            }
            else
            {
                if (input$variable=="Fiber")
                {
                    FinalPlot <- ggplot(DataPlot, aes(Fruit, Fiber, color = Category))   + geom_bar(fill="White", stat="identity") 
                    FinalPlot <- FinalPlot + ggtitle("Fiber Comparison")
                    FinalPlot <- FinalPlot + labs(x="Fruit",y="Fiber") 
                    FinalPlot <- FinalPlot + theme(panel.grid.major = element_line(colour = "white")) + theme_bw() + theme(legend.position="top")
                }
                else
                {
                    if (input$variable=="Completeness Score")
                    {
                        FinalPlot <- ggplot(DataPlot, aes(Fruit, Completeness_Score, color = Category))   + geom_bar(fill="White", stat="identity") 
                        FinalPlot <- FinalPlot + ggtitle("Completeness Score Comparison")
                        FinalPlot <- FinalPlot + labs(x="Fruit",y="Completeness Score") 
                        FinalPlot <- FinalPlot + theme(panel.grid.major = element_line(colour = "white")) + theme_bw() + theme(legend.position="top")
                    }
                    else
                    { 
                        if (input$variable=="Fullness Score" || input$variable=="Nutritious") {
                    
                            FinalPlot <- ggplot(DataPlot, aes(Fullness_Score, Nutritious, color=Category, label=Fruit))  + geom_point(stat="identity") 
                            FinalPlot <- FinalPlot + ggtitle("Nutritious vs Fullness Factor Comparison")  +geom_text(aes(label=Fruit),hjust=0, vjust=0)
                            FinalPlot <- FinalPlot + labs(x="Fullness Score",y="Nutritious") + scale_x_continuous(limits = c(0, 5)) + scale_y_continuous(limits = c(0, 5))
                            FinalPlot <- FinalPlot + theme(panel.grid.major = element_line(colour = "white")) + theme_bw() + theme(legend.position="top")
                            
                        }
                        else
                        {
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
        
})

