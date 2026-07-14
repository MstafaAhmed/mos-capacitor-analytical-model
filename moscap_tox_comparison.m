%% Threshold Voltage vs Substrate Doping Concentration
% Ideal MOS Capacitor / Long-Channel MOSFET
% ---------------------------------------------------------
% This script calculates the threshold voltage as a function
% of substrate doping concentration for different oxide thicknesses.
% Equations:
%   phi_F = Vt*ln(N/ni)
%
%   Q_B = sqrt(4*eps_s*q*N*phi_F)
%
%   p-type substrate:
%       VTH = VFB + 2phi_F + QB/Cox
%
%   n-type substrate:
%       VTH = VFB - 2phi_F - QB/Cox
%
% Author: Mostafa Ahmed
% ---------------------------------------------------------

clc;
clear;
close all;

%% Physical Constants

q = 1.602e-19;          % Electron charge (C)
k = 1.38e-23;           % Boltzmann constant (J/K)
T = 300;                % Temperature (K)

Vt = k*T/q;             % Thermal voltage (V)

%% Silicon Properties

eps0 = 8.854e-14;       % Vacuum permittivity (F/cm)

eps_si = 11.8;          % Relative permittivity of silicon
eps_ox = 3.9;           % Relative permittivity of SiO2

eps_s = eps_si*eps0;    % Silicon permittivity (F/cm)
epsox = eps_ox*eps0;    % Oxide permittivity (F/cm)

ni = 1.5e10;            % Intrinsic carrier concentration (cm^-3)

%% Device Parameters

VFB = 0;                % Ideal flat-band voltage (V)

% Oxide thicknesses (cm)
Tox = [20e-7 10e-7 4e-7 2e-7];

% Substrate doping concentration (cm^-3)
doping = logspace(15,18,500);

%% Figure

figure;
hold on;
grid on;
box on;

colors = lines(length(Tox));

legendText = {};

%% Loop over substrate types

for substrateType = 1:2

    if substrateType == 1

        %-------------------------------
        % p-type substrate (NMOS)
        %-------------------------------

        lineStyle = '-';
        substrateName = 'p-sub';

        Na = doping;

        phiF = Vt*log(Na/ni);

    else

        %-------------------------------
        % n-type substrate (PMOS)
        %-------------------------------

        lineStyle = '--';
        substrateName = 'n-sub';

        Nd = doping;

        phiF = Vt*log(Nd/ni);

    end

    %% Loop over oxide thickness

    for i = 1:length(Tox)

        % Oxide capacitance per unit area
        Cox = epsox/Tox(i);

        if substrateType == 1

            % Depletion charge magnitude
            QB = sqrt(4*q*eps_s*Na.*phiF);

            % NMOS threshold voltage
            VTH = VFB + 2*phiF + QB/Cox;

        else

            % Depletion charge magnitude
            QB = sqrt(4*q*eps_s*Nd.*phiF);

            % PMOS threshold voltage
            VTH = VFB - 2*phiF - QB/Cox;

        end

        % Plot
        semilogx(doping,VTH,...
            'Color',colors(i,:),...
            'LineStyle',lineStyle,...
            'LineWidth',2);

        legendText{end+1} = sprintf('T_{ox} = %.0f nm (%s)',...
            Tox(i)*1e7,substrateName);

    end

end

%% Labels

xlabel('Substrate Doping Concentration (cm^{-3})',...
    'FontSize',13,...
    'FontWeight','bold');

ylabel('Threshold Voltage, V_{TH} (V)',...
    'FontSize',13,...
    'FontWeight','bold');

title('Threshold Voltage vs Substrate Doping Concentration',...
    'FontSize',14,...
    'FontWeight','bold');

legend(legendText,...
    'Location','best',...
    'FontSize',10);

set(gca,...
    'FontSize',12,...
    'LineWidth',1.2,...
    'XMinorGrid','on',...
    'YMinorGrid','on');

xlim([1e15 1e18]);