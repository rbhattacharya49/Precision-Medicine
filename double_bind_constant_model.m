function ydot = double_bind_constant_model(t,y,pars)

x = y(1);
v1 = y(2);
v2 = y(3);

%s, mu, sigma_t, sigma_k, K_m, r, k_r, d

s1 = pars(1); mu = pars(2); sigma_t1 = pars(3); sigma_k = pars(4); K_m = pars(5); r= pars(6); k= pars(7); d = pars(8);
s2 = pars(9); sigma_t2 = pars(10);


G = (r/(K_m*exp(-(v1^2/sigma_k^2)- v2^2/sigma_k^2)))*((K_m*exp(-(v1^2/sigma_k^2)- v2^2/sigma_k^2)) - x) - s1*exp(-(v1-mu)^2/sigma_t1^2) - d*k - s2*exp(-(v2-mu)^2/sigma_t2^2) - d*k;

dGdv1 = (-2*exp(-(v1-mu)^2/sigma_t1^2)*(r*sigma_t1^2*x*v1*exp(((v1-mu)^2/sigma_t1^2) + v1^2/sigma_k^2 + v2^2/sigma_k^2)-K_m*s1*sigma_k^2*v1 +K_m*mu*s1*sigma_k^2))/(K_m*sigma_k^2*sigma_t1^2);
dGdv2 = (-2*exp(-(v2-mu)^2/sigma_t2^2)*(r*sigma_t2^2*x*v2*exp(((v2-mu)^2/sigma_t2^2) + v1^2/sigma_k^2 + v2^2/sigma_k^2)-K_m*s2*sigma_k^2*v2 +K_m*mu*s2*sigma_k^2))/(K_m*sigma_k^2*sigma_t2^2);


dx = x*G;
dv1 = k*dGdv1 - 0.001*k*dGdv2;
dv2 = k*dGdv2 - 0.001*k*dGdv1;

ydot= [dx; dv1; dv2];