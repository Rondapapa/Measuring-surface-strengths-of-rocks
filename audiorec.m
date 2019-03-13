% mkdir('classicalshengputu');%创建保存声谱图的文件夹   
% file = '/Users/liupeng/Desktop/matlab/speechRecognition/classical10s/'; % 语音文件夹  
% file1 = strcat(file, '*.mp3');  
% file2=dir(file1);%搜索.wav 后缀的文件   

k=length(file2);%统计文件的数目   
R=1024;%设置窗函数长度   
window=hamming(R);%使用汉明窗   
N=1024;%短时傅立叶函数点数   
L=512;%步长   
overlap=R-L;%窗重叠点数  
for i=1:k  
%     file3 = strcat(file, file2(i).name);  
    
    [x,fs]=audioread('a.mp3');%读取.au 文件  
%     str1 = strcat('/Users/liupeng/Desktop/matlab/speechRecognition/classicalshengputu/', file2(i).name);%记录.wav 文件名字   
%     figure('visible','off')  
    x= awgn(x,100,'measured','linear');  
    % x= x(1:3.2:end,1); %如需要对于音乐采样调用该函数   
    s=specgram(x(:,1),N,fs,window,overlap);%生成声谱图   
    y=20*log10(abs(s)+eps);%如需要在转换实数和虚数   
    %[y,PS] = mapminmax(y,0,1);%如需要归一化成[0，1]调用   
    %[y,PS] = mapminmax(y,-1,1);%如需要归一化成[-1，1]调用   
    %y = y*255;%归一化后需转化成声谱图调用   
    %y=uint8(y);%归一化后需转化成声谱图调用  
    axis off;%关闭坐标  
    imagesc(y)%把矩阵绘制成图时调用，imagesc(A) 将矩阵A中的元素数值按大小转化为不同颜色。  
    %colormap gray %如果需要声谱图为灰度声谱图调用   
    str2=strcat(str1,'_');  
    str2=strcat(str2,num2str(i-1));  
    str2=strcat(str2,'.bmp');  
    cd bluesshengputu  
    imshow(y,'border','tight');%如需显示声谱图调用  
    set(gcf,'position',[0,0,255,256]);%设定 figure 的位置和大小，此处大小为 256*256   
    %set(gca,'DataAspectRatio',[1,1,1]);%调整坐标轴比率时调用   
    %set(gca,'position',[0,0,1,1]);%调整坐标轴位置时调用  
    f=getframe(gcf); %直接保存为声谱彩图，大小由上面呢参数决定   
   % imwrite(f.cdata,str2,'jpg');  
    %imwrite(y,str2,'jpg');%如需要对声谱图矩阵进行处理，需要使用该函数保存  
    %saveas(gcf,str2,'jpg');%如需直接产生大小固定的声谱图，需要使用该函数保存   
    close(gcf)  
    cd ..   
end  