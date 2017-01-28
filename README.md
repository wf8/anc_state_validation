
# Validating RevBayes joint ancestral state estimation

This repo contains scripts to validate the joint ancestral state
estimation of SSE models implemented in [RevBayes](http://revbayes.com)
against the marginal ancestral state
estimation implemented in the R package [diversitree](http://www.zoology.ubc.ca/prog/diversitree/).

### To run an example:

First simulate a tree and character under BiSSE using diversitree. This script will also estimate 
marginal ancestral states using diversitree:

```
Rscript 1_simulate_BiSSE.R
```

Now estimate joint ancestral states using RevBayes:

```
rb 2_validate.Rev
```

And make a plot of the results:

```
Rscript 3_plot_Rev_results.R
```

### Example results:

Here we show the results for an example where λ0 = 0.2, λ1 = 0.4, µ0 = 0.01, µ1 = 0.1, 
and q01 = q10 = 0.02.

The log-likelihood as computed by diversitree was -260.634,
whereas with RevBayes it was -260.803.
Small differences in the log-likelihoods are expected due to numerical approximations.
However the joint and marginal reconstructions should return the same probabilities 
for ancestral states at the root, and indeed
diversitree calculated the root probability of being in state 0 as 0.6882
and RevBayes calculated it as 0.6883.

### diversitree ancestral states:

![diversitree plot](results/diversitree_ancestral_states.jpg)

### RevBayes ancestral states:

![RevBayes plot](results/revbayes_ancestral_states.jpg)

