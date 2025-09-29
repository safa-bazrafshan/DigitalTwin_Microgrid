%% Battery Parameters
Capacity = 5;          % Battery capacity in Ah
V_nom = 12;            % Nominal voltage (V)
SOC = 50;              % Initial state of charge (%)
I_charge = 2;          % Charging current (A)
I_discharge = 1.5;     % Discharging current (A)
dt = 1;                % Time step (s)
time = 0:dt:3600;      % 1 hour simulation

%% Initialize SOC array
SOC_array = zeros(size(time));
SOC_array(1) = SOC;

%% Simulate charge/discharge
for t = 2:length(time)
    if mod(t, 600) < 300
        SOC_array(t) = SOC_array(t-1) + (I_charge*dt/Capacity)*100;
    else
        SOC_array(t) = SOC_array(t-1) - (I_discharge*dt/Capacity)*100;
    end
    
    % Limit SOC to 0-100%
    SOC_array(t) = max(0, min(100, SOC_array(t)));
end

%% Plot SOC over time
figure;
plot(time/60, SOC_array, 'LineWidth', 2);
xlabel('Time (min)');
ylabel('State of Charge (%)');
title('Battery SOC Simulation');
grid on;
