clc;
clear;
close all;

%% Constants
q      = 1.6e-19;      % C
T      = 300;          % K
kb     = 1.38e-23;      % J/K
Vt     = kb*T/q;        % V, thermal voltage
eps0   = 8.85e-14;      % F/cm
eps_si = 11.8;
eps_ox = 3.9;
epsS   = eps_si*eps0;   % F/cm
epsOx  = eps_ox*eps0;   % F/cm

Na  = 4e15;             % cm^-3, substrate doping (p-type)
ni  = 1.5e10;           % cm^-3, intrinsic concentration
Tox = 2e-7;             % cm, oxide thickness
Cox = epsOx/Tox;        % F/cm^2

%% Fermi potential
phiF = Vt*log(Na/ni);

%% Surface potential sweep (psi = 0 included to avoid a gap at flatband)
psi = [-0.4:1e-4:-1e-4, 0, 1e-4:1e-3:1];

%% Exact semiconductor charge (Taur & Ning formulation)
% F(psi) >= 0 for all psi, sign of Qs carries the physics:
%   psi < 0 (accumulation)      -> Qs > 0  (excess holes, positive charge)
%   psi > 0 (depletion/inversion) -> Qs < 0  (ionized acceptors / electrons, negative charge)
F = (exp(-psi/Vt) + psi/Vt - 1) + (ni^2/Na^2).*(exp(psi/Vt) - psi/Vt - 1);

Qs = -sign(psi).*sqrt(2*q*Vt*epsS*Na).*sqrt(F);

%% Gate voltage
Vfb = 0;   % simplification: neglects metal-semiconductor work function difference and oxide charge
Vg  = Vfb + psi - Qs/Cox;

%% Charge components (vectorized)
Qacc = zeros(size(psi));
QB   = zeros(size(psi));
Qinv = zeros(size(psi));

QBmax = -sqrt(4*q*epsS*Na*phiF);   % depletion charge at onset of strong inversion (psi = 2*phiF)

accMask  = psi < 0;
depMask  = (psi >= 0) & (psi <= 2*phiF);
invMask  = psi > 2*phiF;

Qacc(accMask) = Qs(accMask);
QB(depMask)   = -sqrt(2*q*epsS*Na*psi(depMask));
QB(invMask)   = QBmax;
Qinv(invMask) = Qs(invMask) - QBmax;

%% Figure 1 : Accumulation
figure
plot(Vg,Qacc,'b','LineWidth',2.5)
grid on
box on
xlabel('Gate Voltage (V)')
ylabel('Q_{acc} (C/cm^2)')
title('Accumulation Charge')

%% Figure 2 : Bulk charge
figure
plot(Vg,QB,'r','LineWidth',2.5)
grid on
box on
xlabel('Gate Voltage (V)')
ylabel('Q_B (C/cm^2)')
title('Bulk (Depletion) Charge')

%% Figure 3 : Inversion charge
figure
plot(Vg,Qinv,'g','LineWidth',2.5)
grid on
box on
xlabel('Gate Voltage (V)')
ylabel('Q_{inv} (C/cm^2)')
title('Inversion Charge')

%% Figure 4 : Total charge (linear scale, all components)
figure
hold on
plot(Vg,Qacc,'b','LineWidth',2.5)
plot(Vg,QB,'r','LineWidth',2.5)
plot(Vg,Qinv,'g','LineWidth',2.5)
plot(Vg,Qs,'k','LineWidth',2.5)
grid on
box on
xlabel('Gate Voltage (V)')
ylabel('Charge Density (C/cm^2)')
title('MOS Capacitor Charge Components')
legend('Q_{acc}','Q_B','Q_{inv}','Q_s','Location','Best')

%% Figure 5 : |Qs| vs surface potential (log scale)
% semilogy cannot plot negative values (Qs < 0 for psi > 0), so use abs(Qs).
% Sign convention: Qs > 0 for psi < 0 (accumulation), Qs < 0 for psi > 0 (depletion/inversion).
figure
semilogy(psi,abs(Qs),'k','LineWidth',2.5)
grid on
box on
xlabel('Surface Potential, \psi_s (V)')
ylabel('|Q_s| (C/cm^2)')
title('Semiconductor Charge vs Surface Potential')
legend('|Q_s|','Location','Best')

%% Figure 6 : |Qs| vs gate voltage (log scale)
figure
semilogy(Vg,abs(Qs),'g','LineWidth',2.5)
grid on
box on
xlabel('Gate Voltage (V)')
ylabel('|Q_s| (C/cm^2)')
title('Semiconductor Charge vs Gate Voltage')
legend('|Q_s|','Location','Best')