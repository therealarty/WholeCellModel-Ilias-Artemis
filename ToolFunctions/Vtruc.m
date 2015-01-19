function rate=Vtruc(cx,a,k,x)

rate=cx*Hillfun(k.gamma_max,k.K_gamma,a);
eval(strcat('rate=rate/k.n',x,';'));
end