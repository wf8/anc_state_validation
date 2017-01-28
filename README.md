
# Validating RevBayes joint ancestral state estimation

This repo contains scripts to validate the joint ancestral state
estimation of SSE models implemented in [RevBayes](http://revbayes.com)
against the marginal ancestral state
estimation implemented in the R package [diversitree](http://www.zoology.ubc.ca/prog/diversitree/).

### To run an example:

First simulate a tree and character under BiSSE in diversitree. This script will also estimate 
marginal ancestral states using diversitree.

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

The log-likelihood as computed by diversitree was -260.634,
whereas with RevBayes it was -260.803.
Joint and marginal reconstructions should return the same probabilities 
for states at the root, and indeed
divirsitree's root probability of being in state 0 was 0.6882
and RevBayes was 0.6883.

### diversitree ancestral states:

![diversitree plot](results/diversitree_ancestral_states.jpg)

### RevBayes ancestral states:

![RevBayes plot](results/revbayes_ancestral_states.jpg)

