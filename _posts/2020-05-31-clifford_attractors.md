---
layout: post
title: Stumbling into the world of R-art
---

While preparing for a lab presentation a few weeks ago, I accidentally generated the following image:

<!--excerpt-->
![image](/assets/clifford_attractors/ggplot_death.png)


Although not what I intended, this frightening image helped me gain my 5 minutes of fame on [R Memes for Statistical Fiends](https://www.facebook.com/groups/241640089860882/) + some well-deserved roasting in the comments and got me wandering down the rabbit hole of R-art (apparently there are people who purposefully plot millions of points using ggplot with [stunning results](https://github.com/marcusvolz/mathart?utm_campaign=News&utm_medium=Community&utm_source=DataCamp.com)).

My goal was to generate a variety of Clifford attractors in hopes to eventually piece them together in some kind of mosaic fashion. It would make sense to use colors that already go well together, so I imported the [wesanderson palette package](https://github.com/karthik/wesanderson). 

Using the cppFunction provided [here](https://fronkonstin.com/2017/11/07/drawing-10-million-points-with-ggplot-clifford-attractors), I generated a separate clifford attractor image in the form of a *.png file for each color in each wes anderson palette.
```
rm(list=ls())
library(Rcpp)
library(ggplot2)
library(dplyr)
library("wesanderson")

## define plot opts
opt = theme(legend.position  = "none",
            panel.background = element_rect(fill="transparent"),
            plot.background = element_rect(fill = "transparent", color = NA), # a transparent background will help with laying the attractors over each other later
            axis.ticks       = element_blank(),
            panel.grid       = element_blank(),
            axis.title       = element_blank(),
            axis.text        = element_blank())
## see all palettes
all_wes<-names(wes_palettes)
#for (i in 1:length(all_wes)){
for (i in 1:1){
  wes_pal<-wes_palette(all_wes[i])
  for (j in 1:length(wes_pal)){
    a=-runif(1, min=1, max=2) # generate random number between 1 and 2
    b=-runif(1, min=1, max=2)
    c=-runif(1, min=1, max=2)
    d=-runif(1, min=1, max=2)

    df=createTrajectory(10000000, 0, 0, a, b, c, d)

    output_name=paste0(all_wes[i],'_',j,a,b,c,d,'.png')
    output_name=gsub("-","_",output_name)
    print(output_name)
    png(output_name, units="px", width=1600, height=1600, res=300,bg='transparent')
    print(ggplot(df, aes(x, y)) + geom_point(color=wes_pal[j], shape=46, alpha=.01) + opt)
    dev.off()
  }
}
```

The variables a,b,c, and d that are randomly generated will fall between -1 and -2 (this range was kind of chosen arbitrarily, it turns out you can use positive values as well. But I didn't test that here, because I later rely on the negative sign character ('-') preceding each variable for picking out specific parts of the filename that I want to manipulate later). 

I included the variables in the output file name so that in case a specific attractor image was particularly appealing, I would know what the input variables were and be able to reproduce it. Of course, I could have rounded off each value to fewer significant digits to make the filenames shorter, but I didn't think about that until just now.

When I examined the resulting plots, I saw that some were unsatisfactory - either it would appear that nothing had been drawn, or the images would only have a few lines. Since I noticed the unsatisfactory images were all under 1 MB in file size, I wrote the following loop to regenerate images that were below that size:

```
clifford_attractors_dir<-'/Users/elaine/R_art/clifford_attractors/wesanderson' #this is the folder where all the attractor images generated in the previous step are stored
suffix='iteration2.png' #to distinguish from the plots previously generated
for (i in 1:length(all_wes)){
  pal<-all_wes[i]
  wanted_files<-list.files(path = clifford_attractors_dir, pattern = paste0("^",pal), all.files = FALSE,
             full.names = TRUE, recursive = FALSE,
             ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
  small_files<-wanted_files[sapply(wanted_files,file.size)< 1000000] #get names of files below 1 MB
  if (length(small_files)>=1){
  for (j in 1:length(small_files)){
    a=-runif(1, min=1, max=2) # generate random number between 1 and 2
    b=-runif(1, min=1, max=2) # if you want to use positive numbers, need to modify the output_name code
    c=-runif(1, min=1, max=2)
    d=-runif(1, min=1, max=2)
    num=gsub(paste0(clifford_attractors_dir,'/',pal,'_'),'',small_files[j])%>%substr(1,1)%>%as.numeric() #get the number of the color on the wes palette
    df=createTrajectory(10000000, 0, 0, a, b, c, d)

      output_name=paste0(pal,'_',num,a,b,c,d,suffix)
      output_name=gsub("-","_",output_name)
      print(output_name)
      png(output_name, units="px", width=1600, height=1600, res=300,bg='transparent')
      print(ggplot(df, aes(x, y)) + geom_point(color=wes_palette(pal)[num], shape=46, alpha=.01) + opt)
      dev.off()
      file.remove(small_files[j]) #remove the small file containing the unsatisfactory clifford attractor
  }
}
}
```
I ran the loop above maybe 3 times until all the generated attractors were satisfactory (i.e. over 1 MB)

# Combining attractors
I thought importing each attractor *png into a photo editor and arranging them on a canvas would be too annoying, so I looked into some command line tools for automating the process. [imagemagick](https://imagemagick.org/) came to the rescue (I guess I could have combined the generated plots in Rstudio directly, but each plot took so long to load that I wanted to see if manipulating them as png files would be faster). 

But first, I wanted to deal with the terribly long and cumbersome filenames. First, I saved these long file names into a text file so that I would still have the information I wanted.

Below, I generate a "circle mosaic" for all Clifford attractors that belong to the same wesanderson palette (See "Calculated Positioning of Images" [here](http://www.imagemagick.org/Usage/layers/)). 

```
wes_pals="BottleRocket1 BottleRocket2 Rushmore1 Rushmore Royal1 Royal2 Zissou1 Darjeeling1 Darjeeling2 Chevalier1 FantasticFox1 Moonrise1 Moonrise2 Moonrise3 Cavalcanti1 GrandBudapest1 GrandBudapest2 IsleofDogs1 IsleofDogs2"
for pal in $wes_pals; do
    echo $pal
    convert_string=""
        for f in $pal*
        do
        convert_string+=$f
        convert_string+=','
        done
    clean_string=${convert_string%?} #remove the last comma
    echo $clean_string
    convert {$clean_string} -set page '+%[fx:1600*cos((t/n)*2*pi)]+%[fx:1600*sin((t/n)*2*pi)]' -background white -layers merge +repage $pal.white.bg.circle.png
done
```
Here are some of the resulting images: 

![image](/assets/clifford_attractors/Moonrise3.white.bg.circle.png)
<p align="center"><b> Moonrise3 </b></p>  
&nbsp;
&nbsp;
![image](/assets/clifford_attractors/IsleofDogs2.white.bg.circle.png)
<p align="center"><b> IsleofDogs2 </b></p>
&nbsp;
&nbsp;
![image](/assets/clifford_attractors/GrandBudapest2.white.bg.circle.png)
<p align="center"><b> GrandBudapest2 </b></p>
&nbsp;
&nbsp;
![image](/assets/clifford_attractors/FantasticFox1.white.bg.circle.png)
<p align="center"><b> FantasticFox1 </b></p>
&nbsp;
&nbsp;
![image](/assets/clifford_attractors/Darjeeling2.white.bg.circle.png)
<p align="center"><b> Darjeeling2 </b></p>
&nbsp;
&nbsp;

I plotted some palettes against a black background too, but since a lot of the palettes have dark colors, I couldn't do this for all of them: 

![image](/assets/clifford_attractors/Zissou1.circle.png)  
<p align="center"><b> Zissou1 </b></p>
&nbsp;
&nbsp;

![image](/assets/clifford_attractors/Royal2.circle.png)  
<p align="center"><b> Royal2 </b></p>
&nbsp;
&nbsp;

There were also a few unexpected outputs, seen below (probably because I had some extraneous files from previous test runs that the loop also picked up):

![image](/assets/clifford_attractors/Rushmore.white.bg.circle.png)  
<p align="center"><b> Rushmore </b></p>
&nbsp;
&nbsp;

![image](/assets/clifford_attractors/BottleRocket1.white.bg.circle.png)
<p align="center"><b> BottleRocket1 </b></p>
&nbsp;
&nbsp;
  
Obviously I've barely grazed the surface in understanding and exploring the capabilities of imagemagick and R-art, but that's all for now. Also, I should probably actually watch some of the Wes Anderson films. 
