# ipwvent: A Stata Module for Estimating Interventional Direct and Indirect Effects Using Inverse Probability Weighting

`ipwvent` is a Stata module designed to perform causal mediation analysis of interventional effects using inverse probability weighting (IPW). This approach is designed for analyses with a single exposure-induced confounder.

## Syntax

```stata
ipwvent depvar, dvar(varname) mvar(varname) lvar(varname) d(real) dstar(real) m(real) mreg(string) lreg(string) [options]
```

### Required Arguments

- `depvar`: Specifies the outcome variable.
- `dvar(varname)`: Specifies the treatment (exposure) variable, which must be binary and coded 0/1.
- `mvar(varname)`: Specifies the mediator variable, which can be binary, continuous, or count.
- `lvar(varname)`: Specifies a single exposure-induced confounder, which must be binary (0/1) or ordinal. Multiple exposure-induced confounders are not supported.
- `d(real)`: Reference level of treatment.
- `dstar(real)`: Alternative level of treatment, defining the treatment contrast of interest.
- `m(real)`: Level of the mediator at which the controlled direct effect is evaluated.
- `mreg(string)`: Regression model for the mediator; options are `regress`, `logit`, or `poisson`.
- `lreg(string)`: Regression model for the exposure-induced confounder; options are `logit` or `ologit`.

### Options

- `cvars(varlist)`: Baseline covariates to include in the analysis.
- `sampwts(varname)`: Specifies a variable containing sampling weights.
- `nointeraction`: Excludes treatment-mediator interaction in the outcome model.
- `cxd`: Includes all two-way interactions between the treatment and baseline covariates in models for the exposure-induced confounder and mediator.
- `lxd`: Includes two-way interaction between the treatment and exposure-induced confounder in the mediator model.
- `censor`: Specifies that the inverse probability weights are censored at 1st and 99th percentiles.
- `detail`: Prints fitted models and saves variables containing the inverse probability weights.

## Description

`ipwvent` fits several models to construct weights and estimate interventional effects:
1. A logit model for the exposure conditional on the baseline covariates.
2. A model for the exposure-induced confounder conditional on the exposure and baseline covariates.
3. A model for the mediator conditional on the exposure, the exposure-induced confounder, and baseline covariates.
4. A model for the outcome (used to estimate controlled direct effects).

This approach provides estimates for the controlled direct effect, interventional direct effect, interventional indirect effect, and overall effect.

If using `sampwts` from a complex sample design that require rescaling to produce valid boostrap estimates, be sure to appropriately specify the `strata`, `cluster`, and `size` options from the `bootstrap` command so that Nc-1 clusters are sampled from each stratum with replacement, where Nc denotes the number of clusters per stratum. Failing to properly adjust the bootstrap procedure to account for a complex sample design and its associated sampling weights could lead to invalid inferential statistics.

## Examples

```stata
// Load data
use nlsy79.dta

// Default settings
ipwvent std_cesd_age40, dvar(att22) lvar(ever_unemp_age3539) mvar(log_faminc_adj_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) lreg(logit) mreg(regress) d(1) dstar(0) m(10.82)

// Include all two-way interactions and censor the weights
ipwvent std_cesd_age40, dvar(att22) lvar(ever_unemp_age3539) mvar(log_faminc_adj_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) lreg(logit) mreg(regress) d(1) dstar(0) m(10.82) cxd lxd censor
```

## Saved Results

`ipwvent` saves the following results in `e()`:

- **Matrices**:
  - `e(b)`: Matrix containing direct, indirect, and overall effect estimates.

## Author

Geoffrey T. Wodtke  
Department of Sociology  
University of Chicago

Email: [wodtke@uchicago.edu](mailto:wodtke@uchicago.edu)

## References

- Wodtke GT and Zhou X. Causal Mediation Analysis. In preparation.

## Also See

- [logit R](#)
- [ologit R](#)
- [regress R](#)
- [poisson R](#)
- [bootstrap R](#)
