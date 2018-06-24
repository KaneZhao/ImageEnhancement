%从RGB空间到HSV空间转换
figure;
c=imread('dimmed.jpg'); 
hv=rgb2hsv(c); 
%得到其V分量
V=hv(:,:,3);
V1=V;
%pdf
alpha=0.3;
[m,n]=size(V);
V=ceil(V*255);
ImgHist = zeros(256, 1);
for i = 1:m
    for j = 1:n
        ImgHist(V(i, j)+1) =  ImgHist( V(i, j)+1) + 1;
    end
end
p=ImgHist/(m*n);
Max=max(p);
Min=min(p);
h=zeros(256,1);
for i=1:256
   h=cumsum(p);  
end
q=p;
for i= 1:256
    q(i)=Max*((p(i)-Min)/(Max-Min)).^alpha;
end
Maxv=max(max(V));
%cdf
s=cumsum(q);
sum=s(256);
B=s/sum;
B=B';
%TGC
x = 1:256;
y =Maxv*((x/Maxv).^(1-B(x)));
imgn=zeros(m,n);
for i=1:m
   for j=1:n
      imgn(i,j)=y(V(i,j)+1)-1;    %由原图的灰度通过索引映射到新的灰度
   end
end
imgn=double(imgn/255);%得到新的V分量
hv(:,:,3)=imgn;
b=hsv2rgb(hv);%从HSV空间到RGB空间
subplot(121);imshow(c);
subplot(122);imshow(b);
%与其他算法进行对比
figure;
[J,T] = histeq(V1);%仅使用直方图均衡化
hv(:,:,3)=J;
g=hsv2rgb(hv);
Q=imadjust(V1);%利用imadjust()函数
hv(:,:,3)=Q;
k=hsv2rgb(hv);
subplot(2,3,1);
imshow(b);title('AGCWD');
subplot(2,3,2);
imshow(g);title('THE');
subplot(2,3,3);
imshow(k);title('IMADJUST');
subplot(2,3,4);
imhist(imgn);
subplot(2,3,5);
imhist(J);
subplot(2,3,6);
imhist(Q);










