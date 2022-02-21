# simple functions to return models with the same time-frane
common_dates <- function(data) {
  # list of models
  dates.all = c()
  
  for (imodel in 1:length(data)) {
    dates.all = c(dates.all, substr(data[[imodel]]$Dates$start, 1, 10))
  }
  
  dates.common = substr(data[[1]]$Dates$start, 1, 10)
  for (imodel in 2:length(data)) {
    aux = intersect(substr(data[[imodel - 1]]$Dates$start, 1, 10),
                    substr(data[[imodel]]$Dates$start, 1, 10))
    dates.common = intersect(dates.common, aux)
  }
  for (imodel in 1:length(data)) {
    ind = which(!is.na(match(
      substr(data[[imodel]]$Dates$start, 1, 10), dates.common
    )))
    data[[imodel]] = subsetDimension(data[[imodel]], dimension = "time", indices = ind)
  }
  
  return(bindGrid(data, dimension = "member"))
  
}


# functions for model agreement, based on IPCC

find.agreement = function(x, threshold){
  #calculate proportion of models predicting each sign of change (negative(-1), no change(0), positive(+1))
  sign.proportion = c(length(x[x<0])/length(x), length(x[x==0])/length(x), length(x[x>0])/length(x))
  names(sign.proportion) = c(-1,0,1)
  #compare the set threshold to the maximum proportion of models agreeing on any one sign of change
  #if the max proportion is higher than threshold, return 1 (meaning there is agreement in signs among model)
  #otherwise return 0 (no agreement meeting the set threshold)
  if(max(sign.proportion) > threshold){
    return(1)
  } else{
    return(0)
  }
}

agreement= function(array3d, threshold) {
  array1_agreement = apply(array3d, c(2,3), find.agreement, threshold )
}

# make a raster from a cl4 object when data is a 2d array
make_raster <- function(cl4.object) {
  if (length(dim(cl4.object$Data)) != 2)
    stop("Your data needs to be a 2d array, check dimension")
  
  rasters <- raster(
    cl4.object$Data,
    xmn = min(cl4.object$xyCoords$x),
    xmx = max(cl4.object$xyCoords$x),
    ymn = min(cl4.object$xyCoords$y),
    ymx = max(cl4.object$xyCoords$y)
  ) %>%
    flip(., direction = 'y')
  
  nms <-
    paste0(
      str_extract(cl4.object$Dates$start[1], "\\d{4}"),
      "_",
      str_extract(cl4.object$Dates$start[length(cl4.object$Dates$start)],  "\\d{4}")
    )
  names(rasters) <-  nms
  
  crs(rasters) <- CRS("+init=epsg:4326")
  
  return(rasters)
  
}

# function to invert order fo color in leaflet (https://github.com/rstudio/leaflet/issues/256#issuecomment-440290201)
addLegend_decreasing <-
  function (map,
            position = c("topright", "bottomright", "bottomleft", "topleft"),
            pal,
            values,
            na.label = "NA",
            bins = 7,
            colors,
            opacity = 0.5,
            labels = NULL,
            labFormat = labelFormat(),
            title = NULL,
            className = "info legend",
            layerId = NULL,
            group = NULL,
            data = getMapData(map),
            decreasing = FALSE) {
    position <- match.arg(position)
    type <- "unknown"
    na.color <- NULL
    extra <- NULL
    if (!missing(pal)) {
      if (!missing(colors))
        stop("You must provide either 'pal' or 'colors' (not both)")
      if (missing(title) && inherits(values, "formula"))
        title <- deparse(values[[2]])
      values <- evalFormula(values, data)
      type <- attr(pal, "colorType", exact = TRUE)
      args <- attr(pal, "colorArgs", exact = TRUE)
      na.color <- args$na.color
      if (!is.null(na.color) &&
          col2rgb(na.color, alpha = TRUE)[[4]] ==
          0) {
        na.color <- NULL
      }
      if (type != "numeric" && !missing(bins))
        warning("'bins' is ignored because the palette type is not numeric")
      if (type == "numeric") {
        cuts <- if (length(bins) == 1)
          pretty(values, bins)
        else
          bins
        if (length(bins) > 2)
          if (!all(abs(diff(bins, differences = 2)) <=
                   sqrt(.Machine$double.eps)))
            stop("The vector of breaks 'bins' must be equally spaced")
        n <- length(cuts)
        r <- range(values, na.rm = TRUE)
        cuts <- cuts[cuts >= r[1] & cuts <= r[2]]
        n <- length(cuts)
        p <- (cuts - r[1]) / (r[2] - r[1])
        extra <- list(p_1 = p[1], p_n = p[n])
        p <- c("", paste0(100 * p, "%"), "")
        if (decreasing == TRUE) {
          colors <- pal(rev(c(r[1], cuts, r[2])))
          labels <- rev(labFormat(type = "numeric", cuts))
        } else{
          colors <- pal(c(r[1], cuts, r[2]))
          labels <- rev(labFormat(type = "numeric", cuts))
        }
        colors <- paste(colors, p, sep = " ", collapse = ", ")
      }
      else if (type == "bin") {
        cuts <- args$bins
        n <- length(cuts)
        mids <- (cuts[-1] + cuts[-n]) / 2
        if (decreasing == TRUE) {
          colors <- pal(rev(mids))
          labels <- rev(labFormat(type = "bin", cuts))
        } else{
          colors <- pal(mids)
          labels <- labFormat(type = "bin", cuts)
        }
      }
      else if (type == "quantile") {
        p <- args$probs
        n <- length(p)
        cuts <- quantile(values, probs = p, na.rm = TRUE)
        mids <-
          quantile(values, probs = (p[-1] + p[-n]) / 2, na.rm = TRUE)
        if (decreasing == TRUE) {
          colors <- pal(rev(mids))
          labels <- rev(labFormat(type = "quantile", cuts, p))
        } else{
          colors <- pal(mids)
          labels <- labFormat(type = "quantile", cuts, p)
        }
      }
      else if (type == "factor") {
        v <- sort(unique(na.omit(values)))
        colors <- pal(v)
        labels <- labFormat(type = "factor", v)
        if (decreasing == TRUE) {
          colors <- pal(rev(v))
          labels <- rev(labFormat(type = "factor", v))
        } else{
          colors <- pal(v)
          labels <- labFormat(type = "factor", v)
        }
      }
      else
        stop("Palette function not supported")
      if (!any(is.na(values)))
        na.color <- NULL
    }
    else {
      if (length(colors) != length(labels))
        stop("'colors' and 'labels' must be of the same length")
    }
    legend <-
      list(
        colors = I(unname(colors)),
        labels = I(unname(labels)),
        na_color = na.color,
        na_label = na.label,
        opacity = opacity,
        position = position,
        type = type,
        title = title,
        extra = extra,
        layerId = layerId,
        className = className,
        group = group
      )
    invokeMethod(map, data, "addLegend", legend)
  }


