%全局声谱
track=1;
[S,F,T,P] = spectrogram(data(:,track),rectwin(1000),500,10000,fs);
%figure('units','normalized','position',[0.2,0.1,0.5,0.8])
log_S=20*log10(abs(S)+eps);
%计算所有列的和,并找敲击点
sumColume=sum(log_S,1);
scope=max(sumColume)-min(sumColume);
node=[];%敲击点
for i=2:length(sumColume)
    if sumColume(i)-sumColume(i-1)>scope/3
        node=[node i];
    end
end
%找敲击声音范围
extent=zeros(length(node),2);
for i=1:length(node)
    startPoint=T(node(i))-0.01;
    endPoint=T(node(i))+0.14;
    extent(i,:)=[startPoint,endPoint];
end

%log_S(3000:end,:)=[];
%imagesc(log_S);axis xy; % 画总体的图谱

%局部声谱
for i=1:length(node)
    data1=data(fix(fs*extent(i,track)):fix(fs*extent(i,2)),1);
    [s,f,t,p] = spectrogram(data1(:,track),rectwin(50),25,10000,fs);% 10000 是纵向的精度
    figure('units','normalized','position',[0.2,0.1,0.5,0.8]);
    log_s=20*log10(abs(s)+eps);
    log_s(1400:end,:)=[];  %  把远高于主频的频舍掉，老数据用1400，新数据1800
    imagesc(t,f,log_s);% axis off;%关闭坐标  
    set(gca,'pos',[0.05 0.05 1 1])
%     path='E:\DeepLearning_sound\rock\collectedbefore\';
%     name=['collectedbefore_39' num2str(i) '.jpg'];
%     saveas(gca,[path,name]);
end





























