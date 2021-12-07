#ShinyApp for data EDA

### 1. ShinyApp_EDA_FACET_brush.R
Input a dataframe, output a scatterplot with option to select color, size, shape, and smooth method.
After clicking the `Facet` button, right panel will show a scatterplot, stratified by `group variable`.
You can also use brush function to drag and select points on the plot. After clicking the `DONE` button, it will return the subset data output at bottom (left panel), and the brushed points (subset data) will output on the right panel, while the linear model summary (`lm`) using subset data will be printed at bottom (right panel).

If you are happy with the seleted data, can click 'Download' button, and the subset data will be saved into a CSV file (right click `Download` can select the path).

### 2. ShinyApp_interaction2.R
Similar to the app above, but no `brush` function. It's made for visulize model with two continuous variable interactions.
Slider bar can be used to set value for the `moderator`, and as the value changes, the lm line on the scatter plot will also change. Bottom left outputs the model using `lm(Y~ X+moderator+X:moderator)`.
Bottom right outputs the predicted Y value based on the selected X variable and moderator value. 

### 3. dbGap_phenotype_summary.R
I created a ShinyApp to explore the combined and decoded dbGaP phenotype files. It outputs count table for each cancer of selection, group_by the selected variable(s). It also generated a simple violin plot with selected X, Y, and color variable.  First select a phenotype data from drop-box, next, select Group variable (e.g. status, consent, etc), you can select multiple variables here.  Once these information are fed in, it will generated a summary table on the right-hand side, showing the number of subjects in each of the stratified group. Notice that the data and total number of subjects in that file are output at the top of the table. 

+ You do have option to generate simple violin plot as well. First select X (prefer a categorical variable),  Y (prefer a continuous) variable of interest, and can also add a color variable (prefer a categorical variable), once you click  the “Plot” button, it will generate a violin plot at the bottom right.
