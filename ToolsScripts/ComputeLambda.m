function lambda=ComputeLambda(a,r,t,m,q,c_r,c_t,c_m,c_q,k,useMparam)
if nargin<11
    useMparam=false;
end
if useMparam
    M=k.M;
else
M=ComputeM(r,t,m,q,c_r,c_t,c_m,c_q,k);
end
Rt=c_r+c_t+c_m+c_q;
gammaa=Hillfun(k.gamma_max,k.K_gamma,a);
lambda=gammaa.*Rt./M;


end