function ydot = faculatative_evo_model(t,y,pars)

x = y(1);
v = y(2);


%s, mu, sigma_t, sigma_k, K_m, r, k_r, d

s = pars(1); mu = pars(2); sigma_t = pars(3); sigma_k = pars(4); K_m = pars(5); r= pars(6); k_r= pars(7); d = pars(8);

G = (r/(K_m*exp(-(v^2/sigma_k^2))))*((K_m*exp(-(v^2/sigma_k^2))) - x) - s*exp(-(v-mu)^2/sigma_t^2) - d*k_r*s*exp(-(v-mu)^2/sigma_t^2);

dG = ((2*(d*k_r +1)*s*(v - mu)*exp(-((v-mu)^2)/sigma_t^2))/sigma_t^2) - (2*r*v*x*exp(-v^2/sigma_k^2))/(K_m*sigma_k^2);

dx = x*G;
dv = (0.05 + k_r*(s*exp(-(v-mu)^2/sigma_t^2)))*dG;





ydot= [dx; dv];