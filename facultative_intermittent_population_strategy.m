%s = pars(1); mu = pars(2); sigma_t = pars(3); sigma_k = pars(4); K_m =
%pars(5); r= pars(6); k_r = pars(7); d = pars(8)

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
ylabel("Population Size: x", 'FontSize', 28, 'Fontweight', 'bold') %change to population when needed
[t, x] = ode45(@faculatative_evo_model, [1, t_therapy_on], init0, [], pars_no_drug);

xfin = [xfin; x];
tfin = [tfin, t];
 
for j=1:Total_iterations-1
    if mod(j, 2) ==0
       pars = pars_no_drug;
           
    else
       pars = pars_chemotherapy;
    end
    
  
    init_New = [x(end, 1) x(end, 2)];
    [t, x] = ode45(@faculatative_evo_model, [t_therapy_on, t_therapy_on+ 100], init_New, [], pars);
    t_therapy_on = t_therapy_on + 100;
    xfin = [xfin; x(2:end, :)];
    tfin = [tfin; t(2:end)];
end

xfin_x = [];
xfin_x = [xfin_x; xfin(:,1)];
xfin_v = [];
xfin_v = [xfin_v; xfin(:,2)];

for i = 1:length(xfin)
    if xfin_x(i) < 1.5
        xfin_x(i:end) = 0;
        xfin_v(i:end) = 0;
    end
end

%plot(tfin, xfin(:,1), 'b', 'Linewidth', 6);
plot(tfin, xfin(:,1), 'b', 'Linewidth', 6); %1 is population, 2 is strategy
ylim([0 100]); %change limit accordingly
legend('Chemotherapy', 'Fontsize', 24, 'Location', 'southeast')
title('Intermittent Chemotherapy: Facultative Evolvability')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',24)

ax = gca;
ax.GridLineStyle = '-';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;


hold off;