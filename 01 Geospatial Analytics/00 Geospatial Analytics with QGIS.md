
# Geospatial Analytics with QGIS

In this part of the course, you will learn the basics of working with the freely available geographic information system QGIS. These course-related worksheets are intended to guide you through the individual exercises ("learning by doing"). The course slides include a basic introduction to geospatial information systems, their application, mapping, and various tools in QGIS ("Learning by Studying"). For your learning success, it is recommended to use both documents!

The following task sheets were deliberately written in detail to make it easier for you to do some follow-up work at home.

The following four exercise units contain different learning objectives (Some tasks are inspired by the exercises of the course "Logistiknetzwerke" by Dr. Maximilian Lukesch.):
- In **Task 1**, you create a map that shows the distribution of the population in the USA. You will learn how to read and edit data, format layers, and create maps.
- In **Task 2.1**, you create a map of Regensburg on which the Aldi branches are marked and in which you draw a circular route. You will learn a simple form of geocoding, creating point shapefiles, formatting points and lines, measuring distances, and creating line shapefiles.
- **Task 2.2** builds on the material from Task 2.1. They analyze the market reach of the Regensburg Aldi branches. Here you will learn how to use different geo tools (buffer, intersection, dissolve), how to prepare attribute tables and how to calculate new attributes.
- In **Task 3**, you examine a fictitious distribution network in Bavaria. You will learn various analysis methods relevant to logistics, including the generation of centroids, distance matrices and Voronoi polygons, as well as the mapping and formatting of goods flows.

A few hints should be given for your further work with QGIS:
- QGIS is a powerful program – an introductory course only gives you a jump-start. Exploiting the possibilities of QGIS depends on your personal efforts in understanding and using the program.
- Search for freely available data and discover the potential of QGIS!
- The QGIS community is very active: you can almost always find an answer to your question by searching the web.
- QGIS has many plugins: There may be a plugin that can help you with your specific problem! If in doubt, google your problem in English.

## Task 1: North America

### Problem
In the first exercise, you will create a professional and complete map of the United States, showing the population distribution of each state. On the one hand, you should format the states according to color intensity, and on the other hand, mark the three most populous states with a red border. In addition, the states should be provided with their respective state abbreviation.

Use the following data for this:
- Path: Exercise 1
    - States.shp
    - States_demog.dbf

### Walkthrough
- Copy the data set to your personal drive. Make a note of the storage path. Open QGIS.
- Load the above data into QGIS.
- Change the coordinate reference system of the project  and the states layer to EPSG:4269.

![Alt text](image.png)
![Alt text](image-1.png)

- **TIP**: If you lose sight of a specific layer, you can right-click on the layer and select the "Zoom to layer" option.
- Link the states layer to the .dbf:
    - Right-click "states", properties, shortcuts, add shortcut (green plus). Link layers -> select the database here. Link field and target field are "STATE_FIPS". Select only "POP2004" as the linked field.
    - If you now check the layer's attribute table (right-click -> Open attribute table), you will see that a new column has been added.
- In the following we have to do two separate formatting tasks. Once using a gradient, once using a border. It makes sense to create two separate shapefiles for this. In the following, we therefore separate a shape called "States" and a shape called "Largest States".
    - Right click on States layer -> Save as.
    - Select the "Browse" field for "File name" and call up the storage path on your drive. Select "Large States" as the file name.
    - Rename the other layer to "States" (right click on layer -> Rename).
    - You now have two shapefiles that currently have the same content.
- First, let's "clip" the "Largest States" layer. It should only include the three largest states:
    - Right click on Layer -> Open attribute table
    - Sort the states in descending order of population (click on the column header).
    - Select the top three objects (hold down CTRL) and select the Invert Object Selection option.
    - Click on the "Turn on editing mode" button (small pencil). Then click "Delete Selected Items" (trash can). Exit edit mode by clicking the small pen again. Save the changes.

![Alt text](image-2.png)

- Make sure the "Most Populous States" layer is on top of the "States" layer in your Layers win-dow. Otherwise, drag and drop it up. Format it as a transparent layer with a thick red border:
    - Right click on Layer -> Properties -> Style.
    - Click on "Simple filling" in the upper window, then on the color bar below under Symbol layer type / Filling. In the "Choose fill color" window that appears, lower the "Opacity" slider to 0%, then confirm.
    - Further down in the window you can format the frame. Change the border color to red and increase the border strength to 1.5. Click "Apply" and then "Ok".
- Next, the States layer is formatted:
    - Right click on Layer -> Properties -> Style.
    - At the top, choose Graduated instead of Single Icon.
    - For "Column" select "POP_2004". Then select a color gradient that suits you under "Color gradient".
    - Under Mode (below the table window), select the entry "Nice Interruptions". Under "Clas-ses" on the right, select 7 classes. Click "Classify" – each object has now been assigned a color based on its population. If you click on "Apply" below, you can already see the effect in the map window.
    - Finally, the states have to be labeled. In the properties window, click on "Labeling" and select "Label this layer" from the top menu.
    - Under "Label with" you can specify which attribute should be used for the label. Select "STATE_ABBR" and click "Apply" to test it.
    - Format the caption however you like: The menu below gives you several options. One possibility would be to add a buffer to make the state names easier to read. A shad-ow would also be possible.

![Alt text](image-3.png)
![Alt text](image-4.png)

- Now all layers are ready for map creation. You can start creating a map. To do this, click on "Project" in the menu bar, then on "New Print Composer". For the name, select "Population distribution in the USA". The Print Composer opens (i.e., the map editor) from QGIS in a new window.
    - Add a card title (menu bar -> Arrangement -> Add label) and place it in the middle. In the right window under "Element properties" change the content of the caption to "Population distribution in the USA (2004)". Below you can format the title. Center the title and in-crease its font size (Font button) to 24 and set it to bold.
        - **Orientation**: On the right side you will find the "Elements" pane. Here you will find all the individual parts that you have added to the map. You can also navigate here – by clicking on a single element, it becomes editable. You can change it in the "Element properties" window below.
        - **Tip**: You can delete elements by selecting the "Select/move entry" button, then clicking on the element and selecting "Edit" from the menu bar and then "Delete".
    - Next, add the map (Menu bar -> Arrangement -> Add map). Drag the map window to the width of the workspace. Leave space below for sources. You can change the size afterwards by dragging the edge of the object.
    - Move the content of the map up a little (menu bar -> arrangement -> move content, then move the content up within the map). You can switch off the "Move content" function again by clicking on the "Select/move entry" symbol on the left edge of the screen and on a Color area.
    - Add a small map window that you place below the large map on the left. In this small map window, the New England states on the east coast should be displayed a little larger.
        - This new map is the "Map 1" item in the "Items" panel. Select it, click "Move Con-tent" (menu bar, layout) and zoom in (CTRL + mouse wheel) on the east coast. Then add a border to the little card under Element Properties.
        - It should be shown where the small map section is in the large map. In the elements window, click on "Map 0" and select the "Overviews" tab at the bottom of the ele-ment properties. Insert a new overview using the plus sign and select "Map 1" as the map frame. Under "Border Style" you can increase the transparency of the red box to 90%.
        - The small section of the map must also be labeled. Add a new caption ("Cutout: New England") and format it appropriately under Element Properties.
    - The map needs a legend. It can also be added via "Order". Place them in the lower right corner. Under Element Properties under Legend Elements click on "Update automatically" and remove the database "states_demog" by selecting it and clicking on the minus at the bottom. Then click on "States" and on the edit function below (small pencil) and rename the item "Population".
    - Next, add a scale via "Arrange". Play around with the formatting options under Element Properties. Try to create appropriate scale bar formatting. Add a scale bar to the small map as well – click on the small map under "Elements" and add the scale bar via "Arrangement".
    - Finally, the map needs a north arrow. Select the "Add picture" function via "Arrangement" and open a small frame. Under "Element properties" open the "Browse directories" tab – select a discreet north arrow.
    - Finally, we must indicate the sources used. To do this, create a label field again and add the source reference "Source: Data from the University of Regensburg".
- You can export your map via the menu bar under "Composition" (e.g., as a PDF or as a PNG via "Save as raster image").

![Alt text](image-6.png)
![Alt text](image-7.png)
![Alt text](image-8.png)
![Alt text](image-9.png)
![Alt text](image-10.png)
![Alt text](image-11.png)
![Alt text](image-12.png)
![Alt text](image-13.png)

### Solution
![Alt text](image-14.png)

