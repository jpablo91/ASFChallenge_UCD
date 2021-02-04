---
output:
  pdf_document: default
  html_document: default
---
Questions from organizer:

  - *When you say that you have taken into account the movement pattern, can you confirm to me that it corresponds to pig shipments ? Or have you modeled wild boar mobility?*  
  **We have considered movements from the previous period to calculate the probability of movement between two grid cells i.e. if $Grid_i$ made 5 movements to $Grid_j$ in 30 days, the probability of $Grid_i$ moving to $Grid_j$ in any given day of the next period would be 5/30 = 0.16.**  
  **For wild boar movements we are not explicitly modeling the wild boar movements, the way we do it is that there is a probability that on any given day an infected wild boar will move from one hexagonal grid to other, but we don't do this for susceptible wild boars.**  
  
  - *How have you predicted the pig shipments for the predicted period ? Was it the same list for each simulation (accounting for movement restrictions, so there may be few differences) or did it change at lot?*  
  **The probabilities of movement between $Grid_i$ to $Grid_j$ are calculated for every period with the movement data provided, so it changes as the movement records change. For movement restrictions, during the simulation the grid with movement restrictions are defined, i.e. if $Farm_i$ get infected at cycle 40 of the simulation, the movement restriction is applied at cycle 41.**
  
  - *Have you modeled the spread of the disease inside farms or does your model only accounts for the presence/absence of the disease inside a farm ? Can we know the total number of infected pigs at a time step ?*  
  **We only model the disease spread between farms. In our model, once an animal of a farm is infected, the whole farm is considered as infected.**
  
  - *I am not sure to understand if/how you have taken into account a processus of detection of cases. Can you explain it to me please ? In particular :*
    - *How have you implemented the increased awareness in a given hexagonal cell ? Was it for pig farms and wild boars ?*  
    **The increased awareness increases the rate at which the animals move from the compartments $I \rightarrow R$, each hexagonal cell has its own rate for wild boars and for pig herds**
    - *Why have you made the choice of a constant number of infected WB when active surveillance is stopped ? Can’t this number vary independently of surveillance ?*  
    **In out model there is no active surveillance explicitly, the surveillance is only represented through the awareness**
    
  - *Would it be possible with your model to provide us the id of possible infected farms with a probability of infection or not ? We may ask you to do so in the future.*  
  **Yes, we can define this assuming that all the farms within a hexagonal grid have the same probabilities of infection**  
  
  - *When you present the « probability that a given hexagonal grid will present a outbreak » do you include both wild boars and pig farms ?*  
  **No, we only modeled the probabilities of infection for pig farms**  
  - *Can you give me the equation system for pig farm infection and wild boar infection please ? Has it changes during the Challenge?*  
  **Find below the model equation, for the period 1 and 2 we did not considered mortality, for the period 3 we added mortality to differentiate the animals that died because of infection and removal vs the ones that were culled and removed**  
  
![](Figures/Model.png){width="450"}  


|Parameter                               |Symbol|
|----------------------------------------|-------|
| Susceptible                            |$S_i$|
| Infected                               |$I_i$|
| Removed                                | $R_i$|
| Transmission rate                      |$\beta_{i}$|
| Removal rate                           |$\gamma_i$|
| Mortality                              |   $\mu_i$|
|Probability of wild boar-domestic spread|$delta$|


$$\frac{\delta S_{i}}{\delta t} = -\beta_{i} S_{i} I_{i}/N - \mu S_{i}$$
$$\frac{\delta I_{i}}{\delta t} = \beta_{i} S_{i} I_{i} - \gamma_{i} I_{i} - \mu I_{i}$$
$$\frac{\delta R_{i}}{\delta t} = \gamma_{i} I_{i} - \mu R_{i}$$
    
  - *Can a pig infect a wild boar ?*  
  **No, in our model transmission only goes from wild boar to pig herds**  
  
  - *The R compartment of your SIR model took into account culled and hunted animals for all periods or was it just implemented in the last scenario ?*  
  **This only happens in the second and third period**
  
  - *If your dead WB are included in the R compartment, I understand that the population is stable. Nevertheless, can you tell me if these animals are taken into account for WB density in the processes of disease transmission or are they fully removed ?*  
  **WB density is constant regardless the removed wild boars, so we dont account for changes in the disease transmission rates influenced by the removal of animals**  
  - *For the first period I don’t see how you can conclude on the effect of fencing alone (and with the addition of hunting pressure) considering that the barrier is only added in your third scenario (in addition with hunting). Are fencing and hunting inverted in the sentence ?*  
  **Yes you are right we inverted the interventions in the sentence, thanks for noticing that**  
  - *Have you dissociated the 2 measures ? And so, would you be able to conclude on the effect of fencing alone, increased hunting alone and the effect of both ?*  
  **We defined scenarios where there is only hunting pressure and hunting pressure + fencing, we could also do scenarios where there is fencing alone but didn't do it for the submissions.**  
  - *When you have decided to change your spatial resolution from 15 km to 5km : was it because of the new questions we have asked you, or was it a change you were willing to make by your own ?*  
  **We changed the resolution to implement more easiliy the new added interventions (instead of defining areas at 3 km radius we assume it's 5 km) **  
  - *In the second period you have added rates for mortality. Is it to say that culling of pig herds and hunting were not taken into account in the first period ?*  
  **Culling was taken into account but the culled animals were pooled into the R compartment**  
  - *In the second and third periods, when you say in scenario 00 that there is no hunting pressure : have you still modeled a « classic » hunting season with 50 % of wild boars killed at the end of the season and 20 % of them tested, or not at all ?*  
  **No, we did not really considered the hunting season at all**  
  - *For this second period, when you add an increased hunting pressure: is it inside the fence and the 15km buffer zone ? What is the percentage of wild boar killed and how many of them are tested?*  
  **The hunting pressure happens only inside the fence and we do not really model the testing of animals**  
  
  - *For the third scenario, have taken into account that :*  
    - *since day 90 we have implemented a total culling in farms located at less than 3km of WB that are found positive (either carcasses or shot wild boar)? It seams that maybe you have used a 5km radius instead.*  
    **Yes, we used the 5km radius instead to consider this**  
    - *On day 120 the hunting pressure goes back to normal?*  
    **No, we maintained it **  
    - *On day 170 it is the end of the hunting season?*  
    **We did not considered the hunting season at all**  
  - *Why have you chosen to wait for 60 days before repopulation of culled farms? During the kick of meeting we talked about a duration of 50 days but maybe we were unclear in further communication.*  
  **Sorry, our team member that attended this meeting left the challenge and we did not know about this.**  
  - *When you implement a fence, is it always 100 % efficient?*  
  **No the fence only reduces the rate at which an infected boar can move between grids in a  but not reduces it to 0**  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
