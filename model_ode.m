function dxdt = toymodel_ode(t, x, k)

% toymodel_ode(time, variables_vector, parameter_vector)
% Function that implements the right hand side of the ODE for toymodel. 

%% rename variables
s_i       = x(1);
a         = x(2);
r         = x(3);
e_t       = x(4);
e_m       = x(5);
q         = x(6);
m_r       = x(7);
m_t       = x(8);
m_m       = x(9);
m_q       = x(10);
c_r       = x(11);
c_t       = x(12);
c_m       = x(13);
c_q       = x(14);

%% initialize the rates of change for each variable with 0
ddts_i       = 0;
ddta         = 0;
ddtr         = 0;
ddte_t       = 0;
ddte_m       = 0;
ddtq         = 0;
ddtm_r       = 0;
ddtm_t       = 0;
ddtm_m       = 0;
ddtm_q       = 0;
ddtc_r       = 0;
ddtc_t       = 0;
ddtc_m       = 0;
ddtc_q       = 0;

%% for each reaction - add up contributions to rates of changes

lambda=ComputeLambda(a,r,e_t,e_m,q,c_r,c_t,c_m,c_q,k,1);

% k.s %nutrient concentration
% k.ns % nutrient effiency
% k.vt %transport
% k.Kt %Transport
% k.vm %max enzym rate metabolism
% k.Km %MM constant enzym metabolism
% k.nr %length rib prot
% k.nt %length transport prot
% k.nm %length metabolic enzyme
% k.nq %length house keeping genes
% k.gamma_max %max elongation rate
% k.K_gamma% hill gamma 
% k.k_b %ribosome binding rate
% k.k_u %ribosome unbinding rate
% k.theta_r
% k.theta_nr
% k.wr
% k.wt
% k.wm
% k.wq
% k.Kq
% k.hq
% k.dm %mRNA degradation rate


vimp=Hillfun(k.vt,k.Kt,k.s);
vcat=Hillfun(k.vm,k.Km,s_i);

ddts_i     = ddts_i  + vimp*e_t-vcat*e_m-lambda*s_i;

ddta       = ddta + k.ns*vcat*e_m;
ddta       = ddta - c_r*Hillfun(k.gamma_max,k.K_gamma,a);% multiply and divide by nx
ddta       = ddta - c_t*Hillfun(k.gamma_max,k.K_gamma,a);
ddta       = ddta - c_m*Hillfun(k.gamma_max,k.K_gamma,a);
ddta       = ddta - c_q*Hillfun(k.gamma_max,k.K_gamma,a);
ddta       = ddta -lambda*a;

ddtr = ddtr + c_r/k.nr*Hillfun(k.gamma_max,k.K_gamma,a) -lambda*r;
ddtr = ddtr + c_r/k.nr*Hillfun(k.gamma_max,k.K_gamma,a)-k.k_b*r*m_r+k.k_u*c_r;
ddtr = ddtr + c_t/k.nt*Hillfun(k.gamma_max,k.K_gamma,a)-k.k_b*r*m_t+k.k_u*c_t;
ddtr = ddtr + c_m/k.nm*Hillfun(k.gamma_max,k.K_gamma,a)-k.k_b*r*m_m+k.k_u*c_m;
ddtr = ddtr + c_q/k.nq*Hillfun(k.gamma_max,k.K_gamma,a)-k.k_b*r*m_q+k.k_u*c_q;

ddte_t = ddte_t + Vtruc(c_t,a,k,'t')-lambda*e_t;

ddte_m = ddte_m + Vtruc(c_m,a,k,'m')-lambda*e_m;

ddtq = ddtq + Vtruc(c_q,a,k,'q')-lambda*q;

ddtq = ddtq + Vtruc(c_q,a,k,'q')-lambda*q;

ddtm_r = ddtm_r + omega_r(a,k)-(lambda + k.dm)*m_r + Vtruc(c_r,a,k,'r')-k.k_b*r*m_r+k.k_u*c_r;

ddtm_t = ddtm_t + omega_t(a,k)-(lambda + k.dm)*m_t + Vtruc(c_t,a,k,'t')-k.k_b*r*m_t+k.k_u*c_t;

ddtm_m = ddtm_m + omega_m(a,k)-(lambda + k.dm)*m_m + Vtruc(c_m,a,k,'m')-k.k_b*r*m_m+k.k_u*c_m;

ddtm_q = ddtm_q + omega_q(a,k,q)-(lambda + k.dm)*m_q + Vtruc(c_q,a,k,'q')-k.k_b*r*m_q+k.k_u*c_q;

ddtc_r = ddtc_r -lambda*c_r - Vtruc(c_r,a,k,'r')+k.k_b*r*m_r-k.k_u*c_r;

ddtc_t = ddtc_t -lambda*c_t - Vtruc(c_t,a,k,'t')+k.k_b*r*m_t-k.k_u*c_t;

ddtc_m = ddtc_m -lambda*c_m - Vtruc(c_m,a,k,'m')+k.k_b*r*m_m-k.k_u*c_m;

ddtc_q = ddtc_q -lambda*c_q - Vtruc(c_q,a,k,'q')+k.k_b*r*m_q-k.k_u*c_q;


%% output vector of rates of change of all variables
dxdt    = [ddts_i;ddta;ddtr;ddte_t ;ddte_m;ddtq;ddtm_r;ddtm_t;ddtm_m;ddtm_q;ddtc_r;ddtc_t;ddtc_m;ddtc_q ];