%% juice

x=[1:5];
y=[0.021 0.098 0.415 6.062 92.43];


funct = fit(x',y','exp1')

n=6;
time=funct(n)

%% step 2 HPC
% for n_pl = 4 and v_inf 3:1:15 = 13, E3 to J*

x=[1085 20586 347626 5.85E6];
y=[0.460858 3.246375 59.376564 1049.367547];


funct = fit(x',y','poly1')

n=4000000;
time=funct(n)

%% step 2 PC
% for n_pl = 4 and v_inf 3:1:15 = 13, E3 to J*

x=[1085 20465 336823 5.51E6];
y=[0.5 3.1 54.2 895];


funct = fit(x',y','poly1')

n=4000000;
time=funct(n)


%% step 1 PC JUICE
% v_inf 3:.5:15, E3:.5:6 to J*

x=[1:5];
y=[0.009844 0.086298 3.258396 130.152864 3441.916619];

plot(x',y')
functnn = fit(x',y','exp1')
coeffvalues(functnn)

n=6;
time=functnn(n)/3600


