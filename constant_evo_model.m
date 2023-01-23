function ydot = constant_evo_model(t,y,pars)

x = y(1);
v = y(2);

%s, mu, sigma_t, sigma_k, K_m, r, k

s = pars(1); mu = pars(2); sigma_t = pars(3); sigma_k = pars(4); K_m = pars(5); r= pars(6); k= pars(7); d= pars(8);

G = (r*(K_m*(exp( -v^2/sigma_k^2)) - x))/ (K_m*(exp( -v^2/sigma_k^2))) - s*exp( -((v - mu)^2)/ sigma_t^2) - (d*k) ;

dG = (2*s*(v - mu)*exp(-((v - mu)^2)/ sigma_t^2))/(sigma_t^2) + (2*r*v*((K_m*exp(-v^2/sigma_k^2) - x)*exp(v^2/sigma_k^2))/(K_m*sigma_k^2)) - 2*r*v/sigma_k^2;

dx = x*G;
dv = k*dG;


ydot= [dx; dv];