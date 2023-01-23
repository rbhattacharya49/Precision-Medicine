pars_no_drug = [0, 0, sqrt(6), 10, 100, 0.3, 0, 0.12];
pars_chemotherapy = [0.15, 0, sqrt(6), 10, 100, 0.3, 1.67, 0.12];
pars_targeted = [0.3, 0, sqrt(2), 10, 100, 0.3, 0.84, 0.12];

tMax = 6000;
tstep = 100; 
tInspect= tstep;
tinitial=1;
t_therapy_on = 600;
init0= [20, 0.01];

Total_iterations= ceil((tMax- t_therapy_on)/tInspect);


xfin = [];
tfin = [];
figure(4);
hold on;
grid on;
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold' )
ylabel("Evolvability: \sigma_{g}^{2}", 'FontSize', 28, 'Fontweight', 'bold')
ylim([0 0.5]);
[t, x] = ode45(@faculatative_evo_model, [1, t_therapy_on], init0, [], pars_no_drug);

xfin = [xfin; x];
tfin = [tfin; t];
s_array = [];
for j=1:Total_iterations-1
    if mod(j, 2) ==0
       pars = pars_no_drug;
       
    else
       pars = pars_chemotherapy; %change to pars_targeted when needed
       
       
    end
    
    init_New = [x(end, 1) x(end, 2)];
    [t, x] = ode45(@faculatative_evo_model, [t_therapy_on, t_therapy_on+ 100], init_New, [], pars);
    t_therapy_on = t_therapy_on + 100;
    
    xfin = [xfin; x(2:end, :)];
    tfin = [tfin; t(2:end)];
    
end

xfin_v = [];
for i=1:length(xfin)
    xfin_v = [xfin_v; xfin(i,2)];
end

s = pars_targeted(1); mu = pars_targeted(2); sigma_t = pars_targeted(3); sigma_k = pars_targeted(4); K_m = pars_targeted(5); r= pars_targeted(6); k_r = pars_targeted(7); d = pars_targeted(8);
interval_size = tstep;
array_k = [];
for i = 1:length(tfin)
    s = 0.3 * mod((floor(max(tfin(i) - (600 - interval_size), 0) / 100)) ,2);
    k = 0.05 + k_r*s*exp((-(xfin_v(i) - mu)^2)/(sigma_t^2));
    array_k = [array_k; k];
end

plot(tfin, array_k, 'b', 'Linewidth', 6)
legend('Chemotherapy', 'Fontsize', 24, 'Location', 'northeast')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',24)

ax = gca;
ax.GridLineStyle = '-';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;

hold off
