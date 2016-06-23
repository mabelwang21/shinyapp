#ShinyApp for data EDA

### 1. ShinyApp_EDA_FACET_brush.R
Input a dataframe, output a scatterplot with option to select color, size, shape, and smooth method.
After clicking the 'Facet' button, right panel will show a scatterplot, stratified by `group variable`.
You can also use brush function to drag and select points on the plot. After clicking the 'DONE' button, it will return the subset data output at bottom (left panel), and the brushed points (subset data) will output on the right panel, while the linear model summary (`lm`) using subset data will be printed at bottom (right panel).

If you are happy with the seleted data, can click 'Download' button, and the subset data will be saved into a CSV file (right click `Download` can select the path).

### 2. ShinyApp_interaction2.R
Similar to the app above, but no `brush` function. It's made for visulize model with two continuous variable interactions.
Slider bar can be used to set value for the `moderator`, and as the value changes, the lm line on the scatter plot will also change. Bottom left outputs the model using `lm(Y~ X+moderator+X:moderator).
Bottom right outputs the predicted `Y` value based on the selected `X` variable and `moderator` value. 
