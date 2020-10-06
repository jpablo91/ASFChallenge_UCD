Simulations Output
================

``` r
library(dplyr); library(ggplot2); library(ggpubr); library(sf)
################## FUNCTIONS ####################
# Read Simulations
ReadSims <- function(dir){
  f <- list.files(dir, full.names = TRUE)
  
  L <- lapply(1:length(f), function(x){
    read.csv(f[x], fileEncoding = 'UTF-8') %>%
      mutate(Sim = x)
    }) %>%
    do.call(rbind, .)
}

# Functions for getting quantiles
Q25 <- function(x) quantile(x, 0.25)
Q75 <- function(x) quantile(x, 0.75)

# Function for summarizing the cycles
CycleSums <- function(x){
  x %>%
    dplyr::select(-Sim) %>%
    group_by(cycle) %>%
    summarise_all(.funs = c(median, Q25, Q75))
}

# Function for the plots
PlotCycles <- function(x, var, col){
  x %>%
    CycleSums() %>%
    ggplot(aes(x=cycle)) +
    geom_line(aes(y=eval(parse(text = paste0(var, '_fn1')))), col = col, lwd = 1) +
    geom_ribbon(aes(ymin=eval(parse(text = paste0(var, '_fn2'))), ymax=eval(parse(text = paste0(var, '_fn3')))), alpha = 0.3, fill = col) +
    theme_minimal() + ylab(var) +
    theme(legend.position = "none") 
}
## Function to convert from long to wide
# Variable to spread categorical variables
unfold <- function(Dat, Var){
  Dat %>% mutate(N=1) %>% tidyr::spread(eval(parse(text = Var)), N, fill = 0)
}
```

Variables from the ‘EC’ folder:

  - *cycle:* time step of the simulation.  
  - *Infected\_P:* Number of infected pig herds.  
  - *Infected\_WB:* Number of infected wild Boars.  
  - *Sim:* Iteration of the simulation.

# Scenario 0: Baseline

``` r
S0 <- ReadSims(dir = "../../Data/Period_1/Sims/S00/EC/")

P1 <- PlotCycles(S0, var = "Infected_P", col = "pink2")
P2 <- PlotCycles(S0, var = "Infected_WB", col = "brown")

ggarrange(P1, P2)
```

![](SimsOut_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
S0_I <- S0 %>%
  group_by(Sim) %>%
  summarise(I_P = max(Infected_P)) %>%
  mutate(S = '00')
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

## Map

Variables from the Agents folder:  
\- *idhex:* Id of the hexagonal cell.  
\- *Epidemic:* Number of times that there was an epidemic on that
polygon.  
\- *introduction\_ph:* Number of times that an infected pig was
introduced to the polygon from other polygon.  
\- *introduction\_wb:* Number of times the disease was transmitted from
wild boars to a pig herd.

``` r
Hx_sim <- ReadSims(dir = "../../Data/Period_1/Sims/S00/Agents/")
Hx <- st_read("../../Data/Period_1/out/Hx.shp", quiet = T)

Hx_sim <- Hx_sim %>%
  mutate(idhex = as.character(idhex)) %>%
  unfold(., "Disease_status") %>%
  group_by(idhex) %>%
  summarise_at(.vars = c('Epidemic', 'introduction_ph', 'introduction_wb'), .funs = sum)

Hx %>%
  left_join(Hx_sim, by = 'idhex') %>%
  filter(!is.na(Pop)) %>%
  mutate(Epidemic = ifelse(is.na(cases), Epidemic, 0)/50,
         index_case = ifelse(is.na(cases), NA, 1)) %>%
  ggplot() +
  geom_sf(aes(fill = Epidemic)) +
  geom_sf(data = subset(Hx, !is.na(cases)), fill = "red4")
```

![](SimsOut_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

# Scenario 01: Movement restrictions

``` r
S1 <- ReadSims(dir = "../../Data/Period_1/Sims/S01/EC/")

P1 <- PlotCycles(S1, var = "Infected_P", col = "pink2")
P2 <- PlotCycles(S1, var = "Infected_WB", col = "brown")

ggarrange(P1, P2)
```

![](SimsOut_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
S1_I <- S1 %>%
  group_by(Sim) %>%
  summarise(I_P = max(Infected_P)) %>%
  mutate(S = '01')
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

## Map

``` r
Hx_sim01 <- ReadSims(dir = "../../Data/Period_1/Sims/S01/Agents/")

Hx_sim01 <- Hx_sim01 %>%
  mutate(idhex = as.character(idhex)) %>%
  unfold(., "Disease_status") %>%
  group_by(idhex) %>%
  summarise_at(.vars = c('Epidemic', 'introduction_ph', 'introduction_wb'), .funs = sum)

Hx %>%
  left_join(Hx_sim01, by = 'idhex') %>%
  filter(!is.na(Pop)) %>%
  mutate(Epidemic = ifelse(is.na(cases), Epidemic, 0)/50,
         index_case = ifelse(is.na(cases), NA, 1)) %>%
  ggplot() +
  geom_sf(aes(fill = Epidemic)) +
  geom_sf(data = subset(Hx, !is.na(cases)), fill = "red4")
```

![](SimsOut_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

# Scenario 02: Movement restrictions and hunting pressure

``` r
S2 <- ReadSims(dir = "../../Data/Period_1/Sims/S02/EC/")

P1 <- PlotCycles(S2, var = "Infected_P", col = "pink2")
P2 <- PlotCycles(S2, var = "Infected_WB", col = "brown")

ggarrange(P1, P2)
```

![](SimsOut_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
S2_I <- S2 %>%
  group_by(Sim) %>%
  summarise(I_P = max(Infected_P)) %>%
  mutate(S = '02')
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

``` r
rbind(S0_I, S1_I, S2_I) %>%
  ggplot(aes(y=I_P, fill = S)) +
  geom_boxplot()
```

![](SimsOut_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

## Map

``` r
Hx_sim02 <- ReadSims(dir = "../../Data/Period_1/Sims/S02/Agents/")

Hx_sim02 <- Hx_sim02 %>%
  mutate(idhex = as.character(idhex)) %>%
  unfold(., "Disease_status") %>%
  group_by(idhex) %>%
  summarise_at(.vars = c('Epidemic', 'introduction_ph', 'introduction_wb'), .funs = sum)

Hx %>%
  left_join(Hx_sim02, by = 'idhex') %>%
  filter(!is.na(Pop)) %>%
  mutate(Epidemic = ifelse(is.na(cases), Epidemic, 0)/50,
         index_case = ifelse(is.na(cases), NA, 1)) %>%
  ggplot() +
  geom_sf(aes(fill = Epidemic)) +
  geom_sf(data = subset(Hx, !is.na(cases)), fill = "red4")
```

![](SimsOut_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

# Scenario 03: Movement restrictions, hunting pressure and fencing

``` r
S3 <- ReadSims(dir = "../../Data/Period_1/Sims/S03/EC/")

P1 <- PlotCycles(S2, var = "Infected_P", col = "pink2")
P2 <- PlotCycles(S2, var = "Infected_WB", col = "brown")

ggarrange(P1, P2)
```

![](SimsOut_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

``` r
S3_I <- S3 %>%
  group_by(Sim) %>%
  summarise(I_P = max(Infected_P)) %>%
  mutate(S = '03')
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

``` r
rbind(S0_I, S1_I, S2_I, S3_I) %>%
  ggplot(aes(y=I_P, fill = S)) +
  geom_boxplot()
```

![](SimsOut_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

## Map

``` r
Hx_sim03 <- ReadSims(dir = "../../Data/Period_1/Sims/S02/Agents/")

Hx_sim03 <- Hx_sim03 %>%
  mutate(idhex = as.character(idhex)) %>%
  unfold(., "Disease_status") %>%
  group_by(idhex) %>%
  summarise_at(.vars = c('Epidemic', 'introduction_ph', 'introduction_wb'), .funs = sum)

Hx %>%
  left_join(Hx_sim03, by = 'idhex') %>%
  filter(!is.na(Pop)) %>%
  mutate(Epidemic = ifelse(is.na(cases), Epidemic, 0)/50,
         index_case = ifelse(is.na(cases), NA, 1)) %>%
  ggplot() +
  geom_sf(aes(fill = Epidemic)) +
  geom_sf(data = subset(Hx, !is.na(cases)), fill = "red4")
```

![](SimsOut_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->
