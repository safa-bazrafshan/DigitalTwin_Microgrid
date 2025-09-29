%% Solar Panel Parameters
Voc = 37.0;       % Open-circuit voltage (V)
Isc = 8.21;       % Short-circuit current (A)
Ns = 36;          % Number of cells in series
T = 298;          % Temperature (K)
G = 1000;         % Irradiance (W/m^2)

%% Voltage Array
V = linspace(0, Voc, 100);

%% Solar Panel I-V Characteristic (Simplified)
I = Isc*(1 - V/Voc);

%% Plot
figure;
plot(V, I, 'LineWidth', 2);
xlabel('Voltage (V)');
ylabel('Current (A)');
title('Solar Panel I-V Characteristic');
grid on;
