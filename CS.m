im = rgb2gray(imread('testimage.bmp'));
d = size(im,1); %保存图像原始大小
x = double(im(:));%将原始二维图化为单位向量
n = length(x);%原始信号大小
r = 4;%采样率，此处为1：4
m = floor(n/r);%采样数
phi = (sign(randn(m,n))+ones(m,n))/2;%生成为0，1的高斯的随机分布观测矩阵
y = phi*x;%获得观测结果

%% 生成稀疏基矩阵，使x=psi*s
psi = zeros(n); %分配空间
for k = 1:n
    t = zeros(n,1);
    t(k) = 1;%s的第k个系数
    t = idct(t);%对应x的分布
    psi(:,k) = t;%写入大矩阵
end
theta = phi*psi;
%% 求解稀疏向量
s2 = theta'*y;%初始猜测
s1 = l1eq_pd(s2,theta,[],y,1e-3);%使用 l1eq_pd求解s

%% 转换回原始信号并观察
xp = psi*s1;%将s转化回原始信号
imRec = reshape(xp,d,d);%将向量恢复为原始的二维图像

subplot(1,2,1)
imshow(im,[]);
xlabel('original');
subplot(1,2,2)
imshow(imRec,[]);
xlabel('reconstructed')