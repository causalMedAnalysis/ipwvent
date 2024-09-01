# ipwvent: Causal Mediation Analysis of Interventional Effects Using Inverse Probability Weighting

`ipwvent` is a Stata module designed to perform causal mediation analysis of interventional effects using inverse probability weighting (IPW). This approach is designed for analyses with exposure-induced confounders.

## Syntax

```stata
ipwvent varname, dvar(varname) mvar(varname) lvar(varname) mreg(string) lreg(string) d(real) dstar(real) m(real) [options]
```

### Required Arguments

- `varname`: Specifies the outcome variable.
- `dvar(varname)`: Specifies the treatment (exposure) variable, must be binary and coded 0/1.
- `mvar(varname)`: Specifies the mediator variable, can be binary, continuous, or count.
- `lvar(varname)`: Specifies a single exposure-induced confounder, must be binary (0/1) or ordinal. Multiple exposure-induced confounders are not supported.
- `mreg(string)`: Regression model for the mediator; options are `regress`, `logit`, or `poisson`.
- `lreg(string)`: Regression model for the exposure-induced confounder; options are `logit` or `ologit`.
- `d(real)`: Reference level of treatment.
- `dstar(real)`: Alternative level of treatment, defining the treatment contrast of interest.
- `m(real)`: Level of the mediator at which the controlled direct effect is evaluated.

### Options

- `cvars(varlist)`: Baseline covariates to include in the analysis.
- `weights(varname)`: Specifies a variable containing sampling weights.
- `nointeraction`: Excludes treatment-mediator interaction in the outcome model.
- `cxd`: Includes all two-way interactions between the treatment and baseline covariates in models for the exposure-induced confounder and mediator.
- `lxd`: Includes two-way interaction between the treatment and exposure-induced confounder in the mediator model.
- `reps(integer)`: Number of replications for bootstrap resampling, default is 200.
- `strata(varname)`: Variable that identifies resampling strata.
- `cluster(varname)`: Variable that identifies resampling clusters.
- `level(cilevel)`: Confidence level for bootstrap confidence intervals, default is 95%.
- `seed(passthru)`: Seed for bootstrap resampling.
- `detail`: Prints fitted models and saves variables containing the inverse probability weights.

## Description

`ipwvent` fits several models to construct weights and estimate interventional effects:
1. A logit model for the exposure conditional on the baseline covariates.
2. A model for the exposure-induced confounder conditional on the exposure and baseline covariates.
3. A model for the mediator conditional on the exposure, the exposure-induced confounder, and baseline covariates.
4. A model for the outcome (used to estimate controlled direct effects when the mediator is not binary).

This approach provides estimates for the controlled direct effect, interventional direct effect, interventional indirect effect, and overall effect.

## Examples

```stata
// Load data
use nlsy79.dta

// Default settings
ipwvent std_cesd_age40, dvar(att22) lvar(ever_unemp_age3539) mvar(log_faminc_adj_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) lreg(logit) mreg(regress) d(1) dstar(0) m(10.82) reps(200)

// Include all two-way interactions
ipwvent std_cesd_age40, dvar(att22) lvar(ever_unemp_age3539) mvar(log_faminc_adj_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) lreg(logit) mreg(regress) cxd lxd d(1) dstar(0) m(10.82) reps(200)
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

- Wodtke GT, Zhou X, and Elwert F. Causal Mediation Analysis. In preparation.

## Also See

- [logit R](#)
- [ologit R](#)
- [regress R](#)
- [poisson R](#)
- [bootstrap R](#)
