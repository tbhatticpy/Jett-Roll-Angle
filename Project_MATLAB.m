clc
clear all
%Matrices for the constrction of open loop transfer function
A = [-0.254 0 -1 0.182; -15.969 -8.395 2.19 0; 4.549 -0.349 -0.76 0; 0 1 0 0];
B = [0; -28.916; -0.224; 0];
C = [0 0 0 1];
D = [0];
system = ss(A,B,C,D);
fprintf('\nOpen loop transfer function');
sys = tf(system)
fprintf('\n----------------------------------------');
fprintf('\nUncompensated System');
stepinfo(sys) %get transient response of open loop tf
steady_state_error = abs(1-dcgain(sys)) %get steady state error of open loop tf
%pidTuner(sys);
zero_loc_pi = -2.068; %set zero location for pi
zero_loc_pd = -5.76; %set zero location for pd
pos=10; %required percentage overshoot
fprintf('\n----------------------------------------');
fprintf('\nValue of Zeta');
z=-log(pos/100)/sqrt(pi^2+(log(pos/100))^2) %get required zeta
fprintf('\n----------------------------------------');
compensator = zpk([zero_loc_pi, zero_loc_pd],0,1); %compensator consisting of PI and PD
fprintf('\nPID parameters');
%get values of gains
Kd = -0.57101
Kp = -4.5385
Ki = -6.9487     
fprintf('\n----------------------------------------');
tf_2= zpk([],[],Kp) %get propotional gain tf
tf_3=zpk([],0,Ki) %get Ki gain tf
tf_4=zpk(0,[],Kd) %get Kd gain tf
tf_5=parallel(parallel(tf_2,tf_3),tf_4)
fprintf('\nClosed loop transfer function');
closed_tf=feedback(series(tf_5,sys),1) %get closed loop tf
fprintf('\n----------------------------------------');
fprintf('\nCompensated System');
stepinfo(closed_tf) %get transient response of closed loop tf
steady_state_error=abs(1-dcgain(closed_tf)) %get steady state error of closed loop tf
fprintf('\n----------------------------------------');
figure(1)
rlocus(sys);
title('Uncompensated System Root Locus');
figure(2)
step(sys)
title('Uncompensated System Step Response');
figure(3)
rlocus(closed_tf)
title('Compensated System Root Locus');
figure(4)
step(closed_tf)
title('Compensated System Step Response');
