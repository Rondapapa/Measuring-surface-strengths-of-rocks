% mkdir('classicalshengputu');%������������ͼ���ļ���   
% file = '/Users/liupeng/Desktop/matlab/speechRecognition/classical10s/'; % �����ļ���  
% file1 = strcat(file, '*.mp3');  
% file2=dir(file1);%����.wav ��׺���ļ�   

k=length(file2);%ͳ���ļ�����Ŀ   
R=1024;%���ô���������   
window=hamming(R);%ʹ�ú�����   
N=1024;%��ʱ����Ҷ��������   
L=512;%����   
overlap=R-L;%���ص�����  
for i=1:k  
%     file3 = strcat(file, file2(i).name);  
    
    [x,fs]=audioread('a.mp3');%��ȡ.au �ļ�  
%     str1 = strcat('/Users/liupeng/Desktop/matlab/speechRecognition/classicalshengputu/', file2(i).name);%��¼.wav �ļ�����   
%     figure('visible','off')  
    x= awgn(x,100,'measured','linear');  
    % x= x(1:3.2:end,1); %����Ҫ�������ֲ������øú���   
    s=specgram(x(:,1),N,fs,window,overlap);%��������ͼ   
    y=20*log10(abs(s)+eps);%����Ҫ��ת��ʵ��������   
    %[y,PS] = mapminmax(y,0,1);%����Ҫ��һ����[0��1]����   
    %[y,PS] = mapminmax(y,-1,1);%����Ҫ��һ����[-1��1]����   
    %y = y*255;%��һ������ת��������ͼ����   
    %y=uint8(y);%��һ������ת��������ͼ����  
    axis off;%�ر�����  
    imagesc(y)%�Ѿ�����Ƴ�ͼʱ���ã�imagesc(A) ������A�е�Ԫ����ֵ����Сת��Ϊ��ͬ��ɫ��  
    %colormap gray %�����Ҫ����ͼΪ�Ҷ�����ͼ����   
    str2=strcat(str1,'_');  
    str2=strcat(str2,num2str(i-1));  
    str2=strcat(str2,'.bmp');  
    cd bluesshengputu  
    imshow(y,'border','tight');%������ʾ����ͼ����  
    set(gcf,'position',[0,0,255,256]);%�趨 figure ��λ�úʹ�С���˴���СΪ 256*256   
    %set(gca,'DataAspectRatio',[1,1,1]);%�������������ʱ����   
    %set(gca,'position',[0,0,1,1]);%����������λ��ʱ����  
    f=getframe(gcf); %ֱ�ӱ���Ϊ���ײ�ͼ����С�������ز�������   
   % imwrite(f.cdata,str2,'jpg');  
    %imwrite(y,str2,'jpg');%����Ҫ������ͼ������д�����Ҫʹ�øú�������  
    %saveas(gcf,str2,'jpg');%����ֱ�Ӳ�����С�̶�������ͼ����Ҫʹ�øú�������   
    close(gcf)  
    cd ..   
end  