

# Climate HAzard Toolbox (CHAT) ![g30445](https://user-images.githubusercontent.com/83447905/164390600-fb7c4fb0-28db-466c-89f7-51cc937b7f45.png)

## Table of contents[](##table-of-contents)
1. [Motivation](##Motivation)
   - [Working environment and milestones](##Working-environment-and-milestones)
2. [Schematic representation of the four core functions](##Schematic-representation-of-the-four-core-functions)
   - [Loading the data](###Loading-the-data)
   - [Climate change signal](###Climate-change-signal)
   - [Projections](###Projections)
   - [Historical](###Historical)
   - [Trends](###Trends)
3. [Detailed information](##Detailed-information)


## Motivation
Using and processing climate models can be challenging for non experts. Currently, there are many platforms that allow users to visualize climate data and climate models. However, these products do not usually offer much flexibility in terms of performing ad hoc analysis. We intend to fill that gap by developing CHAT (Climate HAzard Toolbox) that will allow users to access regionally downscaled climate models (CORDEX-CORE) as well as visualizing important climate related information in a more flexible way compared to traditional platforms.
Moreover, CHAT will focus on the automatic computation of informative statistics, such as time of emergence of the climate change signal.

At the moment, CHAT is accessible through the University of Cantabria IPCC atlas server and restricted to the risk team members of OCB division (FAO). However, we intend to release CHAT as a R shiny app in 2023. 

### Working environment and milestones
Currently, CHAT works through the IPCC atlas server, hosted by the University of Cantabria. CHAT can be seen as a wrapper of several packages but the main "engine" is the [climate4R framework](https://github.com/SantanderMetGroup/climate4R).  Input climate models are from CORDEX-CORE and CHAT can automatically access W5e5 bias-corrected reanalysis dataset. 
![CHAT](https://user-images.githubusercontent.com/83447905/172111749-1b08dc7b-2818-4896-bbd2-7031c24a69e4.png width=50% height=50%)

*Milestones for CHAT*


## Schematic representation of the four core functions 


The Hub is made of five main functions:

1. **load_data**: used to load CORDEX-CORE models of a region of interest. The whole year is loaded as dafault since the remaining functions allows to flexibily select a season
2. **hist**: used to visualize historical data (W5e5). Trend analysis can be performed
3. **proj**: used to visualize future projections. Bias-correction can be performed automatically as well as trend analysis
4. **climate_change_signal**: used to visualize climate change signal and agreement in the sign of the climate change signal calculated as described by the IPCC
5. **trends**: used to visualize trends for spatially aggregated data. 

More information about the CHAT performances can be downloaded [here](https://github.com/OCBteam/Climate-HAzard-Toolbox-CHAT-/blob/main/training/training.html) by pressing the download button.

### Loading the data

The load_data function allows the user to load data for a particular country or region of interest. Each plotting function will then used the output of load_data for plotting. Load_data loads 6 CORDEX-CORE models as well as W5e5 reanalysis dataset. 

`load_data(country, xlim, ylim, domain, var)`

### Climate change signal

This function allows the user to look at model agreement in the sign of the climate change signal (as defined by the IPCC) as well as the mean of climate change signal (average deviation from historical period) and standard deviation of the climate change signal (between models standard deviation). When precipitation is selected (var="pr), values refer to annual total precipitation while when temperature variables are selected ("tasmax" or "tasmin"), mean annual temperature is considered. When a threshold argument is specified, then climate change signal refers to number of days. For example, annual number of days in which precipitation was lower than 1 mm compared to baseline. This function has several arguments. 

`climate_change_signal(data, save, plot_name, season, lowert, uppert, int_month, palette, consecutive, duration, prov.country)`

1. **save**: logical. Used to save or not the plots
2. **plot_name**: Character.Specify the name of the plot
3. **season**: numerical. Season of interest
4. **lowert**: numerical. Lower threshold
5. **uppert**: numerical. Upper threshold
6. **int_month**: Numerical. Automatic plotting by season. Can either take 6 or 3
7. **palette**: character. User specified color palette
8. **consecutive**: logical. Whether consecutive days should be considered. To be used on conjunction with uppert/lowert and duration
9. **duration**: charachter. When "max", maximum duration of consecutive days above/below a certain threshold is calculated. When "total", total number of days with at least 6 consecutive days, above/below a certain threshold
10. **prov.country**: charachter. Country for visualization of provinces

Below an example of the climate_change_signal function:

![Kenya](https://user-images.githubusercontent.com/83447905/157858189-590c3fb9-87a8-4f3e-8443-8c27fb337125.png)
*Mean and standard deviation of the climate change signal for precipitation in Kenya, January-March. The first plot indicates the overall difference in total annual precipitation (average of 6 CORDEX-CORE models) from historical period (1976-2005). The black dot indicates whether at least 60% of the models agree in the sign of the climate change signal (positive or negative). The second plot shows the standard deviation in the climate change signal calculated from the 6 CORDEX-CORE models. Figure produced with the Climate HAzard toolbox (CHAT) developed at FAO (Climate risk team)*


### Projections

This function is used to look at climate projections using an ensemble mean. It includes the option to bias-correct the data with the scaling method. If threshold are not specified, results are cumulative (in case of precipitation) or averages (in case of temperatures). The option trends allows the user to see the results of linear regression applied to yearly value for each pixel, time-frame and RCP. When both thresholds and trends are specified, linear regression is applied to the total number of days per season in which a certain threshold was or was not exceeded. 

`proj(data, save, plot_name, season, lowert, uppert, int_month, trends, palette, bias.correction, prov.country, consecutive, duration)`

1. **save**: logical. Used to save or not the plots
2. **plot_name**: character. Specify the name of the plot
3. **season**: numerical. Season of interest
4. **lowert**: numerical. Lower threshold
5. **uppert**: numerical. Upper threshold
6. **int_month**: numerical. Automatic plotting by season. Can either take 6 or 3
7. **trends**: logical. Apply linear regression or not
8. **bias.correction**: logical
9. **palette**: character. User specified color palette
10. **method**: character. Method to be used for bias correction. Default is scaling
11. **consecutive**: logical. Whether consecutive days should be considered. To be used on conjunction with uppert/lowert and duration
12. **duration**: charachter. When "max", maximum duration of consecutive days above/below a certain threshold is calculated. When "total", total number of days with at least 6 consecutive days, above/below a certain threshold
13. **prov.country**: charachter. Country for visualization of provinces


### Historical

The historical function visualizes data from the W5e5 dataset, which is an observational dataset giving highly accurate past climatic data information. Similar to the proj function the hist function allows the user to look at trends. 

`proj(data, save, plot_name, season, lowert, uppert, int_month, trends, palette, prov.country, duration, consecutive)`

1. **save**: logical. Used to save or not the plots
2. **plot_name**: character. Specify the name of the plot
3. **season**: numerical. Season of interest
4. **lowert**: numerical. Lower threshold
5. **uppert**: numerical. Upper threshold
6. **int_month**: numerical. Automatic plotting by season. Can either take 6 or 3
7. **trends**: logical. Apply linear regression or not
8. **palette**: character. User specified color palette
9.  **consecutive**: logical. Whether consecutive days should be considered. To be used on conjunction with uppert/lowert and duration
10. **duration**: charachter. When "max", maximum duration of consecutive days above/below a certain threshold is calculated. When "total", total number of days with at least 6 consecutive days, above/below a certain threshold
11. **prov.country**: charachter. Country for visualization of provinces

### Trends

The trends function allows the visualization of linear trends for spatially aggregated data. 

`proj(data, save, plot_name, season, lowert, uppert, int_month, trends, palette, consecutive, duration)`

1. **save**: logical. Used to save or not the plots
2. **plot_name**: character. Specify the name of the plot
3. **season**: numerical. Season of interest
4. **lowert**: numerical. Lower threshold
5. **uppert**: numerical. Upper threshold
6. **int_month**: numerical. Automatic plotting by season. Can either take 6 or 3
7. **bias.correction**: logical
8. **y.range**: numeric vector. User specified y axsis
9. **method**: method to use in bias correction. Default is scaling
10.  **consecutive**: logical. Whether consecutive days should be considered. To be used on conjunction with uppert/lowert and duration
11. **duration**: charachter. When "max", maximum duration of consecutive days above/below a certain threshold is calculated. When "total", total number of days with at least 6 consecutive days, above/below a certain threshold



![Kenya_trends_bias 1-2-3](https://user-images.githubusercontent.com/83447905/161943534-a86086c4-4578-4f27-9dfa-bf44f8d399ec.png)
*Yearly increase in total precipitation in Kenya, January-March after bias correction. The regression line is fitted based on the ensemble mean of 6 CORDEX-CORE models while shading represents the between models standard deviation. Figure produced with the Climate HAzard toolbox (CHAT) developed at FAO (Climate Risk Team)*

## Detailed information

A more detailed description of the functions being developed can be found [here](https://github.com/OCBteam/Climate-HAzard-Toolbox-CHAT-/blob/main/training/training.html). Press the download button and open the html file. 

