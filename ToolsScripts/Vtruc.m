function rate=Vtruc(c_x,a,k,xname)

rate=c_x*Hillfun(k.gamma_max,k.K_gamma,a);
eval(strcat('rate=rate/k.n',xname,';'));


end