# Repository for sharing code of the ASF Challange.  

## Some important dates: 
Our weekly meeting time is **Fridays 12 pm**  
  
  - First submission **October 8** *[Results](Results/Period_1/Results_P1.md)*.  
  - Second Submission **November 23** [Overview](https://ucdavis.box.com/s/otqb3qcvxcoyp30bpftnzzsp3wy8k557).  
  - Third submission **January 13**.  
  
## Directory structure
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

### Data:  

The data original data and the data processed for the model can be found in the shared box folder. The Data provided is on the folders *Data/Initialata* and *Data/Period_1*.  The processed data needed to run the model can be found on the folder *Data/includes*.  

  
### Some Links:  

  - [Shared Box Folder](https://ucdavis.box.com/s/c3smpi8zby3qgg70scl5uyq1swl9kxag)  
  - [ASF Challange website](https://www6.inrae.fr/asfchallenge/)  
  - [Zoom link for weekly meeting](https://ucdavis.zoom.us/j/92858469793?pwd=anRsZld0Y01uWWhUTDJSWWQxQXVFUT09)


### Note
Parts of this code use the `STNet` package written by Pablo. To install it:

```r
remotes::install_github("jpablo91/STNet")
```
