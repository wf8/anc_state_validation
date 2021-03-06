
# Validating ancestral state estimates for SSE models in RevBayes

This code repository 
contains scripts to validate the Monte Carlo method of
ancestral state estimation for state-dependent speciation and extinction (SSE) models
we implemented for [Freyman and H&ouml;hna (2017)](https://doi.org/10.1093/sysbio/syx065) 
in [RevBayes](http://revbayes.com) (H&ouml;hna et al. 2016) against the
analytical marginal ancestral state estimation
implemented in the R package [diversitree](http://www.zoology.ubc.ca/prog/diversitree/) (FitzJohn 2012).

Although the closest model to ChromoSSE implemented in diversitree
is ClaSSE (Goldberg and Igi&#263; 2012), ancestral state estimation for ClaSSE is not implemented in diversitree.
Therefore here we compare the ancestral state estimates for BiSSE (Maddison et al. 2007) as implemented
in diversitree to the estimates made by RevBayes. 
Note that as implemented in RevBayes the BiSSE,
ChromoSSE, ClaSSE, MuSSE (FitzJohn 2012), and HiSSE (Beaulieu and O’Meara
2016) models use the same C++ classes and algorithms for parameter and
ancestral state estimation, so validating ancestral state estimates for BiSSE should
provide confidence in estimates made by RevBayes for all these SSE models.

In RevBayes we sample ancestral states for SSE models
from their joint distribution
conditional on the tip states and the model parameters during the MCMC.
However, in this work we summarize the MCMC samples by calculating the
marginal posterior probability of each node being in each state.
So the RevBayes marginal ancestral state reconstructions which are
estimated via MCMC are directly comparable to the
analytical marginal ancestral states computed by diversitree.
In RevBayes it would be possible to summarize the samples from the MCMC
to reconstruct the maximum a posteriori joint ancestral state reconstruction,
but we have not done so in this work.


### To run an example:

First simulate a tree and character under BiSSE using diversitree. This script will also estimate 
and plot marginal ancestral states using diversitree:

```
Rscript 1_simulate_BiSSE.R
```

Now estimate ancestral states using RevBayes and summarize the marginal ancestral states:

```
rb 2_validate.Rev
```

And make a plot of the RevBayes results:

```
Rscript 3_plot_Rev_results.R
```

And now let's make a plot to compare the posterior probabilties estimated
in RevBayes to those estimated in diversitree:

```
Rscript 4_plot_node_probs.R
```

### Example results:

Here we show ancestral state estimates under BiSSE for an example where
the tree and tip data were simulated in diversitree with the following parameters:
λ0 = 0.2, λ1 = 0.4, µ0 = 0.01, µ1 = 0.1, 
and q01 = 0.1 and q10 = 0.4.

If the RevBayes Monte Carlo method produces correct ancestral states,
the marginal posterior probabilities for each state at every node of the tree
should be equal to those analytically computed by diversitree.
Indeed, the estimated posterior probabilities are very close for all nodes.
This is shown in a plot comparing
the marginal posterior probabilities for all nodes being in state 0 
as estimated by RevBayes against the diversitree estimates:

<p align="center">
<img src="results/posteriors_plot.jpg" width="500px"/>
</p>

### diversitree ancestral states:

<p align="center">
<img src="results/diversitree_ancestral_states.jpg" width="700px"/>
</p>

### RevBayes ancestral states:

![RevBayes plot](results/revbayes_ancestral_states.jpg)

