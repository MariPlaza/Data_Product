#The file ui.R defines the commands to the user interface of the application. Below it is the detail of each element in the user interface. 

#Step 0: Load required libraries. 
library(shiny)


# This application serves to compare nutritional comparison among common fruits. 

# There are 4 inputs and 3 outputs that are managed through the user interface to provide the described functionality. 

shinyUI(pageWithSidebar(
    
    # Application title
    headerPanel(
        "Nutritional comparison among common fruits"
        
    ),
    
    # Defines the text and inputs in the left side panel of the UI. 
    
    sidebarPanel(
    
        #Define the basic documentation of the application. 
        
        h4("Instructions:"), 
        h6("Please select the portion, the criteria and the fruits that you want to compare. Your would get a Winner, a graph and a table with the relevant data for the comparison among the fruits according to the selected criterias."),
        h6("Each criteria of suggestion has below a detailed link for better understanding. This app would help you to compare common fruits according to these criterias. Enjoy!"),
        
        #This represents the first input. It is the portion to compare. Base on the selection, the dataset used for the analysis changed. 
        #The default value is 100 grams. 
        
        selectInput("dataset", "Portion to compare:", 
                    choices = c("100 Grams", "Standard Portion")), 
        
        #This represents the second input. It defines the criteria that is going to be used to cpmpare a fruit with the others. 
        #The default value is Calories. 
        
        selectInput("variable", "Criteria of Suggestion:",
                    list("Calories", "Fiber", "Completeness Score", "Fullness Score", 
                         "Nutritious", "% Carb", "% Fat", "% Prot"),"Calories"),
        
        #This represents the third input. It defines the main fruit that is going to be compared with the other. 
        #The default value is all.
        
        selectInput("Fruit1", "Fruit 1:",
                    list("all","Apple", "Banana", "Pineapple", "Pear", 
                         "Strawberry", "Tangerine", "Orange", "Kiwi", "Watermelon", "Melon"), "all"),
        
        #This represents the fourth input. It defines the other fruits that are going to be compared with the main fruit. 
        #The default value is all.
        
        selectInput("Fruit2", "Fruit 2:",
                    list("all","Apple", "Banana", "Pineapple", "Pear", 
                         "Strawberry", "Tangerine", "Orange", "Kiwi", "Watermelon", "Melon"), "all") ,
        
        #This section provides useful resources to understand the concepts behind the criterias of comparison. 
        
        h6("Data Source:", a("Nutrition Data Self", href="http://nutritiondata.self.com/")), 
        h6("Application detailed Documentation on:", a("Mari Plaza's Github", href="https://github.com/MariPlaza/Data_Product/blob/master/App%20Documentation.md")), 
        h5(""), 
        h5(""), 
        h5(""), 
        h4("Available measures for comparison:"), 
        h6("There are several criterias to evaluate a food nutritionaly speaking. Normally except for calories, when there are more of the criteria the fruit is considered better"),
        h6(a("Calories", href="https://en.wikipedia.org/wiki/Calorie_restriction")),
        h6(a("Fiber", href="https://en.wikipedia.org/wiki/Dietary_fiber")),
        h6(a("Completeness Score", href="http://nutritiondata.self.com/help/nutrient-balance-indicator")),
        h6(a("Fullness Score", href="http://nutritiondata.self.com/topics/fullness-factor")),
        h6(a("Nutritional Target Map", href="http://nutritiondata.self.com/help/analysis-help#target-map"),"representing Nutrition Data Rating/Nutritious against FF"),
        h6(a("Caloric Radio Pyramid", href="http://nutritiondata.self.com/help/analysis-help#cp-pyramid"), "representing % Carb, % Prot and % Fat")
    ),
    
    # This element format the outputs panel at the right. 
    
    mainPanel(
        
        #It presents the caption with the result of the comparison. 
        h4(textOutput("caption")),
        
        #It represents the second output with the graphs according to the criteria selected. 
        plotOutput("Plot", height = 350, width = 700),
        
        #It presents a table with all the details of the selected fruits. This table is ranked according the criteria selected. 
        h6(tableOutput("view"))
    )
))