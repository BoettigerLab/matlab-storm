function output = Fit2Dspot(input, varargin)


daxFile = 'E:\Mirae-Simon\2017-01-12_Beads\beads_0003.dax';
dax = ReadDax(daxFile);

im = dax(1:100,1:100,2);
figure(1); clf; imagesc(im);

%% find local maxima to pixel precision
w = 30;
cameraBackground = 1000;
minPeakHeight = 1000;
peakBlur = .5;
im2 = im; % im(w+1:end-w+1,w+1:end-w+1,w+1:end-w+1); % exclude points on border
im2 = im2 - cameraBackground; % figure(2); clf; imagesc(im2);
im2 = imgaussfilt(im2,peakBlur);
bw = imregionalmax(im2); %  figure(2); clf; imagesc(bw);
bw(im2<minPeakHeight) = 0;

localPeaks = find(bw(:));
[y,x] = ind2sub(size(bw), localPeaks);
peakHeight = im2(localPeaks);
fits.x = x;
fits.y = y;
fits.h = peakHeight;

dTable = table(x,y,peakHeight);


troubleshoot = true;
if troubleshoot
    figure(2); clf; 
    imagesc(im2); hold on; plot(dTable.x,dTable.y,'o','color',[1 .5 .5]);  % plots x vs y
end



%% 2D Gaussian fit  (make this a function)
i = 1;
cropWidth = 8; 
[v,w] = size(im2);
xr = max(1,fits.x(i)-cropWidth):min(fits.x(i)+cropWidth,w);
yr = max(1,fits.y(i)-cropWidth):min(fits.y(i)+cropWidth,v);
data_2d = double(im2(yr,xr)); % 
figure(2); clf;
[Y,X] = meshgrid(xr,yr);
subplot(1,2,1); imagesc(im2); hold on; plot(Y(:),X(:),'r.');


ftype = fittype('exp(-((x-mu_x)/(2*sigma_x)).^2-((v-mu_y)/(2*sigma_y)).^2 )*a/(2*pi*sigma_x*sigma_y)+b',...
                'coeff', {'a','mu_x','sigma_x','mu_y','sigma_y','b'},'ind',{'x','v'}); 

[v,w] = size(data_2d);
[Y,X] = meshgrid(1:v, 1:w);

a0 = double(fits.h(i));
b0 = 200;
mu_x0 = fits.x(i)-min(xr)+1; %  cropWidth+1;
mu_y0 = fits.y(i)-min(yr)+1; % cropWidth+1;
sigma_x0 = 1;
sigma_y0 = 1;

% dataTest = a0*exp(-((X-mu_x0-1.3)/(2*sigma_x0+3)).^2-((Y-mu_y0+.25)/(2*sigma_y0+.5)).^2 )+b0;

fit_2d = fit([Y(:),X(:)],double(data_2d(:)),ftype,'StartPoint',[a0 mu_x0 sigma_x0 mu_y0 sigma_y0 b0],...
    'Lower',[0 mu_x0-5 .1 mu_y0-5 .1 0],'Upper',[2^16 mu_x0+5 2 mu_y0+5 2 1E4]);

g = feval(fit_2d,Y(:),X(:));
G = reshape(g,[w,v]);
fit_2d.mu_y,fit_2d.mu_x
figure(3); clf; subplot(1,2,1); surf(X,Y,G); view(0,90); axis ij;
subplot(1,2,2); imagesc(data_2d); hold on; 
plot(mu_y0,mu_x0,'ro');
plot(fit_2d.mu_y,fit_2d.mu_x,'r+');
