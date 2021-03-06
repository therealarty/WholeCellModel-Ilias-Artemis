%% define ode options :
tfinal  = 3e3;                              % final time

%% configure integrator (check 'doc ode15s' for more info)
options = odeset('NonNegative',[1:4]);      % ensures variables stay positive 
                                            % (this is not always necessary 
                                            % but can be helpful, but make sure 
                                            % your system is actually a positive system!)

options = odeset(options, 'RelTol', 1e-3,...
                          'AbsTol', 1e-6);  % accuracy of integrator 
                                            % (here set to default values)

%% set parameters

k = struct();


k.s        = 1e4; %nutrient concentration
k.dm       = 0.1;%mRNA degradation rate
k.ns       = 0.5;
k.nr       = 7459;
k.nt       = 300;
k.nm       = 300;
k.nq       = 300;
k.gamma_max = 1260;
k.K_gamma   = 7;
k.vt       = 726;
k.Kt       = 1000;
k.vm        = 5800;
k.Km        = 1000;
k.wr        = 930;
%k.we        = 4.14;
k.wt        = 4.14;
k.wm        = 4.14;
k.wq        = 948.93;
k.theta_r   = 426.87;
k.theta_nr  = 4.38;
k.theta_x   = k.theta_nr;
k.Kq        = 152219;
k.hq        = 4;
k.k_b       = 1;
k.k_u       = 1;
%k.k_cm      = 0.00599;
k.M         = 1e8;



%% set initial values
% 
% s_i       = x(1);
% a         = x(2);
% r         = x(3);
% e_t       = x(4);
% e_m       = x(5);
% q         = x(6);
% m_r       = x(7);
% m_t       = x(8);
% m_m       = x(9);
% m_q       = x(10);
% c_r       = x(11);
% c_t       = x(12);
% c_m       = x(13);
% c_q       = x(14);
X0.s_i = 0;
X0.a   = 0;
X0.r   = 1;
X0.e_t = 1;
X0.e_m = 1;
X0.q = 0;%
X0.m_r = 0;
X0.m_t = 0;
X0.m_m = 0;
X0.m_q = 0;
X0.c_r = 0;
X0.c_t = 0;
X0.c_m = 0;
X0.c_q = 0;

stateNames={'s_i','a','r','e_t','e_m','q','m_r','m_t','m_m','m_q','c_r','c_t','c_m','c_q','\lambda','M'};

x0 = [X0.s_i ;X0.a   ;X0.r ;X0.e_t ;X0.e_m;X0.q ;X0.m_r ;X0.m_t ;X0.m_m ;X0.m_q ;X0.c_r ;X0.c_t ;X0.c_m ;X0.c_q ];

%% simulate
[t,result] = ode15s(@(t,result) model_ode(t,result,k),[0,tfinal],x0,options);

%% rename variables
Tlambda=ComputeLambda(result(:,2),result(:,3),result(:,4),result(:,5),result(:,6),result(:,11),result(:,12),result(:,13),result(:,14),k);
result(:,15)=Tlambda;
TM=ComputeM(result(:,3),result(:,4),result(:,5),result(:,6),result(:,11),result(:,12),result(:,13),result(:,14),k);
result(:,16)=TM;

figure;
for va=1:16
    subplot(4,4,va)
    plot(t,result(:,va))
    legend(stateNames{va})
    
end



o.lambda=Tlambda;
SumCx=(S.c_m+S.c_q+S.c_r+S.c_t);
o.t_fraction=S.c_t./SumCx;
o.m_fraction=S.c_m./SumCx;

o.r_free_fraction=S.r./(SumCx+S.r);
o.q_fraction=S.c_q./SumCx;
o.r_fraction=S.c_r./SumCx;


%% Tests

%create state struct
S=struct;
for st=1:14
    
    eval(strcat('S.',stateNames{st},'=result(:,',num2str(st),');'));
end


[delta12,delta23,delta13]=Test1(Tlambda(end),result(end,1),result(end,5),result(end,4),k)

