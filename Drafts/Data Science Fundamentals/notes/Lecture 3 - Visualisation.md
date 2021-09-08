# Lecture 3 - Visualisation

# IMPORTANT

- every exam has a critique the graph kind of question , see supllementary slides on thise

# Summary

**Know**:
what the grammar of graphics is: dataset, stat, scale, mapping, coord, geom, guide, layer, facet, figure,
caption
how elements of the grammar of graphics appear in a visualisation
how to produce a correct, simple, scientific chart from numerical data
the basic operation of matplotlib
basic plot types: line plots, bar charts, scatter plots
different ways of representing data in 2D plots
the use of stats to transform data, including binning, summarisation and smoothing
linear, log and polar coordinate systems and their uses
the use of point, line and area geoms to represent data and standard aesthetic mappings for them
appropriate aesthetic mappings for colour information
how to criticise scientific visualisations
how to represent uncertainty accurately in a plot

**Do**:
Make graphs that are:
  Conceptually correct: data is represented visually in a way that makes sense.
  Technically correct: details of data representation are complete and accurate.
  Aesthetically correct: data is represented a visually pleasing way.
Have the language and concepts to discuss, criticise and improve visual representations.

# Intro

- Visualisation encodes abstract mathematical objects into a form that humans can draw meaning from
  - build intuition about relationships and structure in data
  - summarise large quantities of data

- this lecture will focus on precision, clarity and accuracy in visualisation

![](@attachment/Clipboard_2021-07-26-18-13-46.png)

## Basic Categories

- three basic categories we'll focus
  - plots of single 1D array (e.g. histograms)
  - plots of pairs of 2D arrays (e.g. scatterplots)
  - plots of single 2D arrays (e.g. contour plots)

# Grammar of Graphics

- the creation of scientific visualisation can be precisely specified in terms of a *graphical language*
  - specifies how to turn data into images (construction)
  - how readers should interpret those images (interpretation)

- **Layered Grammar of Graphics** (Hadley Wickham) is a way of describing the language used
  - **Stat** : a statistic computed from data which is mapped onto visual features with the aim of summarising the data compactly
  - **Mapping** : represents a transformation of data columns to visual values using a scale to give units to the attribute
    - **Scale** : specifies the transformation of the units in the dataset/stat to visual units (e.g. temperature to colour)
    - **Guide** : visual reference which indicates the semantics of the mapping (e.g. axis ticks)
  - **Geom** : geometric representation of data after it has been mapped (e.g. points, lines)
  - **Coord** : coordinate system which connects mapped data onto points on the plane (e.g. conversion of units in the data to pixels)
  - **Layer** : one set of geoms, with one mapping on one coordinate system (multiple layers may be overlaid on a single coordinate system)
  - **Facet** : a different view of the same dataset, on a separate coordinate system
  - **Figure** : a set of one or more facets
  - **Caption** 

![](@attachment/Clipboard_2021-07-26-18-25-33.png)

# Anatomy of a Figure

## Figure

- Many figures are single graphs (single facets) but may include multiple facets
  - every figure needs a clear caption

## Plots : guides, geoms and coords

![](@attachment/Clipboard_2021-07-26-18-37-56.png)

- **guides**
  - axes : guides for the coordinate system 
    - must include units and ticks for subdivisions of those units
  - legend : guides for the layers
    - explains the meaning of the markers and lines
  - title

- **geoms**
  - lines/curves : represent continuous functions 
  - markers : representing discontinued points
  - patches : representing shapes with area

# 2D Plots

## Dependent and Independent Variables

- $y = f(x)$
- we may want to plot the relation between the variables described by $f$
- the input are a pair of 1D vectors **x,y**
  - **independent variable** (the "cause") is plotted in the x-axis
  - **dependent variable** (the "effect") is plotted in the y-axis

## Common types of plots

### Scatterplot

- plot marks $(x,y)$ locations of measurements with *markers*

![](@attachment/Clipboard_2021-07-26-18-51-30.png)

### Bar Chart

- draws bars (*patches*) with height proportional to $y$ at $x$

![](@attachment/Clipboard_2021-07-26-18-51-40.png)

### Line Plot

- draws connected *line* segments between $(x,y)$ positions in the order that they are provided

![](@attachment/Clipboard_2021-07-26-18-51-51.png)

### Ribbon Plot

- for each $x$ there's an upper and lower bound for the $y$s which is graphed

![](@attachment/Clipboard_2021-07-26-18-58-33.png)

## Layering geoms

- a common practice is to plot explicit points at which measurements are available
  - this will require two *layers* (line geom + marker geom) which share the same *coords*

![](@attachment/Clipboard_2021-07-26-18-54-38.png)

- another application of ribbons is to represent uncertainty in measures

![](@attachment/Clipboard_2021-07-26-18-59-02.png)

- line geoms are used to show the trend of the data
- points geoms for notating the actual measurements
- area geoms to represent measured uncertainty

# Plotting data well

- our dataset

```
[[ 1. 4.2 0. 0.5]
[ 2. 11.5 0. 0.5]
[ 3. 7.3 0. 0.5]
[ 4. 5.8 0. 0.5]
[ 5. 6.4 0. 0.5]
[ 6. 10. 0. 0.5]
[ 7. 11.2 0. 0.5]
[ 8. 11.2 0. 0.5]
[ 9. 5.2 0. 0.5]
[10. 7. 0. 0.5]]
```

## How NOT to plot

![](@attachment/Clipboard_2021-07-26-19-02-24.png)

## How to plot

![](@attachment/Clipboard_2021-07-26-19-03-11.png)
![](@attachment/Clipboard_2021-07-26-19-03-17.png)

![](@attachment/cleanup.gif)

### Units

- if an axes represent real world units (dimensional quantities) they should always be specified in the axis labels
- the scales should be appropriate to the data (e.g time - measurements taken in seconds -> seconds not e.g. months)
- if the quantities are dimensionless (bare numbers) then units can be omitted but the axes clearly labelled
- avoid automatic scaling of labels, instead scale them manually and insert the scaling in the axis label

### Axes and coordinate transform

- the axis specifies the scaling and offset of data - a coordinate system or 
  - the limits should be appropriate to the data
  - a common bad practice is to use axes that don't span the full scale to make differences look larger than they actually are

### Layered vs faceted

- sometimes to make the data clearer to see it might be better to separate data into different subplots (facets) instead of overlaying it

![](@attachment/Clipboard_2021-07-26-19-34-14.png)

## Study Case

> A visualisation must communicate meaning to a reader. A visualisation is not defined by a dataset -- some
visualisation types are good for certain kinds of dataset and worse for others, but the visualisation choice comes
down to what the purpose of the visualisation is. It's often helpful to think of the caption that you would want to
be able to write before creating the visualisation

- we see the trend and we mark gas usage at specific points in time

![](@attachment/Clipboard_2021-07-26-19-35-23.png)

- here we focus on the yearly trend
  - remove the markers 
  - smooth the curve to remove seasonal effect

![](@attachment/Clipboard_2021-07-26-19-36-24.png)

- here we focus on each season separately
  - use multiple geoms and layers

![](@attachment/Clipboard_2021-07-26-19-36-29.png)

- faceted version of the above

![](@attachment/Clipboard_2021-07-26-19-36-35.png)

- bin things by season
- remove time
- show distribution

![](@attachment/Clipboard_2021-07-26-19-36-44.png)

- here another stat, mean and range

![](@attachment/Clipboard_2021-07-26-19-36-55.png)

- remove time
- apply median stat for each year
- plot min vs max

![](@attachment/Clipboard_2021-07-26-19-37-01.png)

# Stats

- statistics summarise data 
  - aggregate summary statistics : measures of central tendency and deviation
  - binning operations : categorise data into a number of discrete bins and count the data points falling into those bins
  - smoothing and regression : find approximating functions to datasets 

- plots of 1D arrays usually involve displaying stats to transform the dataset into forms that 2D plotting forms can be applied to
  - these plot types are used with multiple arrays (with the data grouped in some way) to show differences between groups

## Binning

- histograms approximate distributions
  - depends heavily on the type of bins chosen

- too granular, difficult to see the overall shape of the distribution
![](@attachment/Clipboard_2021-07-26-19-48-26.png)

- too coarse, difficult to see the overall shape of the distribution, because too many ranges have been collapsed into one
![](@attachment/Clipboard_2021-07-26-19-48-32.png)

- 2D
  - note that as the number of bins is quadratic in the number of subdivision in the axis, which makes it hard to fill if not enough data points

![](@attachment/Clipboard_2021-07-26-19-49-55.png)

## Ranking

- sorted data

![](@attachment/Clipboard_2021-07-26-19-53-04.png)

## Aggregate Summaries

- common statistical transform is to represent ranges of data using either the minimum/maximum, the standard deviation, or the interquartile range

![](@attachment/Clipboard_2021-07-26-19-54-26.png)

### Box plot

- represents a bunch of aggregate summaries in a single geom

![](@attachment/Clipboard_2021-07-26-19-55-18.png)

### Violin plot

- extension of the box plot where the full distribution is also plotted

![](@attachment/Clipboard_2021-07-26-19-58-07.png)

## Regression and smoothing

- find a function which approximates the data
  - e.g. linear regression
  - important for proposing hypotheses which might explain the data

![](@attachment/Clipboard_2021-07-26-19-59-54.png)

- smoothing attempts to present a simplified version of the data
  - a bit like performing linear regressions to windows (ranges) of the data 

# Geoms

- don't go crazy with the marker shapes
- w.r.t colours
  - take colour blindness into account
  - consider using sufficiently different shades which are still distinguishable in B&W
  - colour maps map a continuous variable to a colour, and the colour bar representing the possible mappings should be included
    - (see lecture notes for dos and don'ts)

- markers' attributes other than their position can be used to represent other dimensions of the data
  - e.g. size,colour can be used to represent magnitude,temperature etc.

![](@attachment/Clipboard_2021-07-26-20-07-03.png)

- lines should be used if it makes sense to ask what is between two data points (continuous)
  - don't go crazy with style

- when dealing with multiple layers we can try and differentiate overlapping geoms by playing with opacity
  - note how we can see by the darker shade that there are more points in those areas, if opacity was 100% we would only see a point
- opacity can also be used to emphasise specific geoms

![](@attachment/Clipboard_2021-07-26-20-17-53.png)

![](@attachment/Clipboard_2021-07-26-20-19-19.png)

# Coords

- aspect ratio should be preserved

![](@attachment/Clipboard_2021-07-26-20-20-12.png)

- there projections other than linear Cartesian coordinates
- **log scales** 
  - allow us to plot data with very large spans of magnitude
    - this prevents the data from lower ranges to be collapsed by the sheer scale of the axis required to include the higher ranges of teh data
  - it also works well to visualise polynomial relationships between functions as a straight line
  - downside - can't handle negative numbers (there are modified log scales which can)

![](@attachment/Clipboard_2021-07-26-20-21-58.png)

![](@attachment/Clipboard_2021-07-26-20-25-07.png)

- **polar**
  - widely used for data that originated from an angular measurement
  - it can also be used when it makes sense for one of the axes to "wrap around" smoothly (e.g. wind data - direction, speed)

  ![](@attachment/Clipboard_2021-07-26-20-29-03.png)

# Facets and Layers

![](@attachment/Clipboard_2021-07-26-20-29-25.png)

## Layering

- two or more views on a dataset are closely related and the data mapping are in the same units
- legends are essential to distinguish between the different layers

![](@attachment/Clipboard_2021-07-26-20-30-53.png)

## Facets

- for case where layers are not appropriate, you should split them into different facets each with their own coords
  - if plotting the same variable in different facets you should use the same scale 

![](@attachment/Clipboard_2021-07-26-20-32-22.png)

![](@attachment/Clipboard_2021-07-26-20-33-18.png)

# Uncertainty

- errors in measurements should be represented visually
  - error bars : s.d , s.e, confidence intervals, nonparametric intervals (IQ ranges)

![](@attachment/Clipboard_2021-07-26-20-34-27.png)

## Box plots

- as discussed above, presents a lot of these stats as a single geom

![](@attachment/Clipboard_2021-07-26-20-36-16.png)
