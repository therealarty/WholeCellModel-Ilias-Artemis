function M=ComputeM(r,t,m,q,c_r,c_t,c_m,c_q,k)
M=k.nr*r+k.nt*t+k.nm*m+k.nq*q+k.nr*(c_r+c_t+c_m+c_q);
end