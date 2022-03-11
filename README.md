# Climate HAzard Toolbox (CHAT)

## Needs

Using and processing climate models can be challenging for non experts. Currently, many platforms exist to visualize important climate information. However, flexibility to generate outputs and perform ad hoc analysis is generally low. We intend to fill that gap by developing a product that allows more flexibility than exsiting tools but at the same time that is easy to use.

## Schematic representation of the four core functions that are being developed


The Hub is made of 4 main functions:

1. **load_data**: used to load CORDEX-CORE models of a region of interest. The whole year is loaded as dafault
2. **climate_change_signal**: used to visualize climate change signal and agreement in the sign of the climate change signal calculated as described by the IPCC
3. **proj**: used to visualize future projections. Bias-correction can be performed automatically as well as trend analysis
4. **hist**: used to visualize historical data (W5e5). Trend analysis can be performed

## climate_change_signal function 

This function allows the user to look at model agreement in the sign of the climate change signal (as defined by the IPCC) as well as the mean of climate change signal (average deviation from historical period) and standard deviation of the climate change signal (between models standard deviation). When precipitation is selected (var="pr), values refer to annual total precipitation while when temperature variables are selected ("tasmax" or "tasmin"), mean annual temperature is considered. When a threshold argument is specified, then climate change signal refers to number of days. For example, number of days in which precipitation was lower than 1 mm compared to baseline. This function has several arguments. 

`climate_change_signal(data, save, plot_name, season, lowert, uppert, int_month, palette)`

1. **save**: logical. Used to save or not the plots
2. **plot_name**: Character.Specify the name of the plot
3. **season**: numerical. Season of interest
4. **lowert**: numerical. Lower threshold
5. **uppert**: numerical. Upper threshold
6. **int_month**: Numerical. Automatic plotting by season. Can either take 6 or 3
7. **palette**: character. User specified color palette



![Kenya](https://user-images.githubusercontent.com/83447905/157858189-590c3fb9-87a8-4f3e-8443-8c27fb337125.png)
Mean and standard deviation of the climate change signal for dry days in Kenya (days with less than 1 mm of rain), January-March. The first plot indicates the overall difference in dry days (average of 6 CORDEX-CORE models) from historical period (1976-2005). The black dot indicates whether at least 60% of the models agree in the sign of the climate change signal (positive or negative). The second plot show the standard deviation in the climate change signal for dry days from 6 CORDEX-CORE models. Figure produced with the Climate HAzard toolbox (CHAT) developed at FAO (Climate Risks Team)


## proj function

This function is used to look at climate projections using an ensemble mean. It includes the option to bias-correct the data with the scaling method. If threshold are not specified, results are cumulative (in case of precipitation) or averages (in case of temperatures). The option trends allows the user to see the results of linear regression applied to yearly value for each pixel, time-frame and RCP. When both thresholds and trends are specified, linear regression is applied to the total number of days per season in which a certain threshold was or was not exceeded. 

`proj(data, save, plot_name, season, lowert, uppert, int_month, trends, palette, bias.correction)`

1. **save**: logical. Used to save or not the plots
2. **plot_name**: character. Specify the name of the plot
3. **season**: numerical. Season of interest
4. **lowert**: numerical. Lower threshold
5. **uppert**: numerical. Upper threshold
6. **int_month**: numerical. Automatic plotting by season. Can either take 6 or 3
7. **trends**: logical. Apply linear regression or not
8. **bias.correction**: logical
9. **palette**: character. User specified color palette


## hist function

The historical function visualizes data from the W5e5 dataset, which is an observational dataset giving highly accurate past climatic data information. Similar to the proj function the hist function allows the user to look at trends. 

`proj(data, save, plot_name, season, lowert, uppert, int_month, trends, palette)`

1. **save**: logical. Used to save or not the plots
2. **plot_name**: character. Specify the name of the plot
3. **season**: numerical. Season of interest
4. **lowert**: numerical. Lower threshold
5. **uppert**: numerical. Upper threshold
6. **int_month**: numerical. Automatic plotting by season. Can either take 6 or 3
7. **trends**: logical. Apply linear regression or not
8. **palette**: character. User specified color palette

