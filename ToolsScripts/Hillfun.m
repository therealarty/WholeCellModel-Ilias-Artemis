function rate=Hillfun(vmax,Km,x,h)
if nargin<4
    h=1;
end
rate=vmax*(x.^h)./(Km+(x.^h));

end