clc;
clear;
close all;

%% ===========================
% Physical Constants
% ===========================

q  = 1.602e-19;          % Electron charge (C)
k  = 1.38e-23;           % Boltzmann constant (J/K)
T  = 300;                % Temperature (K)

VT = k*T/q;              % Thermal voltage (V)

%% ===========================
% Material Properties
% ===========================

eps0   = 8.854e-14;      % Vacuum permittivity (F/cm)

eps_si = 11.8;           % Silicon
eps_ox = 3.9;            % SiO2

epsS  = eps_si*eps0;     % Silicon permittivity (F/cm)
epsOx = eps_ox*eps0;     % Oxide permittivity (F/cm)

ni = 1.5e10;             % Intrinsic concentration (cm^-3)

%% ===========================
% Device Parameters
% ===========================

NA  = 4e15;            % p-type doping (cm^-3)

VFB = 0;                 % Ideal MOS capacitor

%% Fermi potential

phiF = VT*log(NA/ni);

%% Surface potential

psi = linspace(0,1.0,1000);

%% Exact semiconductor charge function

F = exp(-psi/VT) + psi/VT - 1 + ...
    (ni/NA)^2 .* (exp(psi/VT) - psi/VT - 1);

F(F<0) = 0;

Qs = -sqrt(2*q*epsS*VT*NA).*sqrt(F);

%% Oxide thicknesses

Tox = [10e-7 6e-7 4e-7 2e-7];      % cm
Color = {'b','r','g','k'};

%% Plot

figure
hold on
grid on
box on

for i = 1:length(Tox)

    Cox = epsOx/Tox(i);

    %% Gate voltage

    VG = VFB + psi - Qs/Cox;

    plot(VG,psi,...
        'Color',Color{i},...
        'LineWidth',2);

end

%% Strong inversion

plot(xlim,[2*phiF 2*phiF],...
    'm--','LineWidth',1.5)

text(min(xlim)+0.05,...
    2*phiF+0.02,...
    '2\phi_F',...
    'Color','m',...
    'FontSize',11)

%% Labels

xlabel('Gate Voltage, V_G (V)',...
    'FontSize',12)

ylabel('Surface Potential, \psi_s (V)',...
    'FontSize',12)

title('Gate Voltage vs Surface Potential',...
    'FontSize',13)

legend('T_{ox}=10 nm',...
       'T_{ox}=6 nm',...
       'T_{ox}=4 nm',...
       'T_{ox}=2 nm',...
       'Location','SouthEast')