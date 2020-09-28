# Repository for sharing code of the ASF Challange.  

Hi all, I updated the repo, there are 3 main files:  
  
  - [Data processing for the period_1](Code/R/Period_1.Rmd): Here I do some processing of the data to obtain te formats required for the model and see some of the distribution of cases.  
  - [Processing of the simulation outputs](Code/R/SimsOut.Rmd): In this one I create the figures for the current model.  
  - [Current model](Code/GAMA_ASF/ASF/models/ASF1_2.gaml): This is the gama code for the model.  
  
Make sure to put the get the data from the shared box folder and put it in the correct directories if you want to run the code.  

## Some important dates: 
  
  - First submission **October 8**.  
  - Second Submission **November 23**.  
  - Third submission **January 13**.  
  
## Weekly meeting

Our weekly meeting time is **Fridays 12 pm**  
  
  
### Data:  

The data original data and the data processed for the model can be found in the shared box folder. The Data provided is on the folders *Data/Initialata* and *Data/Period_1*.  The processed data needed to run the model can be found on the folder *Data/includes*.  
  
  
### Some Links:  

  - [Shared Box Folder](https://ucdavis.box.com/s/c3smpi8zby3qgg70scl5uyq1swl9kxag)  
  - [ASF Challange website](https://www6.inrae.fr/asfchallenge/)  
  - [Zoom link for weekly meeting](https://ucdavis.zoom.us/j/92858469793?pwd=anRsZld0Y01uWWhUTDJSWWQxQXVFUT09)


### Directory structure
	|
    |- Data: symlink with [Shared Box Folder](https://ucdavis.box.com/s/c3smpi8zby3qgg70scl5uyq1swl9kxag)  
	|
    |- Code: code for manuscript
	|   |
	|   |- R: for R, Rmd, and associated files
	|   |
	|   |- GAMA_ASF: for GAMA code (javascript syntax highlighting helps locally)
	|
	|- Figures: generated figures, maps, etc
	|
	|- Report: notes and results for sharing

### Note
Parts of this code use the `STNet` package written by Pablo. To install it:

```r
remotes::install_github("jpablo91/STNet")
```
