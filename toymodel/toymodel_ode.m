function dxdt = toymodel_ode(t, x, k)

% toymodel_ode(time, variables_vector, parameter_vector)
% Function that implements the right hand side of the ODE for toymodel. 

%% rename variables
a       = x(1);
b       = x(2);
c       = x(3);
d       = x(4);

%% initialize the rates of change for each variable with 0
dadt    = 0;
dbdt    = 0;
dcdt    = 0;
dddt    = 0;

%% for each reaction - add up contributions to rates of changes

% synthesis
% -> a;    at rate:    k.a
v1 = k.a;
dadt    = dadt + v1;

% reversible bi-molecular conversion
% a+b <-> c;    at forward rate:    k.ab*a*b
%               at backward rate:   k.c*c
v2 = k.ab*a*b;
v3 = k.c*c; 
dadt    = dadt - v2 + v3;
dbdt    = dbdt - v2 + v3;
dcdt    = dcdt + v2 - v3;

% conversion
% c -> d;       at rate:    k.cat * c / (k.m + c)
v4 = k.cat*c/(k.m+c);
dcdt    = dcdt + -v4;
dddt    = dddt +  v4;

% a ->;    at rate:    k.deg*a
v5 = k.deg*a;
dadt    = dadt + -v5;

% b ->;    at rate:    k.deg*b
v6 = k.deg*b;
dbdt    = dbdt +  -v6;

%% output vector of rates of change of all variables
dxdt    = [dadt; dbdt; dcdt; dddt];