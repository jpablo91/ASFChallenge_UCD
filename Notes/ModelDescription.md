# Model Description
  
Our model can be described as a metapopulation-agent based model, where the agents are represented by cells in a hexagonal grid aggregating a population with specific characteristics such as: density, land cover, probability and direction of movements, among others. These characteristics make the agents to vary in some of the disease spread parameters allowing to account for the heterogeneity of the disease spread among a bigger population.  
Each of the agents in our model has two SIR models, one at the pig herd level and at the wild boars level. The *S* and *I* compartments represent the susceptible and infectious, and the change between these compartments happens at the rate $\beta_i$ which is computed for every agent. For the pig herds, the $\beta$ is calculated taking in consideration the pig density in the hexagonal cell and its affected by the control measures implemented. For the wild boars, the $\beta$ is computed based on the land cover characteristics, with the assumption that grids with higher forest cover will have a higher transmsission.
The compartment *R* is used  to represent the removed animals, which for the pig herds are the herds that have been detected and culled, and for the wild boars represent the animals that have been either hunted and detected, or found dead and tested positive. For the pig herds, the rate of change between the *I* to *R* compartment is computed based on the probability of detection which starts very low for all the cells, and once the first case has been detected it increases (assuming that after the first case being detected, the detection efforts will increase). 
  
  
## Parameters of the model  

A lot of these parameters are very specific to our model approach, *i.e. the local spread via wild boars considers the probability that in a given day there will a infected wild boar is going to move or infect another outside a 15 km range, which probably is very dependent on a lot of factors such as the habitat, season, etc..* . It will likely be difficult to find exactly what we are interested in but maybe if we find something close that we can use for provide extra support would be great.  
  

| Parameter                       | Current value | source | Notes |
| :------------------------------ | :------------ | :----- | :---- |
| $\beta$ for between herd spread | 0.5           | None   |       |
| $\beta$ for wild boars          | 0.05          | None   |       |
| Local spread via wild boars     | 0.3           | None   |       |
