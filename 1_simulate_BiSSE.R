
library(diversitree)
library(ape)
set.seed(1234)

# simulate tree and character under BiSSE

lambda_0 = 0.2
lambda_1 = 0.4
mu_0 = 0.01
mu_1 = 0.1
delta = 0.1

# parameters = λ0, λ1, µ0, µ1, q01, q10
pars = c(lambda_0, lambda_1, mu_0, mu_1, delta, delta)
phy = tree.bisse(pars, max.t=22, x0=0)
states = phy$tip.state

# calculate likelihood
lik = make.bisse(phy, states, strict=FALSE)
rate = pars[1]
num_taxa = length(states)
lnl = lik(pars,root=ROOT.FLAT, condition.surv=!TRUE, intermediates=TRUE) - log( rate ) + num_taxa * log(2) - sum(log(1:num_taxa)) - log(2)
cat("diversitree lnl =", lnl, "\n", file="results/likelihoods.txt", append=TRUE)

# now infer marginal ancestral state reconstructions
anc_states = asr.marginal(lik, pars)

# plot the inferred ancestral states
pdf("results/diversitree_ancestral_states.pdf")
plot(phy, cex=.5, label.offset=0.2)
col = c("#004165", "#eaab00")
nodelabels(pie=t(anc_states), piecol=col, cex=.5)
dev.off()

# now write the tree to a newick file
write.tree(phy, file="sim_data/bisse.tree")

# now write tip data file
a = FALSE
for (i in 1:num_taxa) {
    cat(c(names(states[i]), states[i]), file="sim_data/tips.csv", append=a, sep=",")
    a = TRUE
    cat("\n", append=a, file="sim_data/tips.csv")
}
