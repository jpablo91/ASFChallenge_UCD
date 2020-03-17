# Repository for sharing code of the ASF Challange.  

Hi all, I am uploading a description of the model, which you can find in [THIS LINK](Code/Model_Explanation.html).  
The last meeting we talked about what can we do to parametrize our model, one of the things we talked is to use a model that can handle well the zero inflation of our data. There is very few cases compared to the hexagons without cases. We can use the data found in the shared folder *Shapefiles/FarmsHx.shp* to try to find some association between the variables and the number of cases and inform better our simulation model.  
I put the data in a shared box folder, which everyone should be able to access. There are two shapefiles in the *shapefile* directory:  
  
  - *FarmsHx.shp* which is the hexagons with farms with the data from all the other data sets agregated.  
  - *MapHx.shp* Which is the full area with the data aggregated at hexagonal grid.  

The code that explains how I did this can be found under [CreateHx.md](Code/CreateHx.md) file.  

### Code:  

  - [Distribution of the variables](Code/DataExploration.md)  
  - [Create the Hexagonal grids](Code/CreateHx.md)


  
### Some Links:  

  - [Shared Box Folder](https://ucdavis.box.com/s/c3smpi8zby3qgg70scl5uyq1swl9kxag)  
  - [ASF Challange website](https://www6.inrae.fr/asfchallenge/)