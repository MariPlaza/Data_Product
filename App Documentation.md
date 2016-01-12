# FRUIT COMPARISON APPLICATION
## MOTIVATION OF THE APPLICATION
I am passionate about Nutrition and data. Nowadays there is too much information and advice about nutrition, nonetheless, it is very difficult to make a proper decision because there is not enough tools to provide comparisons


## USAGE OF THE APPLICATION
The application provides 4 inputs or variables that the user (aka you) could give: 

|Input Name   |  Description  | 
|---|---|
|Portion to compare|The standard is compare foods based on the content of 100 grams, but nonetheless, when we eat fruits we eat a pear, a banana or an apple, normally each one have different standard weights. The app provides you with the opportunity to compare based on 100 grams or standard portion|
|Criteria of Suggestion|It defines which nutritional criteria is going to be used to provide a suggestion. Detailed links are provided directly in the application to understand the concepts behind each criteria|
|Fruit 1|It defines the main fruit to be compared with the fruit(s) selected on the Fruit 2 variable|
|Fruit 2 |It represents the fruit(s) for comparison|


## RESULTS
There are 3 results of the application with change depending on the variables provided. The results are: 

#### Suggestion or Winner  

It provides a text with the suggestion according to the selected inputs or variables. Generally speaking when there is more of the selected nutritional criteria is considered better, except for calories, that the criteria is less calories per portion is better. 

|Fruit 1 Variable | Fruit 2 Variable  | Type of Comparison according to the selected nutritional criteria |
|---|---|---|
|All| All |The app returns the best fruit among all|
|Specific| All |The app returns the best fruit among all and ranked Fruit 1|
|All| Specific |The app returns the best fruit among all and ranked Fruit 2|
|Specific| Specific  |The app returns the winner between these two fruits|
|Specific| Specific (Same as Fruit 1)  | The app just presents information but not suggestions because there is not a comparison to make|


#### Graph

It shows a comparison graph based on the variables selected. 
|Variable   | Type of Graph  | Axis and Variables |
|---|---|---|
|Calories| Bar Graph |Fruit (X-Axis) and Calories (Y-Axis)|
|Fiber| Bar Graph |Fruit (X-Axis) and Fiber (Y-Axis)|
|Completeness Score| Bar Graph |Fruit (X-Axis) and Completeness Score (Y-Axis)|
|Fullness Factor or Nutritious| Scatter Plot  |Fullness Factor (X-Axis), Nutritious (Y-Axis) and Fruit (Points)|
|% Carb, % Prot or % Fat| Triangle Plot |% Carb (Left side), % Protein (Basis), % Fat (Right side)  and Fruit (Points)|


#### Table

It provides the whole information for the selected fruits. 

## TECHNICAL DOCUMENTATION
If you are interested in the technical documentation of the application and how the code works please refer directly to each code document. The comments are next to each code line. 
