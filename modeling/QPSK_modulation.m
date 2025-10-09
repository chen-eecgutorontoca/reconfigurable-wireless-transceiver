%QPSK Modulation matlab model
%B Chen
%Last Updated 9/25/2025


%%------------------Setup--------------------------%%
data = [1 0 1 1 0 1 1 0 1 0 1 1 0 1 0 0 1 1 0 0 1 0];
N = length(data);

fc = 30e6 ;       %carrier frequency
br = 1e6;         % bit rate = 1 Mbps
Tb = 1/br;        % bit duration

I = zeros(1,N/2) ;      %Inphase component
Q = zeros(1,N/2);       %Quadrature component


%%-------------Serial to Parallel---------------%%
data_reshape = reshape(data,2,N/2)';  %pair 2 bits to form a symbol
disp(data_reshape);


%%-------------Mapper---------------------------%%
for k = 1:N/2
    bits = data_reshape(k,:);
    if isequal(bits,[0 0]), I(k)= 1; Q(k)= 1;
    elseif isequal(bits,[0 1]), I(k)=-1; Q(k)= 1;
    elseif isequal(bits,[1 1]), I(k)=-1; Q(k)=-1;
    elseif isequal(bits,[1 0]), I(k)= 1; Q(k)=-1;
    end
 fprintf('Symbol %d (%d%d): I = %d, Q = %d\n', k, bits(1), bits(2), I(k), Q(k));
end

%%------------Frequency Synthesis---------------%%
rolloff = 0.35;
span = 4;
sps = 3;

h1 = rcosdesign(rolloff,span,sps,"sqrt");      %RRC Filter
disp(h1);
impz(h1);

I_up = upfirdn(I, h1, sps);             
Q_up = upfirdn(Q, h1, sps);

Fs = sps * (br/2);             % sample frequency (Hz)
t  = (0:length(I_up)-1)/Fs;    % time vector (s)

Tx_sig = I_up .* cos(2*pi*fc*t) + Q_up .* sin(2*pi*fc*t);

%------------Plot Signals---------------
Fs = sps * (br/2);            
tt = (0:length(I_up)-1)/Fs;   % matches I_up/Q_up
t  = (0:length(Tx_sig)-1)/Fs; % matches Tx_sig

figure;
subplot(3,1,1);
plot(tt, I_up,'b','LineWidth',1.5); grid on;
title('In-phase Component (I)');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,2);
plot(tt, Q_up,'r','LineWidth',1.5); grid on;
title('Quadrature Component (Q)');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,3);
plot(t, Tx_sig,'k','LineWidth',1.5); grid on;
title('QPSK Transmit Signal (I+Q)');
xlabel('Time (s)'); ylabel('Amplitude');

% Constellation
figure;
plot(I, Q,'o','MarkerFaceColor','b','MarkerSize',8);
grid on; axis([-1.5 1.5 -1.5 1.5]);
title('QPSK Constellation Diagram');
xlabel('In-phase (I)'); ylabel('Quadrature (Q)');
