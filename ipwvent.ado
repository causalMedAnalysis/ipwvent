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
		[NOINTERaction ///
		cvars(varlist numeric) ///
		cxd ///
		lxd ///
		sampwts(varname numeric) ///
		censor ///
		detail * ]

	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
	}
	
	confirm variable `dvar'
	qui levelsof `dvar', local(levels)
	if "`levels'" != "0 1" & "`levels'" != "1 0" {
		display as error "The variable `i' is not binary and coded 0/1"
		error 198
	}
	
	local mregtypes regress logit poisson
	local nmreg : list posof "`mreg'" in mregtypes
	if !`nmreg' {
		display as error "Error: mreg must be chosen from: `mregtypes'."
		error 198		
	}
	else {
		local mreg : word `nmreg' of `mregtypes'
	}	

	local lregtypes logit ologit 
	local nlreg : list posof "`lreg'" in lregtypes
	if !`nlreg' {
		display as error "Error: lreg must be chosen from: `lregtypes'."
		error 198		
	}
	else {
		local lreg : word `nlreg' of `lregtypes'
	}	

	/***COMPUTE POINT AND INTERVAL ESTIMATES***/
	bootstrap ///
		OE=r(oe) ///
		IDE=r(ide) ///
		IIE=r(iie) ///
		CDE=r(cde), ///
			noheader notable `options' : ///
				ipwventbs `varlist' if `touse', ///
					dvar(`dvar') mvar(`mvar') lvar(`lvar') cvars(`cvars') ///
					d(`d') dstar(`dstar') m(`m') ///
					mreg(`mreg') lreg(`lreg') sampwts(`sampwts') ///
					`nointeraction'  `cxd' `lxd' `censor'
			
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
