library(shiny)
# Define UI APP

# This application serves to compare nutritional comparison among common fruits. 
shinyUI(pageWithSidebar(
    
    # Application title
    headerPanel(
        "Nutritional comparison among common fruits"
        
    ),
    sidebarPanel(
        selectInput("dataset", "Portion to compare:", 
                    choices = c("100 Grams", "Standard Portion")), 
        selectInput("variable", "Criteria of Suggestion:",
                    list("Calories", "Fiber", "Completeness Score", "Fullness Score", 
                         "Nutritious", "% Carb", "% Fat", "% Prot"),"Calories"),
        selectInput("Fruit1", "Fruit 1:",
                    list("all","Apple", "Banana", "Pineapple", "Pear", 
                         "Strawberry", "Tangerine", "Orange", "Kiwi", "Watermelon", "Melon"), "all"),
        selectInput("Fruit2", "Fruit 2:",
                    list("all","Apple", "Banana", "Pineapple", "Pear", 
                         "Strawberry", "Tangerine", "Orange", "Kiwi", "Watermelon", "Melon"), "all") ,
        h5("Data Source:", a("Nutrition Data Self", href="http://nutritiondata.self.com/")), 
        h5("Application Documentation on:", a("Mari Plaza's Github", href="https://github.com/MariPlaza/Data_Product")), 
        h5(""), 
        h5(""), 
        h5(""), 
        h3("Available measures for comparison:"), 
        h6("There are several criterias to evaluate a food nutritionaly speaking. Normally except for calories, when there are more of the criteria the fruit is considered better"),
        h6("This app would help you to compare common fruits according to these criterias. Enjoy!:"),
        h6(a("Calories", href="https://en.wikipedia.org/wiki/Calorie_restriction")),
        h6(a("Fiber", href="https://en.wikipedia.org/wiki/Dietary_fiber")),
        h6(a("Completeness Score", href="http://nutritiondata.self.com/help/nutrient-balance-indicator")),
        h6(a("Fullness Score", href="http://nutritiondata.self.com/topics/fullness-factor")),
        h6(a("Nutritional Target Map", href="http://nutritiondata.self.com/help/analysis-help#target-map"),"representing Nutrition Data Rating/Nutritious against FF"),
        h6(a("Caloric Radio Pyramid", href="http://nutritiondata.self.com/help/analysis-help#cp-pyramid"), "representing % Carb, % Prot and % Fat")
    ),
    mainPanel(
        h4(textOutput("caption")),
        plotOutput("Plot", height = 350, width = 700),
        h6(tableOutput("view"))
    )
))