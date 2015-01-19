function lambda=ComputeLambda(a,r,t,m,q,c_r,c_t,c_m,c_q,k)

M=ComputeM(r,t,m,q,c_r,c_t,c_m,c_q,k);
Rt=c_r+c_t+c_m+c_q;
gammaa=Hillfun(k.gamma_max,k.K_gamma,a);
lambda=gammaa.*Rt./M;


end