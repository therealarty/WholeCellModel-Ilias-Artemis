function rate=Hillfun(Vmax,Km,x,h)
if nargin<4
    h=1;
end

rate=(Vmax*x^h)./(Km+x^h);
end