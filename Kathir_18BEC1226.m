clc
clear all
close all
%% SAMPLING %%
n=30; %number of samples per cycle
%x=0:2*pi/n:4*pi; % range of x from 0 to 4 pi
Vp=2; %Vp is the amplitude of the signal mentioned in the task
x=[-12:0.1:12];
signal_1= (-5*x.^2/6) + 120; % input signal
%% QUANTIZATION %%
%With a bit of experimenting (trial and error), the demodulated signal started looking like the original signal(sine) when the number of bits was 6 or more
bits=9; %number of bits per sample
L=2^bits; %number of bytes per sample
xmax=120; %the index values range from 0 to 7 with this range of x
xmin=0;
del=0.09; %incrementing by 0.09 generated a cleaner demodulated signal rather than 1
%A quantization partition defines several contiguous, nonoverlapping ranges of values within the set of real numbers
partition=xmin:del:xmax; % defining partition according to the indexing
%a codebook tells the quantizer which common value to assign to inputs that fall into each range of the partition
%defining codebook: the lower range/upper range of the codebook must be one increment less/more
%than the partition or can be equally distributed in both sides as is done here
codebook=xmin-(del/2):del:xmax+(del/2);
[index,quants]=quantiz(signal_1,partition,codebook); %quantization using quantiz
% gives rounded off values of the samples
%% NORMALIZATION %%
l1=length(index); % to convert 1 to n as 0 to n-1 indicies
for i=1:l1
if (index(i)~=0)
index(i)=index(i)-1;
 end
end
%% ENCODING %%
code=de2bi(index,'left-msb'); % decimal to binary conversion with MSB to the left
code_row=reshape(code, [1,numel(code)]); %converting the array to a single row array.
%The number of elements (366) in code array determines the number of columns in code_row array
k=1;
for i=1:l1 % to convert column vector to row vector
 for j=1:bits
 coded(k)=code(i,j);
 j=j+1;
 k=k+1;
 end
 i=i+1;
end
%% DEMODULATION %%
index1=bi2de(code_row,'left-msb'); %converting from binary to decimal
resignal=del*index+xmin+(del/2); %to recover the modulated signal
%% Plotting %%
subplot(3,2,1)
plot(x,signal_1); % plotting sine signal
title('Data Signal')
xlabel('Time')
ylabel('Light Intensity (kilolux)')
subplot(3,2,2)
stem(signal_1,'r'); % plot of sampled signal
title('Sampled Signal')
xlabel('Time')
ylabel('Light Intensity (kilolux)')
subplot(3,2,3)
scatter(x,quants,'g') %plot of quantized signal
hold on
plot(x,signal_1);
title('Quantized Signal')
xlabel('Time')
ylabel('Light Intensity (kilolux)')
subplot(3,2,4)
stairs(coded,'k'); %plot of digital signal
axis([0 200 -2 2])
%plot of digital signal
title('Digital signal')
xlabel('Time')
ylabel('Amplitude')
subplot(3,2,5)
plot(resignal,'m') %plot of demodulated signal
title('Recovered Signal')
xlabel('Time')
ylabel('Light Intensity (kilolux)')