function rate=omega_q(a,k,q)

rate=k.wq*a/((a+k.thetax)*(1+(q/k.Kq)^k.hq));
end