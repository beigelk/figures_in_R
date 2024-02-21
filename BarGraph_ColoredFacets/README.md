\`\`\`{r setup, include=TRUE, message=FALSE, warning=FALSE}
knitr::opts_chunk\$set(echo = TRUE)

library(tidyverse) library(RColorBrewer) library(viridis) library(grid)
library(gtable) library(ggh4x) library(scales) library(ggpubr)



    # Define Plotting Function

    ```{r Function}

    ######################################################
    # Arguments for BarGraphColoredFacets(data_tbl, col_x_id, col_y_val, col_category)
      # data_tbl = dataframe
      # col_x_id = the name of the x-axis variable (discrete) in data_tbl
      # col_y_val = the name of the y-axis variable (continuous) in data_tbl
      # col_category = the name of the category variable (discrete) in data_tbl

    BarGraphColoredFacets = function(data_tbl, col_x_id, col_y_val, col_category){

      x_id = enquo(col_x_id)
      y_val = enquo(col_y_val)
      category = enquo(col_category)
      cat = as_label(category)
      
      colors = scales::viridis_pal(option = "viridis",
                                   begin = 0.2,
                                   end = 0.8,
                                   direction = -1)(length(unique(data_tbl[,cat])))
      
      plot = ggplot(data = data_tbl,
                    aes(x = !!x_id,
                        y = !!y_val,
                        fill = !!category)) +
        geom_bar(stat = "identity", position = 'dodge', width = 0.5) +
        theme_classic() +
          theme(
          axis.title.x = element_text(margin = margin(t = 10)),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          panel.spacing = unit(0.1, "lines"),
          panel.border = element_rect(fill = NA, colour = "gray", linewidth = 0.4),
          strip.text.x = element_text(angle = 0, size = 10, hjust = 0.5, margin = margin(0.2,0,0.5,0, "cm")),
          strip.background = element_rect(color = "gray", linewidth = 0.000001),
          strip.placement = "outside"
        ) +
        scale_fill_manual(values = colors) +
        facet_grid(formula(paste(category, collapse = " ")),
                   space = 'free_x', scales = 'free_x', switch = 'x') +
        scale_y_continuous(expand = c(0,0)) +
        scale_x_discrete(
          expand = expansion(add = c(1.2,1.2))) + # DO NOT REMOVE, adds "padding" in facets
        guides(fill = "none")
      
        q <- ggplotGrob(plot)
        
        for (i in 1:length(colors)){
          k = grep("strip-b", q$layout$name)[i]
          lg <- linesGrob(x=unit(c(0,1),"npc"), y=unit(c(0,0),"npc"),
                          gp=gpar(col=colors[i], lwd=20))
          q$grobs[[k]]$grobs[[1]]$children[[1]] <- lg
        }
        
        grid.draw(q)
        
    }

# Run function

## `iris` data

\`\`\`{r Run function on iris, warning=FALSE, fig.width=12}

# Run on the `iris` data set, modified to have an `id` column

iris_w_id = iris %\>% mutate(id = rownames(.))

# Run function

BarGraphColoredFacets(iris_w_id, id, Sepal.Length, Species)



    ## `mtcars` data

    ```{r Run function on mtcars, warning=FALSE, fig.width=12}

    # Run on the `iris` data set, modified to have an `id` column
    mtcars_w_id = mtcars %>%
      mutate(id = rownames(.)) %>%
      mutate(gear = factor(gear)) %>%
      mutate(carb = factor(carb)) 

    # Run function
    BarGraphColoredFacets(mtcars_w_id, id, mpg, gear)

    # Run function
    BarGraphColoredFacets(mtcars_w_id, id, mpg, carb)