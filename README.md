#ShinyApp for data EDA
#Input a dataframe, output a scatterplot with option to select color, size, shape, and smooth method
#after click 'Facet' button, right panel will show scatterplot, stratified by 'group variable'
#can use brush function, after drag and select, click 'DONE' button will return the subset data output in DT::datatable at bottom left
#brushed points (subset data) will output on the right panel and bottom right is the linear model summary (lm()) using subset data
#click 'Download' button, subset data will be saved into a CSV file
#default will save to your 'Download folder', right click 'Download' can select path
