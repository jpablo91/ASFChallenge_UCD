# Model results for second period (Jan 13, 2021)

### Team:

-   Jose Pablo Gomez.
-   Nistara Randawa.
-   Jerome Baron

## Model description

### Model description.

We use a mechanistic stochastic agent based model. We aggregate the population characteristics in a 5 km diameter hexagonal grid and we use these characteristics to describe the local and long-distance disease spread dynamics. The local disease spread is represented by the disease transmission within each hexagonal cell, where each cell has its own SIR model for both the estimated wild boar population and the pig herds. The two populations interact based on the characteristics of the farms and the density of animals within a hexagonal cell.\
For the long-distance disease spread dynamics we use the land characteristics and estimated wild boar population density to represent the transmission between contiguous cells, and the movement patterns to represent the transmission between longer distances. This modeling approach allows us to account for the spatial heterogeneity in the transmission dynamics with the assumption that the population characteristics within each hexagonal cell are homogeneous.

### Scenario Modeling.

We compare the effect of hunting pressure in two scenarios where:
  
  - S00 No hunting pressure.  
  - S01 Hunting pressure.  
  

## Model Results:

### Number and location of the predicted outbreaks for the next time period.

### Baseline scenario

![](fig_S0_infected-animals.png)

### Hunting pressure scenario

![](fig_S1_infected-animals.png)


#### Reduction of number reintroductions.


### Conclusion


# Apendix: DataDoc

We provide 2 raw data files:

-   **SDF.csv**: contains each time step of the model for all the 6 scenarios with the variables:

    -   cycle: The time step of the model.\
    -   Infected\_P: The number of infected pig herds.\
    -   Infected\_WB: The number of infected wild boars.\
    -   Sim: Iteration of the scenario.\
    -   Scenario: The corresponding scenario for that run.

-   **AgentsDF.csv**: Contains all the agents for the 6 scenarios ran, each agent (row) is a hexagonal grid cell with the variables:

    -   idhex: a id given to the hexagonal cell.\
    -   Epidemic: Indicates the number of times that cell had a epidemic in the model ran.\
    -   introduction\_ph: Number of times the disease transmission source was a long distance movement.\
    -   introduction\_wb: Number of times the transmission source of the pig herds was from the wild boars.\
    -   Scenario: The corresponding scenario for that agent.