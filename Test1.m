function [delta12,delta23,delta13]=Test1(lambda,s_i,e_m,e_t,k)
val1=lambda.*k.M/k.ns;
val2=e_m.*Hillfun(k.vm,k.Km,s_i);
val3=e_t.*Hillfun(k.vt,k.Km,k.s);

delta12=abs(val1-val2);
delta23=abs(val2-val3);
delta13=abs(val1-val3);
epsilon=max(max([val1,val2,val3])/1000;
if all((delta12+delta23+delta13)<epsilon)
    disp('Test 1 : Passed bitch');
else
    if any((delta12+delta23+delta13)<epsilon)
        frametestok=find((delta12+delta23+delta13)<epsilon,1,'first');
        disp('Test Ok at :')
        frametestok
    else
        disp('Test 1 : Failed');
    end
end

end