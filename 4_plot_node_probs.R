
library(ggtree)

# load the revbayes ancestral state estimates
tree_file = "results/revbayes_ancestral_states.tree"
t = read.beast(tree_file)
tree = attributes(t)$phylo
rev_states = attributes(t)$stats$anc_state_1_pp

# get the ancestral states from diversitree again
library(diversitree)
library(ape)
set.seed(1234)
lambda_0 = 0.2
lambda_1 = 0.4
mu_0 = 0.01
mu_1 = 0.1
delta = 0.1
pars = c(lambda_0, lambda_1, mu_0, mu_1, delta, delta)
phy = tree.bisse(pars, max.t=22, x0=0)
states = phy$tip.state
lik = make.bisse(phy, states, strict=FALSE)
anc_states = asr.marginal(lik, pars)


# set up a dataframe to hold posteriors for each node from each method
num_taxa = length(states)
num_node = getNodeNum(tree)

df = data.frame(RevBayes=numeric(),
                diversitree=numeric(),
                stringsAsFactors=FALSE)

for (i in (num_taxa + 1):num_node) {

    dt = anc_states[1, i - num_taxa]
    rb = rev_states[names(rev_states) == i]
    rb = as.numeric(levels(rb))[rb]

    if (abs(rb - dt) > 0.1)
        dt = anc_states[2, i - num_taxa]

    df = rbind(df, list(RevBayes=rb, diversitree=dt))

}

# plot the comparison
p = ggplot(df, aes(RevBayes, diversitree)) + geom_point() +
    geom_line(aes(y=c(0:25)/25, x=c(0:25)/25), linetype="dotted", colour="blue") +
    xlim(min(df$RevBayes)-0.1, 1) + ylim(min(df$RevBayes)-0.1, 1) + 
    xlab("RevBayes posterior probabilities") + ylab("diversitree posterior probabilities")
ggsave("results/posteriors_plot.pdf", p)

