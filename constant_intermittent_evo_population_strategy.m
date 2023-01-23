%s = pars(1); mu = pars(2); sigma_t = pars(3); sigma_k = pars(4); K_m = pars(5); r= pars(6); k= pars(7); d= pars(8);

mu = 0; sigma_k = 10; K_m = 100; r= 0.3; k = 0.1; d = 0.12; %k is sigma_g^2 change to alter between high or low

pars_no_drug = [0, 0, sqrt(6), 10, 100, 0.3, 0.1, 0.12]; %change second last term sigma_g^2 to alter high or low evolvability
pars_chemotherapy = [0.15, 0, sqrt(6), 10, 100, 0.3, 0.1, 0.12];
pars_targeted = [0.3, 0, sqrt(2), 10, 100, 0.3, 0.1, 0.12];


tMax = 6000;
tstep = 100;
tInspect= tstep;
tinitial=1;
t_therapy_on = 600;
init0= [20, 0.01];

Total_iterations= ceil((tMax- t_therapy_on)/tInspect);


xfin = [];
tfin = [];
figure(1);
hold on;
grid on;
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold' )
ylabel("Evolvability: \sigma_{g}^{2}", 'FontSize', 28, 'Fontweight', 'bold')
[t, x] = ode45(@constant_evo_model, [1, t_therapy_on], init0, [], pars_no_drug);

xfin = [xfin; x];
tfin = [tfin; t];
s_array = [];
for j=1:Total_iterations-1
    if mod(j, 2) ==0
       pars = pars_no_drug;
       sigma_t = sqrt(6); %change breadth depending on whether chemo or targeted
       s = 0;
       

    else
       pars = pars_chemotherapy;
       sigma_t = sqrt(6); %change breadth depending on whether chemo or targeted
       s = 0.15; %change efficacy according to chemo or targeted
       
    end
    
    
    %tInspect = min(tInspect + tstep, tMax);
    init_New = [x(end, 1) x(end, 2)];
    [t, x] = ode45(@constant_evo_model, [t_therapy_on, t_therapy_on+ 100], init_New, [], pars);
    t_therapy_on = t_therapy_on + 100;
    
    xfin = [xfin; x(2:end, :)];
    tfin = [tfin; t(2:end)];
    s_array = [s_array; s];
    
end

xfin_v = [];
for i=1:length(xfin)
    xfin_v = [xfin_v; xfin(i,2)];
end

array_k = [];
for i = 1:length(tfin)
    s = 0.15 * mod((floor(max(tfin(i) - 500, 0) / 100)) ,2);
    k = k;
    array_k = [array_k; k];
end

%%%%%% Plotting Evolvability %%%%%%%
plot(tfin, array_k, 'b', 'Linewidth', 6)
legend('Chemotherapy', 'Fontsize', 24, 'Location', 'southeast')
ylim([0 0.5]);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',24)

ax = gca;
ax.GridLineStyle = '-';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;
%hold off


hold off

%%%%%%%% Plotting Strategy %%%%%
figure(2);
hold on;
grid on;
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold' )
ylabel("Strategy: v", 'FontSize', 28, 'Fontweight', 'bold')
plot(tfin, xfin_v, 'b', 'Linewidth', 6)
legend('Chemotherapy', 'Fontsize', 24, 'Location', 'southeast')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',24)
ylim([0 4]);
ax = gca;
ax.GridLineStyle = '-';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;


hold off


%%%%%%%%% Plotting Population %%%%%%%
figure(3);
hold on;
grid on;
title('Intermittent Chemotherapy: Low Evolvability')
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold' )
ylabel("Population Size: x", 'FontSize', 28, 'Fontweight', 'bold')
plot(tfin, xfin(:,1), 'b', 'Linewidth', 6)
legend('Chemotherapy', 'Fontsize', 24, 'Location', 'southeast')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',24)
ylim([0 100]);
ax = gca;
ax.GridLineStyle = '-';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;


hold off

