# Model results for first period (Oct 8, 2020)

### Team:

-   Jose Pablo Gomez.
-   Nistara Randawa.
-   Kathleen O'Hara.
-   Jerome Baron
-   Olivia Cords

## Model description

We use a mechanistic stochastic agent based model. We aggregate the population characteristics in a 15 km diameter hexagonal grid and we use these characteristics to describe the local and long-distance disease spread dynamics. The local disease spread is represented by the disease transmission within each hexagonal cell, where each cell has its own SIR model for both the estimated wild boar population and the pig herds. The two populations interact based on the characteristics of the farms and the density of animals within a hexagonal cell.\
For the long-distance disease spread dynamics we use the land characteristics and estimated wild boar population density to represent the transmission between contiguous cells, and the movement patterns to represent the transmission between longer distances. This modeling approach allows us to account for the spatial heterogeneity in the transmission dynamics with the assumption that the population characteristics within each hexagonal cell are homogeneous.

We illustrate the effectiveness of the interventions based on 6 different scenarios:

Baseline scenario includes:\
Fence has been active for 20 days so far. Also the increased hunting pressure has been implemented in the fenced area and 15km outside the fenced area.

-   i - Fencing

-   ii - Hunting pressure

-   iii - Awareness

-   I - Culling of PH in protection zones (3km).

-   II - Culling of PH \< 3 km from detected WB.

-   III - Increasing size of surveillance zone (10 to 15 km during 30 days).

-   IV - Culling of herds that traded with infected farms \< 3 weeks before detection

-   V - Increase the size of active search area around infected wild boar carcasses found outside the fenced/buffer areas (from 1km to 2 km). (NOT EXPLORED)

| Scenario | i   | ii  | iii | I   | II  | III | IV  | V   |
|:---------|:----|:----|:----|:----|:----|:----|:----|:----|
| S00      | Y   | N   | Y   | N   | N   | N   | N   | N   |
| S01      | Y   | Y   | Y   | N   | N   | N   | N   | N   |
| S02      | Y   | Y   | Y   | Y   | N   | N   | N   | N   |
| S03      | Y   | Y   | Y   | N   | Y   | N   | N   | N   |
| S04      | Y   | Y   | Y   | N   | N   | Y   | N   | N   |
| S05      | Y   | Y   | Y   | N   | N   | N   | Y   | N   |
| S06      | Y   | Y   | Y   | N   | N   | N   | N   | Y   |

Each Scenario was run 100 times and we obtained the median and IQR from the Number of infected farms for the next 45 days.

## Model Results:

### Number and location of the predicted outbreaks for the next time period.



### Effectiveness of fencing

The following plot shows the distribution of the epidemic peak for the 5 scenarios.

![](fig_box-plots_all-scenarios.png)

### Conclusion

Scenario 2 is the best, followed by scenario 4.

Reduction in cases for each comparison of scenarios made:  
  
  - 0 vs 1: 0.05081344  
  - 0 vs 2: 0.2317381  
  - 0 vs 3: 0.06009295  
  - 0 vs 4: 0.2182275  
  - 0 vs 5: 0.07294262  
  
# Apendix: DataDoc
We provide 2 raw data files:  
  
  - **SDF.csv**: contains each time step of the model for all the 4 scenarios with the variables:  
    - cycle: The time step of the model.  
    - Infected_P: The number of infected pig herds.  
    - Infected_WB: The number of infected wild boars.  
    - Sim: Iteration of the scenario.  
    - Scenario: The corresponding scenario for that run.  
    
  - **AgentsDF.csv**: Contains all the agents for the 4 scenarios ran, each agent (row) is a hexagonal grid cell with the variables:  
    - idhex: a id given to the hexagonal cell.  
    - Epidemic: Indicates the number of times that cell had a epidemic in the model ran.  
    - introduction_ph: Number of times the disease transmission source was a long distance movement.  
    - introduction_wb: Number of times the transmission source of the pig herds was from the wild boars.  
    - Scenario: The corresponding scenario for that agent.  
