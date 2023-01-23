s1_no_drug = 0; mu = 0; sigma_t1 = sqrt(6); sigma_k = 10; K_m = 100; r= 0.3; k= 0.3; d = 0.12; %k is sigma_g^2 change when high or low
s2_no_drug = 0.; sigma_t2 = sqrt(2);
s1_chemo = 0.15; s2_chemo = 0;
s1_targeted = 0; s2_targeted = 0.3;

pars_no_drug = [s1_no_drug, mu, sigma_t1, sigma_k, K_m, r, k, d, s2_no_drug, sigma_t2];
pars_chemo = [s1_chemo, mu, sigma_t1, sigma_k, K_m, r, k, d, s2_chemo, sigma_t2];
pars_targeted = [s1_targeted, mu, sigma_t1, sigma_k, K_m, r, k, d, s2_targeted, sigma_t2];

tMax = 2500;
tstep = 100;  %change to 500 if changing time
tInspect= tstep;
tinitial=1;
t_therapy_on = 600;
init0 = [20, 0.01, 0.01];

Total_iterations= ceil((tMax- t_therapy_on)/tInspect);


xfin = [];
tfin = [];

%%%%%%%%% Plotting Population %%%%%%%%%%
figure(1);
hold on;
grid on;
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold' )
ylabel("Population Size: x", 'FontSize', 28, 'Fontweight', 'bold')
ylim([0 100]);
[t, x] = ode45(@double_bind_constant_model, [1, t_therapy_on], init0, [], pars_no_drug);

xfin = [xfin; x];
tfin = [tfin, t];
 
for j=1:Total_iterations
    if mod(j, 2) ==0
        %targeted 2nd
        pars = pars_chemo; %reverse order as needed
            
    else
        %chemo 1st
        pars = pars_targeted;
        
    end
    
   
    init_New = [x(end, 1) x(end, 2) x(end,3)];
    [t, x] = ode45(@double_bind_constant_model, [t_therapy_on, t_therapy_on+ 100], init_New, [], pars); %change to 500 if changing time
    t_therapy_on = t_therapy_on + 100; %change to 500 if changing time
    xfin = [xfin; x(2:end, :)];
    tfin = [tfin; t(2:end)];
end

xfin_x = [];
xfin_x = [xfin_x; xfin(:,1)];
xfin_v1 = [];
xfin_v1 = [xfin_v1; xfin(:,2)];
xfin_v2 = [];
xfin_v2 = [xfin_v2; xfin(:,3)];

for i = 1:length(xfin)
    if xfin_x(i) <= 1
        xfin_x(i:end) = 0;
        %xfin_v1(i:end) = 0;  %do this if you want strategy to go to 0
        %xfin_v2(i:end) = 0;
    end
end

plot(tfin, xfin_x, '-', 'Color', [0.4 0 0.6], 'Linewidth', 6);
title('Double Bind (Cycle Duration = 100 time steps): High Evolvability')
%plot(tfin, xfin_x, ':', 'Color', [0.4 0 0.6], 'Linewidth', 6);
%legend('Chemotherapy first', 'Targeted therapy first', 'Fontsize', 24)

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',24)

ax = gca;
ax.GridLineStyle = '-';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;

%%%%%%% Plotting strategy %%%%%%%

figure(2)
grid on
hold on
ylim([0 4]);
xlabel('Time', 'FontSize', 28, 'Fontweight', 'bold' )
ylabel('Strategy: v_{c} or v_{t}', 'FontSize', 28, 'Fontweight', 'bold' )
plot(tfin, xfin_v1,  '-', 'Color', [0 0 1], 'Linewidth', 6); %chemo first, targeted second
plot(tfin, xfin_v2,  '-', 'Color', [1 0 0], 'Linewidth', 6); % chemo first, targeted second
%plot(tfin, xfin_v1,  ':', 'Color', [1 0 0], 'Linewidth', 6); %targeted first, chemo second
%plot(tfin, xfin_v2,  ':', 'Color', [0 0 1], 'Linewidth', 6); %targeted first, chemo second
hold off

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',24)

ax = gca;
ax.GridLineStyle = '-';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;

%legend('Chemotherapy first', 'Targeted therapy second', 'Targeted therapy first', 'Chemotherapy second','Fontsize', 20, 'Location', 'northwest')

%%%%%% Calcutaing Evolvabilities %%%%%%%%%%%

array_k1 = [];
array_k2 = [];
for i = 1:length(tfin)
    s1 = 0.15 * mod((floor(max(tfin(i) - 100, 0) / 100)) ,2); %change to 500 if changing time
    s2 = 0.3 * mod((floor(max(tfin(i) - 100, 0) / 100)) ,2);
    k1 = k;
    k2 = k;
    array_k1 = [array_k1; k1];
    array_k2 = [array_k2; k2];
end


%%%%%%%%% Plotting chemo evolvability %%%%%%%%%%
figure(3)
hold on;
ylim([0 0.5]);
grid on;
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold' )
ylabel("Evolvability: \sigma_{g_{c}}^{2}", 'FontSize', 28, 'Fontweight', 'bold')

plot(tfin, array_k1, '-', 'Color', [0 0 1], 'Linewidth', 6); %chemo first
plot(tfin, array_k1, ':', 'Color', [0 0 1], 'Linewidth', 6); %chemo second

legend('Chemotherapy first', 'Chemotherapy second', 'Fontsize', 24)

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',24)

ax = gca;
ax.GridLineStyle = '-';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;


%%%%%%%%%%%%% Plotting targeted evolvability %%%%%%%%%
figure(4)
hold on;
grid on;
ylim([0 0.5]);
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold' )
ylabel("Evolvability: \sigma_{g_{t}}^2", 'FontSize', 28, 'Fontweight', 'bold')

plot(tfin, array_k2, '-', 'Color', [1 0 0], 'Linewidth', 6); %targeted first
plot(tfin, array_k2, ':', 'Color', [1 0 0], 'Linewidth', 6); %targeted second

legend('Targeted first', 'Targeted second', 'Fontsize', 24)

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',24)

ax = gca;
ax.GridLineStyle = '-';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;