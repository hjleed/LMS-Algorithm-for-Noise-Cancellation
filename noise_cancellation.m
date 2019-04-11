%% project for ELG-5377, Fall 2014 by Hitham Jleed
close all; clear all;
fs=12000;                         % Sampling frequency 
fN=21;                            % Transversal filter length
%% getting sound
% download from: http://hjleed.webs.com/sounds/satisfying.wav
wen=wavread('satisfying.wav')';   % read the original signal
sound(wen,fs)                     % play original sound
N=length(wen);                    % length of signal
tn=0:1:N;
t=tn/fs;
%% generate noise
x=randn(1,N);                     % Reference noise
n=filter([0 0 0 0 0 0.5],1,x);    % noise signal
%% add noise to signal
d=wen+n;                          % primary signal
sound(d,fs)                       % play noisy sound
%wavwrite(d,fs,'noisy_sound');
%% initial parameters
mu=0.002;
w=zeros(1,fN);                    % initial filter's taps
y=zeros(1,N);                     % initial output
e=y;                              % initial error
%% doing the iterations
for m=fN+1:1:length(t)-1         %% updating 
    sum=0;
    for i=1:1:fN                 %% computing error
        sum=sum+w(i)*x(m-i);
    end
    y(m)=sum;
    e(m)=d(m)-y(m);
    for i=1:1:21                %% computing filter weights
        w(i)=w(i)+2*mu*e(m)*x(m-i);
    end
end
sound(e,fs)                      % play filtered sound
perf = mse(e-wen);               % calculate mean square error
%wavwrite(e,fs,'filtered_sound');
%% calculate spectrum parameters
f=[0:1:N/2]*fs/N;
WEN=2*abs(fft(wen))/length(wen); WEN(1)=WEN(1)/2;
D=2*abs(fft(d))/length(d); D(1)=D(1)/2;
E=2*abs(fft(e))/length(e); E(1)=E(1)/2;

%% plotting
figure
subplot(211), plot(wen);grid;ylabel('Amplitude');title('Original Signal'); 
subplot(212), plot(f,WEN(1:length(f)));grid;ylabel('spectrum'); 

figure
subplot(211), plot(d);grid;ylabel('Amplitude');title('Signal plus interference d(n) = s(n) + v0(n)'); 
subplot(212), plot(f,D(1:length(f)));grid;ylabel('spectrum');

figure
subplot(211), plot(e);grid;ylabel('Amplitude');title(['[Estimate of s(n) signal] MSE = ' num2str(perf)]); 
subplot(212), plot(f,E(1:length(f)));grid;ylabel('spectrum');

