function [ Test_I , Test_II , Test_II_bis , Test_III ] = Tests( S , o , p)
% This function realizes four tests. If one of those test is wrong it means
% that the core model is not implemnted correctly. The tests come from the
% derivation in the paper's supplementary informations in which the model is
% described
Hill=@(n,k,v,x)(Hillfun(v,k,x,n));
delta = 0.01; % tolerance
o.lambda=o.lambda(end);

%% Tests

Test     = struct();
Test.I   = struct();
Test.II  = struct();
Test.III = struct();

%% Test I : equalities of the model that shall occur at stationnary state if M >> a, s_i


Test.I_1 = o.lambda * p.M / p.ns;
Test.I_2 = S.e_m(end) * Hillfun(p.vm , p.Km, S.s_i(end),1);
Test.I_3 = S.e_t(end) * Hillfun(p.vt, p.Kt , p.s,1);

if         (abs(Test.I_1 - Test.I_2) / Test.I_1) < delta ...
        & (abs(Test.I_1 - Test.I_3) / Test.I_1) < delta
     Test_I = 'true';
else Test_I = 'false';
end

%% Test II : equality that shall occur at stationnary state
%p.K_gamma = p.gamma_max / p.K.p;
gamma     = Hillfun(p.gamma_max ,p.K_gamma ,  S.a(end),1);
% 
% % for ribosomes
Test.II.r_1 = o.lambda * p.M * o.r_fraction(end);
Test.II.r_2 = ...
    gamma * Hillfun(p.wr , p.theta_r ,  S.a(end),1) * ...
    1 / ( ...
    o.lambda + (o.lambda + p.dm) * (o.lambda + p.k_u + gamma / p.nr) / (p.k_b * S.r(end))...
    ); 

% for protein q
Test.II.q_1 = o.lambda * p.M * o.q_fraction(end);
Test.II.q_2 = ...
    gamma * Hillfun(p.wq ,p.theta_nr ,  S.a(end),1) * Hillfun( 1 , S.q(end) ,  p.Kq,p.hq) * ...
    1 / ( ...
    o.lambda + (o.lambda + p.dm) * (o.lambda + p.k_u + gamma / p.nq) / (p.k_b * S.r(end)) ...
    );

if         (abs(Test.II.r_1 - Test.II.r_2) / Test.II.r_1) < delta ...
        && (abs(Test.II.q_1 - Test.II.q_2) / Test.II.q_1) < delta
     Test_II = 'true';
else Test_II = 'false';
end


%% Test II bis :

% for t and m
Test.II.t_m_bis_1 = ...
    o.t_fraction(end) / ...
    o.m_fraction(end);

Test.II.t_m_bis_2 = ...
    Hill(1 , p.theta_nr , p.wt , S.a(end)) / ...
    Hill(1 , p.theta_nr , p.wm , S.a(end));

% for p and q
Test.II.p_q_bis_1 =0;

Test.II.p_q_bis_2 = 0;
% ...
%     Hill(1 , p.theta_nr , p.wp , S.a(end)) / ...
%     ( ...
%     Hill(1 , p.theta_nr , p.wq , S.a(end)) * ...
%     Hill(p.hq , S.q(end) , 1 , p.Kq) ...
%     ); 

if         abs(Test.II.t_m_bis_1 - 1) < delta ...
        && abs(Test.II.t_m_bis_2 - 1) < delta ...
        && abs(Test.II.p_q_bis_1)     < delta ...
        && abs(Test.II.p_q_bis_2)     < delta
     Test_II_bis = 'true';
else Test_II_bis = 'false';
end

%% Test III :

Test.III = o.r_free_fraction(end) + o.q_fraction(end)  + ...
    o.lambda * ( ...
    (p.Kt + p.s) / ...
    p.s  * ...
    (p.wm / p.wt + 1) * p.nt / ...
    (p.ns * p.vt) + ...
    p.nr / gamma ...
    ); 

if   abs(Test.III - 1) < delta
     Test_III = 'true';
else Test_III = 'false';
end

end

