
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