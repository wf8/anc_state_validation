
library(ggtree)

# load the revbayes ancestral state estimates
tree_file = "results/revbayes_ancestral_states.tree"
t = read.beast(tree_file)
tree = attributes(t)$phylo
rev_states = attributes(t)$stats$anc_state_1
rev_states = as.numeric(levels(rev_states))[rev_states]
rev_states_pp = attributes(t)$stats$anc_state_1_pp
rev_states_pp = as.numeric(levels(rev_states_pp))[rev_states_pp]
rev_indices = attributes(t)$stats$index
rev_indices = as.numeric(levels(rev_indices))[rev_indices]

# get the ancestral states from diversitree again
library(diversitree)
library(ape)
set.seed(1234)
lambda_0 = 0.2
lambda_1 = 0.4
mu_0 = 0.01
mu_1 = 0.1
delta = 0.1
pars = c(lambda_0, lambda_1, mu_0, mu_1, delta, 4*delta)
phy = tree.bisse(pars, max.t=22, x0=0)
states = phy$tip.state
lik = make.bisse(phy, states, strict=FALSE)
anc_states = asr.marginal(lik, pars, root=ROOT.GIVEN, root.p=c(0.5,0.5))


# set up a dataframe to hold posteriors for each node from each method
num_taxa = length(states)
num_node = getNodeNum(tree)

df = data.frame(RevBayes=numeric(),
                diversitree=numeric(),
                stringsAsFactors=FALSE)

# get ancestral state for state = 0 for each node
for (i in (num_taxa + 1):num_node) {

    dt = anc_states[1, i - num_taxa]
    rb = rev_states[rev_indices == i]
    rb_pp = rev_states_pp[rev_indices == i]

    if (rb != 0)
        rb_pp = 1 - rb_pp

    df = rbind(df, list(RevBayes=round(rb_pp,2), diversitree=round(dt,2)))

}

df$rb_ordered = sort(df$RevBayes)
df$dt_ordered = sort(df$diversitree)

# plot the comparison
p = ggplot(df, aes(rb_ordered, dt_ordered)) + geom_point() +
    geom_line(aes(y=c(0:19)/19, x=c(0:19)/19), linetype="dotted", colour="blue") +
    xlim(0, 1) + ylim(0, 1) + theme_classic(base_size=14) + 
    xlab("RevBayes posterior probabilities") + ylab("diversitree posterior probabilities")
ggsave("results/posteriors_plot.pdf", p)

