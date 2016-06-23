#ShinyApp for data EDA
Input a dataframe, output a scatterplot with option to select color, size, shape, and smooth method.
After clicking the 'Facet' button, right panel will show a scatterplot, stratified by `group variable`.
You can also use brush function to drag and select points on the plot. After clicking the 'DONE' button, it will return the subset data output at bottom (left panel), and the brushed points (subset data) will output on the right panel, while the linear model summary (`lm`) using subset data will be printed at bottom (right panel).

If you are happy with the seleted data, can click 'Download' button, and the subset data will be saved into a CSV file (right click `Download` can select the path).
