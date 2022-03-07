# tda-crocker
Replication code for "Capturing dynamics of time-varying data via topology" by Lu Xian, Henry Adams, Chad M. Topaz, Lori Ziegelmeier, https://www.aimsciences.org/article/doi/10.3934/fods.2021033

## Simulating biological aggregation data with the Vicsek model
1. vicsek.m
2. vicsek-simulation.m

## Creating crocker plots 
1. crocker-plot-functions.R
2. create-crocker-plots.R (as an example, this file generates crocker plots for 100 simulation datasets of eta = 0.01)

## Creating crocker stacks
1. crocker-stack-functions.R
2. create-crocker-stacks.R (as an example, this file generates a crocker stack for simulation datasets of eta = 0.02)

## Experiments

# Order parameter clustering analysis
1. compute-op.R (as an example, this file computes the order parameters of simulation datasets of eta = 0.01)
2. op-analaysis.R (as an example, this file does clustering analysis based on order parameters for Experiment 2)

TBC --- 
# Crocker clustering analysis
1. crocker-plot-analysis.R (as an example, this file does clustering analysis based on crocker plots for Experiment 2)
2. crocker-stack-analysis.R (as an example, this file does clustering analysis based on crocker stacks for Experiment 2)
3. bottleneck distance
