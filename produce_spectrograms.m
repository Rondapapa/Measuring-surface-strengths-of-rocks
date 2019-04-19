% produce the spectrogram of the whole sound file that contains 100`200 hammering sounds
track=1;
[S,F,T,P] = spectrogram(data(:,track),rectwin(1000),500,10000,fs);
%figure('units','normalized','position',[0.2,0.1,0.5,0.8])
log_S=20*log10(abs(S)+eps);
% find out the start points of the hammering sounds
sumColume=sum(log_S,1);
scope=max(sumColume)-min(sumColume);
node=[];% the start points of the hammering sounds
for i=2:length(sumColume)
    if sumColume(i)-sumColume(i-1)>scope/3
        node=[node i];
    end
end
% determine the range of the hammering sounds
extent=zeros(length(node),2);
for i=1:length(node)
    startPoint=T(node(i))-0.01;
    endPoint=T(node(i))+0.14;
    extent(i,:)=[startPoint,endPoint];
end

%log_S(3000:end,:)=[];
%imagesc(log_S);axis xy; % draw spectrogram

%produce the spectrograms of the single hammering sounds
for i=1:length(node)
    data1=data(fix(fs*extent(i,track)):fix(fs*extent(i,2)),1);
    [s,f,t,p] = spectrogram(data1(:,track),rectwin(50),25,10000,fs);% 10000 is the resolution of the frequency
    figure('units','normalized','position',[0.2,0.1,0.5,0.8]);
    log_s=20*log10(abs(s)+eps);
    log_s(1400:end,:)=[];  %  delete the high frequency part
    imagesc(t,f,log_s);
    axis off; 
    set(gca,'pos',[0.05 0.05 1 1])
    path='E:\spectrograms\'; % save the spectrograms to a specific file folder
    name=['spectrogram' num2str(i) '.jpg'];
    saveas(gca,[path,name]);
end





























