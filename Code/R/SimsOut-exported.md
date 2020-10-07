Setting up the workplace
========================

Read in data for various scenarios
==================================

-   Scenario 0: Baseline
-   Scenario 01: Movement restrictions
-   Scenario 02: Movement restrictions and hunting pressure
-   Scenario 03: Movement restrictions, hunting pressure and fencing

### Variables from the 'EC' folder:

-   *cycle:* time step of the simulation.  
-   *Infected\_P:* Number of infected pig herds.  
-   *Infected\_WB:* Number of infected wild Boars.  
-   *Sim:* Iteration of the simulation.

<br><br>

Plot of infected domestic pigs and wild boars over time
=======================================================

### Scenario 0: Baseline

![](/Users/nistara/projects/side/2020_ASFChallenge_UCD/Code/R/SimsOut-exported_files/figure-markdown_strict/unnamed-chunk-3-1.png)

### Scenario 01: Movement restrictions

![](/Users/nistara/projects/side/2020_ASFChallenge_UCD/Code/R/SimsOut-exported_files/figure-markdown_strict/unnamed-chunk-4-1.png)

### Scenario 02: Movement restrictions and hunting pressure

![](/Users/nistara/projects/side/2020_ASFChallenge_UCD/Code/R/SimsOut-exported_files/figure-markdown_strict/unnamed-chunk-5-1.png)

### Scenario 03: Movement restrictions, hunting pressure and fencing

![](/Users/nistara/projects/side/2020_ASFChallenge_UCD/Code/R/SimsOut-exported_files/figure-markdown_strict/unnamed-chunk-6-1.png)

<br><br>

Maps of infected areas
======================

Variables from the Agents folder:  
- *idhex:* Id of the hexagonal cell.  
- *Epidemic:* Number of times that there was an epidemic on that
polygon.  
- *introduction\_ph:* Number of times that an infected pig was
introduced to the polygon from other polygon.  
- *introduction\_wb:* Number of times the disease was transmitted from
wild boars to a pig herd.

### Scenario 0: Baseline

![](/Users/nistara/projects/side/2020_ASFChallenge_UCD/Code/R/SimsOut-exported_files/figure-markdown_strict/unnamed-chunk-7-1.png)

### Scenario 01: Movement restrictions

![](/Users/nistara/projects/side/2020_ASFChallenge_UCD/Code/R/SimsOut-exported_files/figure-markdown_strict/unnamed-chunk-8-1.png)

### Scenario 02: Movement restrictions and hunting pressure

![](/Users/nistara/projects/side/2020_ASFChallenge_UCD/Code/R/SimsOut-exported_files/figure-markdown_strict/unnamed-chunk-9-1.png)

### Scenario 03: Movement restrictions, hunting pressure and fencing

![](/Users/nistara/projects/side/2020_ASFChallenge_UCD/Code/R/SimsOut-exported_files/figure-markdown_strict/unnamed-chunk-10-1.png)

<br><br>

All scenarios together
======================

![](/Users/nistara/projects/side/2020_ASFChallenge_UCD/Code/R/SimsOut-exported_files/figure-markdown_strict/unnamed-chunk-11-1.png)![](/Users/nistara/projects/side/2020_ASFChallenge_UCD/Code/R/SimsOut-exported_files/figure-markdown_strict/unnamed-chunk-11-2.png)![](/Users/nistara/projects/side/2020_ASFChallenge_UCD/Code/R/SimsOut-exported_files/figure-markdown_strict/unnamed-chunk-11-3.png)

<br><br>

Summary plot
============

![](/Users/nistara/projects/side/2020_ASFChallenge_UCD/Code/R/SimsOut-exported_files/figure-markdown_strict/summary-1.png)

    ## # A tibble: 4 x 2
    ##   S          `median(I_P)`
    ##   <chr>              <dbl>
    ## 1 Scenario 0          16.9
    ## 2 Scenario 1          14.5
    ## 3 Scenario 2          13.0
    ## 4 Scenario 3          11.9

    ## [1] 0.2314539

    ## [1] 0.2977669
