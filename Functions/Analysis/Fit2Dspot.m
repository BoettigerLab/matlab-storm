function [dTable] = Fit2Dspot(im, guesses, varargin)
% fits = Fit2DSpots(daxFile)
% fits = Fit2DSpots(daxFile,'cameraBackground',value,'minPeakHeight',value)
%
% 

%% Global Parameters
%--------------------------------------------------------------------------
%global defaultXmlFile defaultIniFile;
   
%--------------------------------------------------------------------------
%% Default Parameters

% this an more compact and readable version 
defaults = cell(0,3);
defaults(end+1,:) = {'cameraBackground','float',1000};
defaults(end+1,:) = {'minPeakHeight','float',1000};
defaults(end+1,:) = {'peakBlur','float',.5};
defaults(end+1,:) =  {'initSigmaXY', 'float', 1.5};
defaults(end+1,:) =  {'maxSigma', 'float', 3}; 
defaults(end+1,:) =  {'minSigma', 'float', .3};
defaults(end+1,:) =  {'peakBound', 'positive' 2};
defaults(end+1,:) = {'FiniteDifferenceType',{'central','forward'},'central'};
defaults(end+1,:) = {'MaxFunctionEvaluations','positive',5E3};
defaults(end+1,:) = {'OptimalityTolerance','positive',1E-8};
pars = ParseVariableArguments(varargin, defaults, mfilename);
 

%% find local maxima to pixel precision

%daxFile = 'E:\Mirae-Simon\2017-01-12_Beads\beads_0003.dax';
%dax = ReadDax(daxFile);
%im = dax(1:100,1:100,2);

%figure(1); clf; imagesc(im);

im2 = im; % im(w+1:end-w+1,w+1:end-w+1,w+1:end-w+1); % exclude points on border
im2 = im2 - pars.cameraBackground; % figure(2); clf; imagesc(im2);
im2 = imgaussfilt(im2,pars.peakBlur);
bw = imregionalmax(im2); %  figure(2); clf; imagesc(bw);
bw(im2<pars.minPeakHeight) = 0;

localPeaks = find(bw(:));
[y,x] = ind2sub(size(bw), localPeaks);
peakHeight = im2(localPeaks);

% fits.x = zeros(0);
% fits.y = zeros(0);
% 
% pixels = 5;
% for i = 1:length(x)
%     x_test = x(i);
%     y_test = y(i);
%     found = false;
%     for r = x_test-pixels:x_test+pixels
%         for c = y_test-pixels:y_test+pixels
%          if (x_test ~= r && y_test ~= c)
%               if ismember(x, r).*ismember(y, c)~= 0
%                 overlap = ismember(x, r) & ismember(y, c);
%                 fits.x = [fits.x; round((x(i) + overlap*x)/2)];
%                 fits.y = [fits.y; round((x(i) + overlap*y)/2)];
%                 found = true;
%                 x = x*(~overlap);
%                 y = y*(~overlap);
%               end
%          end 
%         end
%     end
%     if ~found
%         if(x(i) ~=0 && y(i) ~=0)
%           fits.x = [fits.x; x(i)];
%           fits.y = [fits.y; y(i)];
%         end
%     end
% end
% 
% peakHeight = zeros(length(fits.x),1);
% for k = 1:length(fits.x)
%     peakHeight(k, 1) =  im2(fits.x(k), fits.y(k));
% end
% x = fits.x;
% y = fits.y;

fits.x = x;
fits.y = y;
fits.h = peakHeight;
dTable = table(x,y,peakHeight);

%troubleshoot = true;
%if troubleshoot
%    figure(2); clf; 
%    imagesc(im2); hold on; plot(dTable.x,dTable.y,'o','color',[1 0 0]);  % plots x vs y
%end

%% 2D Gaussian fit  (make this a function)
% ftype = fittype('exp(-((x-mu_x)/(2*sigma_x)).^2-((v-mu_y)/(2*sigma_y)).^2 )*a/(2*pi*sigma_x*sigma_y)+b',...
%                 'coeff', {'a','mu_x','sigma_x','mu_y','sigma_y','b'},'ind',{'x','v'});
% b0 = 200;
% sigma_x0 = 1;
% sigma_y0 = 1;
 cropWidth = 8; 
 [v_whole,width_whole] = size(im2);
%     
 mu_x = zeros(length(peakHeight), 1);
 mu_y = zeros(length(peakHeight), 1);
 sig_x = zeros(length(peakHeight), 1);
 sig_y = zeros(length(peakHeight), 1);
 xr_s = zeros(length(peakHeight), 1);
 yr_s = zeros(length(peakHeight), 1);

    sigma_x0 = pars.initSigmaXY;
    sigma_y0 = pars.initSigmaXY;
    maxSigma = pars.maxSigma; 
    minSigma = pars.minSigma;
    peakBound = pars.peakBound;
    b0 = 0;
    
    options = optimoptions('lsqnonlin',...
                           'FiniteDifferenceType',pars.FiniteDifferenceType,...
                           'OptimalityTolerance',pars.OptimalityTolerance,...
                           'MaxFunctionEvaluations',pars.MaxFunctionEvaluations,...
                           'Display','off');
    
for i = 1:length(dTable.x)

    xr = max(1,fits.x(i)-cropWidth):min(fits.x(i)+cropWidth,width_whole);
    yr = max(1,fits.y(i)-cropWidth):min(fits.y(i)+cropWidth,v_whole);
    
    xr_s(i) = min(xr)-1;
    yr_s(i) = min(yr)-1;
    data_2d = double(im2(yr,xr)); %
    [wid_1, wid_2] = size(data_2d);
    filter = fspecial('gaussian', [wid_2, wid_1]);
    data_2d = filter*data_2d;
%figure(2); clf;
%[Y,X] = meshgrid(xr,yr);
%subplot(1,2,1); imagesc(im2); hold on; plot(Y(:),X(:),'r.');


    [v,w] = size(data_2d);
    [Y,X] = meshgrid(1:v, 1:w);

    a0 = double(fits.h(i));
    mu_x0 = fits.x(i)-min(xr)+1; %  cropWidth+1;
    mu_y0 = fits.y(i)-min(yr)+1; % cropWidth+1;

% dataTest = a0*exp(-((X-mu_x0-1.3)/(2*sigma_x0+3)).^2-((Y-mu_y0+.25)/(2*sigma_y0+.5)).^2 )+b0;

  %  fit_2d = fit([Y(:),X(:)],double(data_2d(:)),ftype,'StartPoint',[a0 mu_x0 sigma_x0 mu_y0 sigma_y0 b0],...
  %      'Lower',[0 mu_x0-5 .1 mu_y0-5 .1 0],'Upper',[2^16 mu_x0+5 2 mu_y0+5 2 1E4]);

   minRes = @(p) exp(-((Y(:)-p(1))/(2*p(2))).^2 -((X(:)-p(3))/(2*p(4))).^2)*p(5)+p(6) -data_2d(:);
    par0 = [mu_x0,sigma_x0,mu_y0,sigma_y0,a0,b0]; % initial fits
    lb = [mu_x0-peakBound,minSigma,mu_y0-peakBound,minSigma,0,0]; % lower bound 
    ub = [mu_x0+peakBound,maxSigma,mu_y0+peakBound,maxSigma,2^16,2^16]; % upper bound

   %[par,resnorm,residual,~,~,~,jacobian] = lsqnonlin(minRes, par0,lb,ub,options);
    
   par = lsqnonlin(minRes, par0,lb,ub, options);
    
   % ci = nlparci(par,residual,'jacobian',jacobian,'alpha',1-.95); % 95% CI 
    
  %  g = feval(fit_2d,Y(:),X(:));
  %  G = reshape(g,[w,v]);
   % fit_2d.mu_y,fit_2d.mu_x
    
    mu_x(i) = par(1);
    mu_y(i) = par(3);
    sig_x(i) = par(2);
    sig_y(i) = par(4);
    
    %figure(3); clf; subplot(1,2,1); surf(X,Y,G); view(0,90); axis ij;
    %subplot(1,2,2); imagesc(data_2d); hold on; 
    %plot(mu_x0,mu_y0,'ro');
    %plot(fit_2d.mu_y,fit_2d.mu_x,'r+');
    
end


 %   xr = max(1,fits.x-cropWidth):min(fits.x+cropWidth,width_whole);
 %   yr = max(1,fits.y-cropWidth):min(fits.y+cropWidth,v_whole);
 %   mu_x0 = fits.x-min(xr)+1; % 
 %   mu_y0 = fits.y-min(yr)+1;
   fits_x = mu_x + xr_s;
   fits_y = mu_y + yr_s;

   %Want to check out the relationship between all fitted points,this
   %iterates over the grid:
   
   % figure(3);  clf; 
   % imagesc(im2); hold on; 
   % plot(x, y, 'ro');
   % plot(fits_x, fits_y,'r+');
   % hold off;
    disp('done!');
dTable = [dTable, table(fits_x, fits_y, sig_x, sig_y)];
