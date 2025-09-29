%% Parameters
Voc = 37; Isc = 8.21; Capacity = 5; SOC = 50; V_nom = 12; dt = 1;
time = 0:dt:3600; 
Load_current = 2 + sin(time/3600*2*pi); 
SOC_array = zeros(size(time)); SOC_array(1) = SOC;
Solar_current = Isc * (1 - (0:dt:3600)/3600);
Battery_current = zeros(size(time));
SOC_upper = 90; SOC_lower = 20;

%% Simulation loop with control
for t = 2:length(time)
    Net_current = Solar_current(t) - Load_current(t);
    if Net_current > 0 && SOC_array(t-1) < SOC_upper
        Battery_current(t) = -Net_current;
    elseif Net_current < 0 && SOC_array(t-1) > SOC_lower
        Battery_current(t) = -Net_current;
    else
        Battery_current(t) = 0;
    end
    SOC_array(t) = SOC_array(t-1) + (Battery_current(t)*dt/Capacity)*100;
    SOC_array(t) = max(0, min(100, SOC_array(t)));
end

%% Create figure for dashboard
figure('Name','Microgrid Dashboard','NumberTitle','off','Position',[100 100 1000 600]);

subplot(2,2,1);
plot(time/60, SOC_array,'LineWidth',2); grid on;
xlabel('Time (min)'); ylabel('Battery SOC (%)'); title('Battery SOC');

subplot(2,2,2);
plot(time/60, Load_current,'LineWidth',2); hold on;
plot(time/60, Solar_current,'LineWidth',2);
plot(time/60, Battery_current,'LineWidth',2); grid on;
xlabel('Time (min)'); ylabel('Current (A)');
title('Currents'); legend('Load','Solar','Battery');

subplot(2,2,3);
V = linspace(0, Voc, 100);
I = Isc*(1 - V/Voc);
plot(V,I,'LineWidth',2); grid on;
xlabel('Voltage (V)'); ylabel('Current (A)');
title('Solar Panel I-V Curve');

subplot(2,2,4);
bar([SOC_array(end), SOC_upper, SOC_lower]);
ylabel('SOC (%)'); title('SOC Overview');
set(gca,'XTickLabel',{'Current','Upper','Lower'});
grid on;

