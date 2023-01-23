function ydot = double_bind_facultative_model(t,y,pars)

x = y(1);
v1 = y(2);
v2 = y(3);

%s, mu, sigma_t, sigma_k, K_m, r, k_r, d

s1 = pars(1); mu1 = pars(2); sigma_t1 = pars(3); sigma_k1 = pars(4); K_m = pars(5); r= pars(6); k_r1= pars(7); d1 = pars(8);
s2 = pars(9); mu2 = pars(10); sigma_t2 = pars(11); sigma_k2 = pars(12); k_r2= pars(13); d2 = pars(14); %sigma_1 = pars(15); delta_1 = pars(16);
%sigma_2 = pars(17); delta_2 = pars(18);

G = (r/(K_m*exp(-(v1^2/sigma_k1^2)- v2^2/sigma_k2^2)))*((K_m*exp(-(v1^2/sigma_k1^2)- v2^2/sigma_k2^2)) - x) - s1*exp(-(v1-mu1)^2/sigma_t1^2) - d1*(k_r1*s1*exp(-(v1-mu1)^2/sigma_t1^2)+0.02) - s2*exp(-(v2-mu2)^2/sigma_t2^2) - d2*(k_r2*s2*exp(-(v2-mu2)^2/sigma_t2^2)+0.02);

dGdv1 = (-2*exp(-(v1-mu1)^2/sigma_t1^2)*(r*sigma_t1^2*x*v1*exp(((v1-mu1)^2/sigma_t1^2) + v1^2/sigma_k1^2 + v2^2/sigma_k2^2)+(-d1*K_m*k_r1-K_m)*s1*sigma_k1^2*v1+(d1*K_m*k_r1+K_m)*mu1*s1*sigma_k1^2))/(K_m*sigma_k1^2*sigma_t1^2);

dGdv2 = (-2*exp(-(v2-mu2)^2/sigma_t2^2)*(r*sigma_t2^2*x*v2*exp(((v2-mu2)^2/sigma_t2^2) + v2^2/sigma_k2^2 + v1^2/sigma_k1^2)+(-d2*K_m*k_r2-K_m)*s2*sigma_k2^2*v2+(d2*K_m*k_r2+K_m)*mu2*s2*sigma_k2^2))/(K_m*sigma_k2^2*sigma_t2^2);


dx = x*G;
% dv1 = k_r1*(0.05 + s1*exp(-(v1-mu1)^2/sigma_t1^2))*dGdv1 - 0.001*(k_r2*(0.05 + s2*exp(-(v2-mu2)^2/sigma_t2^2))*dGdv2);
% dv2 = k_r2*(0.05 + s2*exp(-(v2-mu2)^2/sigma_t2^2))*dGdv2 - 0.001*(k_r1*(0.05 + s1*exp(-(v1-mu1)^2/sigma_t1^2))*dGdv1);

dv1 = (0.05 + k_r1*(s1*exp(-(v1-mu1)^2/sigma_t1^2)))*dGdv1 - 0.001*(0.05 + k_r2*(s2*exp(-(v2-mu2)^2/sigma_t2^2)))*dGdv2;
dv2 = (0.05 + k_r2*(s2*exp(-(v2-mu2)^2/sigma_t2^2)))*dGdv2 - 0.001*(0.05 + k_r1*(s1*exp(-(v1-mu1)^2/sigma_t1^2)))*dGdv1;



% dv1 = (k_r1*(s1*exp(-(v1-mu1)^2/sigma_t1^2)+0.02)*dGdv1 - (0.5^2*k_r2*s2*exp(-(v2-mu2)^2/sigma_t2^2)+0.02)*dGdv2;
% dv2 = (k_r2*s2*exp(-(v2-mu2)^2/sigma_t2^2)+0.02)*dGdv2 - (0.5^2*k_r1*s1*exp(-(v1-mu1)^2/sigma_t1^2)+0.02)*dGdv1;



% dv1 = (k_r1*(s1*exp(-(v1-mu1)^2/sigma_t1^2)+0.01)*dGdv1 - 0.2*(k_r2*(s2*exp(-(v2-mu2)^2/sigma_t2^2)+0.01)*dGdv2;
% dv2 = (k_r2*(s2*exp(-(v2-mu2)^2/sigma_t2^2)+0.01)*dGdv2 - 0.2*(k_r1*(s1*exp(-(v1-mu1)^2/sigma_t1^2)+0.01)*dGdv1;



ydot= [dx; dv1; dv2];