{smcl}
{* *! version 0.1, 24 July 2024}{...}
{cmd:help for ipwvent}{right:Geoffrey T. Wodtke}
{hline}

{title:Title}

{p2colset 5 18 18 2}{...}
{p2col : {cmd:ipwvent} {hline 2}}causal mediation analysis of interventional effects using inverse probability weighting{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmd:ipwvent} {depvar} {ifin}{cmd:,} 
{opt dvar(varname)} 
{opt mvar(varname)} 
{opt lvar(varname)} 
{opt d(real)} 
{opt dstar(real)} 
{opt m(real)} 
{opt mreg(string)} 
{opt lreg(string)} 
{opt cvars(varlist)}
{opt censor(numlist)}
{opt sampwts(varname)} 
{opt nointeraction} 
{opt cxd} 
{opt lxd}
{opt reps(integer 200)} 
{opt strata(varname)} 
{opt cluster(varname)} 
{opt level(cilevel)} 
{opt seed(passthru)}
{opt detail}


{phang}{opt depvar} - this specifies the outcome variable.

{phang}{opt dvar(varname)} - this specifies the treatment (exposure) variable. This variable must be binary (0/1).

{phang}{opt mvar(varname)} - this specifies the mediator variable. This variable may be binary (0/1), continuous, or a count.

{phang}{opt lvar(varname)} - this specifies the exposure-induced confounder. This variable may be binary (0/1) or ordinal.

{phang}{opt d(real)} - this specifies the reference level of treatment.

{phang}{opt dstar(real)} - this specifies the alternative level of treatment. Together, (d - dstar) defines
the treatment contrast of interest.

{phang}{opt m(real)} - this specifies the level of the mediator at which the controlled direct effect 
is evaluated.

{phang}{opt mreg}{cmd:(}{it:string}{cmd:)}} - this specifies the form of regression model to be estimated for the mediator. 
Options are {opt regress}, {opt logit}, or {opt poisson}.

{phang}{opt lreg}{cmd:(}{it:string}{cmd:)}} - this specifies the form of regression model to be estimated for the exposure-induced confounder. 
Options are {opt logit} or {opt ologit}.

{title:Options}

{phang}{opt cvars(varlist)} - this option specifies the list of baseline covariates to be included in the analysis. Categorical 
variables need to be coded as a series of dummy variables before being entered as covariates.

{phang}{opt censor(numlist)} - this option specifies that the inverse probability weights are censored at the percentiles supplied in {numlist}. For example,
censor(1 99) censors the weights at their 1st and 99th percentiles.

{phang}{opt sampwts(varname)} - this option specifies a variable containing sampling weights to include in the analysis.

{phang}{opt nointer:action} - this option specifies whether a treatment-mediator interaction is not to be
included in the outcome model when estimating the controlled direct effect (the default assumes an interaction is present).

{phang}{opt cxd} - this option specifies that all two-way interactions between the treatment and baseline covariates are
included in the models for the mediator and the exposure-induced confounder.

{phang}{opt lxd} - this option specifies that a two-way interaction between the treatment and exposure-induced confounder is
included in the mediator model.

{phang}{opt reps(integer)} - this option specifies the number of replications for bootstrap resampling (the default is 200).

{phang}{opt strata(varname)} - this option specifies a variable that identifies resampling strata. If this option is specified, 
then bootstrap samples are taken independently within each stratum.

{phang}{opt cluster(varname)} - this option specifies a variable that identifies resampling clusters. If this option is specified,
then the sample drawn during each replication is a bootstrap sample of clusters.

{phang}{opt level(cilevel)} - this option specifies the confidence level for constructing bootstrap confidence intervals. If this 
option is omitted, then the default level of 95% is used.

{phang}{opt seed(passthru)} - this option specifies the seed for bootstrap resampling. If this option is omitted, then a random 
seed is used and the results cannot be replicated. {p_end}

{phang}{opt detail} - this option prints the fitted models for the exposure, the exposure-induced confounder, and the mediator; it 
also saves four variables containing the inverse probability weights used to compute the effect estimates. {p_end}

{title:Description}

{pstd}{cmd:ipwvent} performs causal mediation analysis of interventional effects using 
inverse probability weighting. Three models are estimated to construct the weights: a logit model 
for the exposure conditional on baseline covariates (if specified), a model for a single exposure-induced
confounder given the exposure and baseline covariates, and a model for the mediator conditional
on the exposure, exposure-induced confounder, and baseline covariates. In addition, a fourth model is 
estimated for the outcome, which is used to estimate the controlled direct effect. Multiple exposure-induced 
confounders are not supported. 

{pstd}{cmd:ipwvent} provides estimates of the controlled direct effect, the interventional direct effect, the 
interventional indirect effect, and the overall effect.{p_end}

{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. use nlsy79.dta} {p_end}

 
{pstd} percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. ipwvent std_cesd_age40, dvar(att22) lvar(ever_unemp_age3539) mvar(log_faminc_adj_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) mreg(regress) lreg(logit) d(1) dstar(0) m(10.82)} {p_end}

{pstd} all two-way interactions between the confounders and exposure; percentile bootstrap CIs with 1000 replications: {p_end}
 
{phang2}{cmd:. ipwvent std_cesd_age40, dvar(att22) lvar(ever_unemp_age3539) mvar(log_faminc_adj_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) mreg(regress) lreg(logit) cxd lxd d(1) dstar(0) m(10.82) reps(1000)} {p_end}

{pstd} all two-way interactions between the confounders and exposure; percentile bootstrap CIs with 1000 replications; censored weights: {p_end}
 
{phang2}{cmd:. ipwvent std_cesd_age40, dvar(att22) lvar(ever_unemp_age3539) mvar(log_faminc_adj_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) mreg(regress) lreg(logit) cxd lxd d(1) dstar(0) m(10.82) reps(1000) censor(1 99)} {p_end}

{title:Saved results}

{pstd}{cmd:ipwvent} saves the following results in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}matrix containing direct, indirect and overall effect estimates{p_end}


{title:Author}

{pstd}Geoffrey T. Wodtke {break}
Department of Sociology{break}
University of Chicago{p_end}

{phang}Email: wodtke@uchicago.edu


{title:References}

{pstd}Wodtke GT and Zhou X. Causal Mediation Analysis. In preparation. {p_end}

{title:Also see}

{psee}
Help: {manhelp logit R}, {manhelp ologit R}, {manhelp regress R}, {manhelp poisson R}, {manhelp bootstrap R}
{p_end}
