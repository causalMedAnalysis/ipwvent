*!TITLE: IPWVENT - causal mediation analysis of interventional effects using inverse probability weighting	
*!AUTHOR: Geoffrey T. Wodtke, Department of Sociology, University of Chicago
*!
*! version 0.1 
*!

program define ipwvent, eclass

	version 15	

	syntax varlist(min=1 max=1 numeric) [if][in], ///
		dvar(varname numeric) ///
		mvar(varname numeric) ///
		lvar(varname numeric) ///
		mreg(string) ///
		lreg(string) ///
		d(real) ///
		dstar(real) ///
		m(real) ///
		[NOINTERaction] ///
		[cvars(varlist numeric)] ///
		[cxd] ///
		[lxd] ///
		[sampwts(varname numeric)] ///
		[detail] ///
		[reps(integer 200)] ///
		[strata(varname numeric)] ///
		[cluster(varname numeric)] ///
		[level(cilevel)] ///
		[seed(passthru)] ///
		[saving(string)]

	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
	}
	
	foreach i in `dvar' {
		confirm variable `i'
		qui sum `i'
		if r(min) != 0 | r(max) != 1 {
		display as error "{p 0 0 5 0} The variable `i' is not binary and coded 0/1"
        error 198
		}
	}

	/***COMPUTE POINT AND INTERVAL ESTIMATES***/
	if ("`saving'" != "") {
		bootstrap OE=r(oe) IDE=r(ide) IIE=r(iie) CDE=r(cde), ///
			reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
			saving(`saving', replace) noheader notable: ///
			ipwventbs `varlist' if `touse', ///
			dvar(`dvar') mvar(`mvar') lvar(`lvar') cvars(`cvars') ///
			d(`d') dstar(`dstar') m(`m') ///
			mreg(`mreg') lreg(`lreg') sampwts(`sampwts') ///
			`nointeraction' `cxd' `lxd' `censor'
			}

	if ("`saving'" == "") {
		bootstrap OE=r(oe) IDE=r(ide) IIE=r(iie) CDE=r(cde), ///
			reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
			noheader notable: ///
			ipwventbs `varlist' if `touse', ///
			dvar(`dvar') mvar(`mvar') lvar(`lvar') cvars(`cvars') ///
			d(`d') dstar(`dstar') m(`m') ///
			mreg(`mreg') lreg(`lreg') sampwts(`sampwts') ///
			`nointeraction'  `cxd' `lxd' `censor'
			}
			
	estat bootstrap, p noheader
	
	/***REPORT MODELS AND SAVE WEIGHTS IF REQUESTED***/
	if ("`detail'" != "") {
		ipwventbs `varlist' if `touse', ///
		dvar(`dvar') mvar(`mvar') lvar(`lvar') cvars(`cvars') ///
		d(`d') dstar(`dstar') m(`m') ///
		mreg(`mreg') lreg(`lreg') sampwts(`sampwts') ///
		`nointeraction' `cxd' `lxd' `censor' `detail'
		
		label var sw1_r001 "IPW for estimating E(Y(d*,Mtilde(d*|C)))"
		label var sw2_r001 "IPW for estimating E(Y(d,Mtilde(d|C)))"
		label var sw3_r001 "IPW for estimating E(Y(d,Mtilde(d*|C)))"
		label var sw4_r001 "IPW for estimating E(Y(d,m))"
		}
	
end ipwvent
