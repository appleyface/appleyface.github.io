---
layout: post
title: Daffodil Days
---

A random fragment of a dream from last night made its way into reality. 
<!--excerpt-->
I woke up in the middle of the night being able to recall the context of the dream, but when morning arrived all I could remember was the phrase "Daffodil Days" and the fact that it came from a song. 

A quick search on Apple Music linked me to three different artists with a song of that name; the only one I really liked was by a British guy, [Oscar Scheller](https://open.spotify.com/track/0hODhMkkmkHKzhPX6qMiew).

[![Daffodil](/assets/daffodil_days/youtube.png)](https://www.youtube.com/watch?v=_wprtDXS3mA "Oscar - Daffodil Days")

I also remembered another layer of the dream: I was walking along water at twilight, the sky a gradient of blue and red (a touch too vibrant). There was snow on the ground but I didn't feel cold and I was on the phone with a person whose long-term significance in my life has yet to be determined (but then again, that label applies to almost everyone if we're being flexible with the term "long-term significance"). Sky full of stars--so it's possible I'm now misremembering stars for snowflakes, or maybe both were there. 

Anyway, I made some hackey attempts to re-create that scene using imagemagick but since I don't have the attention-span to read things properly, there are probably better ways than my illogical methods cobbled below (with help from various imagemagick website pages [\[1\]](http://www.imagemagick.org/Usage/color_mods/#clut)  [\[2\]](http://www.imagemagick.org/Usage/advanced/#stars). 

**Starting image:**
I took this sunset photo at Santa Monica beach when a friend visited in March.   

<img src="/assets/daffodil_days/sunset.jpeg" width="500">


**Make the colors more intense:**

    convert sunset.jpeg -sigmoidal-contrast 10,50% test_sigmoidal.png  

<img src="/assets/daffodil_days/test_sigmoidal.png" width="500">

**Adjust hue:**

    convert test_sigmoidal.png -modulate 100,100,70.6 mod_hue_70_sigmoid.jpeg  

<img src="/assets/daffodil_days/mod_hue_70.6_sigmoid.jpeg" width="500">

**Add blue tint:**

    convert mod_hue_70.6_sigmoid.jpeg -fill blue -tint 20 tint_blue.png  

<img src="/assets/daffodil_days/tint_blue.png" width="500">

**Generate a star field:**  

    convert -size 3000x3000 xc: +noise Random -channel R -threshold 1%           -negate -channel RG -separate +channel           \( +clone \) -compose multiply -flatten           -virtual-pixel tile -blur 0x.4 -contrast-stretch .8%           stars.gif  

<img src="/assets/daffodil_days/stars.gif" width="500">

**Make star field image slightly transparent:**

    convert stars.gif -alpha set -background none -channel A -evaluate multiply 0.5 +channel result.png  

<img src="/assets/daffodil_days/result.png" width="500">

**Combine images:**

    convert tint_blue.png result.png -layers flatten flatten.png 

<img src="/assets/daffodil_days/flatten.png" width="500">

**Generate tree image with the help of the [mathart](https://github.com/marcusvolz/mathart?utm_campaign=News&utm_medium=Community&utm_source=DataCamp.com) R package** 

    library(mathart)
    library(ggart)
    library(ggforce)
    library(Rcpp)
    library(tidyverse)
    
    
    # Generate rrt edges
    set.seed(1)
    df <- rapidly_exploring_random_tree() %>% mutate(id = 1:nrow(.))
    
    ## define plot opts
    opt = theme(legend.position  = "none",
                panel.background = element_rect(fill="transparent"),
                plot.background = element_rect(fill = "transparent", color = NA), # a transparent background will help with laying the attractors over each other later
                axis.ticks       = element_blank(),
                panel.grid       = element_blank(),
                axis.title       = element_blank(),
                axis.text        = element_blank())
    
    # Make the lines of the tree thicker
    df$x<-df$xend+30
    df$y<-df$yend+30
    
    # Create plot
    p <- ggplot() +
      geom_segment(aes(x, y, xend = xend, yend = yend, size = -id, alpha = -id), df, lineend = "round") +
      coord_equal() +
      scale_size_continuous(range = c(0.1, 0.75)) +
      scale_alpha_continuous(range = c(0.1, 1)) +opt
    

    
    # Save plot
    ggsave("rapidly_exploring_random_tree_thick.png", p, width = 20, height = 20, units = "cm",bg='transparent')

<img src="/assets/daffodil_days/rapidly_exploring_random_tree_thick.png" width="500">

**GIMP:**  

I imported the images as separate layers in GIMP (cropped the star field layer, duplicated/rotated/moved around the trees, drew trunks, etc.). This is what I ended on:

![image](/assets/daffodil_days/final_composite_image.png)

It's rough and unpolished and terrible but a fun exercise in trying to recreate an image from a dream (blurring the lines between what was imagined and what is now actuality, albeit horrendously rendered). 

