function [ Test_I , Test_II , Test_II_bis , Test_III ] = Tests( S , o , p)
% This function realizes four tests. If one of those test is wrong it means
% that the core model is not implemnted correctly. The tests come from the
% derivation in the paper's supplementary informations in which the model is
% described

delta = 0.01; % tolerance

%% Tests

Test     = struct();
Test.I   = struct();
Test.II  = struct();
Test.III = struct();

%% Test I : equalities of the model that shall occur at stationnary state if M >> a, s_i


Test.I_1 = o.lambda * p.M / p.n_s;
Test.I_2 = S.e_m(end) * Hill(1 , p.K.m , p.v.m , S.s_i(end));
Test.I_3 = S.e_t(end) * Hill(1 , p.K.t , p.v.t , p.s_0);

if         (abs(Test.I_1 - Test.I_2) / Test.I_1) < delta ...
        && (abs(Test.I_1 - Test.I_3) / Test.I_1) < delta
     Test_I = 'true';
else Test_I = 'false';
end

%% Test II : equality that shall occur at stationnary state

p.K.gamma = p.gamma_max / p.K.p;
gamma     = Hill(1 , p.K.gamma , p.gamma_max , S.a(end));

% for ribosomes
Test.II.r_1 = o.lambda * p.M * o.r_fraction(end);
Test.II.r_2 = ...
    gamma * Hill(1 , p.theta.r , p.w.r , S.a(end)) * ...
    1 / ( ...
    o.lambda + (o.lambda + p.d.m.r) * (o.lambda + p.k.u.r + gamma / p.n.r) / (p.k.b.r * S.e_r(end))...
    ); 

% for protein q
Test.II.q_1 = o.lambda * p.M * o.q_fraction(end);
Test.II.q_2 = ...
    gamma * Hill(1 , p.theta.q , p.w.q , S.a(end)) * Hill(p.alpha_q , S.e_q(end) , 1 , p.K.q) * ...
    1 / ( ...
    o.lambda + (o.lambda + p.d.m.q) * (o.lambda + p.k.u.q + gamma / p.n.q) / (p.k.b.q * S.e_r(end)) ...
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
    Hill(1 , p.theta.t , p.w.t , S.a(end)) / ...
    Hill(1 , p.theta.m , p.w.m , S.a(end));

% for p and q
Test.II.p_q_bis_1 = ...
    o.p_fraction(end) / ...
    o.q_fraction(end);

Test.II.p_q_bis_2 = ...
    Hill(1 , p.theta.p , p.w.p , S.a(end)) / ...
    ( ...
    Hill(1 , p.theta.q , p.w.q , S.a(end)) * ...
    Hill(p.alpha_q , S.e_q(end) , 1 , p.K.q) ...
    ); 

if         abs(Test.II.t_m_bis_1 - 1) < delta ...
        && abs(Test.II.t_m_bis_2 - 1) < delta ...
        && abs(Test.II.p_q_bis_1)     < delta ...
        && abs(Test.II.p_q_bis_2)     < delta
     Test_II_bis = 'true';
else Test_II_bis = 'false';
end

%% Test III :

Test.III = o.r_free_fraction(end) + o.q_fraction(end) + o.p_fraction(end) + ...
    o.lambda * ( ...
    (p.K.t + p.s_0) / ...
    p.s_0  * ...
    (p.w.m / p.w.t + 1) * p.n.t / ...
    (p.n_s * p.v.t) + ...
    p.n.r / gamma ...
    ); 

if   abs(Test.III - 1) < delta
     Test_III = 'true';
else Test_III = 'false';
end

end

