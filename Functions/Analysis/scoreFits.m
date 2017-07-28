%This file will score the effectiveness of various fits. You can either
%enter points of concern ahead of time, or fir random points. It scores all
%points based off of a least-squares method.


folder = 'C:\\Users\\Mirae\\Desktop\\Code\\trainingDax\\testDax\\';
sd_points = 1.5;
numFiles = 1;
imSize = 100;
dotSize = 5;
numPoints = 10;
factor = .9;

for k = 1:2
    
    locals = round((imSize-2*dotSize)*rand(numPoints,2) + dotSize);
    [filename] = createTrainingDax(locals, sd_points,  folder, imSize, dotSize, factor);
    dax = ReadDax(filename);
    gauss = Fit2Dspot(dax);
    
    origins = zeros(length(gauss.fits_x),2);
    for i = 1:length(gauss.fits_x)
       length_x = [gauss.fits_x(i); locals(:,1)];
       length_y = [gauss.fits_y(i); locals(:,2)];
       dis_one = squareform(pdist(length_x));
       dis_two = squareform(pdist(length_y));
       dis_x = dis_one(2:length(dis_one(:,1)),1);
       dis_y = dis_two(2:length(dis_two(:,1)),1);
%        minx = dis_x(1);
%        for l = 1:length(dis_x)
%             if dis_x(l) < minx
%                 minx = dis_x(l);
%             end
%        end
%        miny = dis_y(1);
%        for l = 1:length(dis_y)
%             if dis_y(l) < my_min(dis_y)
%                 miny = dis_y(l);
%             end
%        end
       remove_x = double(find(~(dis_x - my_min(dis_x))));
       remove_y = double(find(~(dis_y - my_min(dis_y))));
       choose = remove_x(1);
       min = sqrt((locals(remove_x(1),1))^2 + ((locals(remove_x(1),2)))^2);
       for m = 1:length(remove_x)
            x_dist = sqrt((locals(remove_x(m),1))^2 + ((locals(remove_x(m),2)))^2);
            if x_dist < min; choose = remove_x(m); end
       end
       for m = 1:length(remove_y)
            y_dist = sqrt((locals(remove_y(m),1))^2 + ((locals(remove_y(m),2)))^2);
            if y_dist < min; choose = remove_y(m); end
       end
       origins(i,1) = locals(choose,1);
       origins(i,2) = locals(choose,2);
    end
    
    figure(k); clf; imagesc(dax); colorbar; hold on;
    dif_x = origins(:,1)*factor - gauss.fits_x;
    dif_y = origins(:,2)*factor - gauss.fits_y;
    total_dif = sqrt(dif_x.^2 + dif_y.^2);
    
    max_difs = zeros(5,2);
    for n = 1:length(total_dif)
        if total_dif(n) > my_min(max_difs(:,1))
            found = 1;
            for m = 1:length(max_difs(:,1))
                if (found == 1) && (max_difs(m, 1) == my_min(max_difs(:,1)))
                    max_difs(m, 1) = total_dif(n);
                    max_difs(m, 2) = n;
                    found = 0;
                end
            end
        end
    end
    
    for m = 1:length(max_difs(:,2))
       plot(origins(max_difs(m,2), 2)*factor + dotSize/2, origins(max_difs(m,2), 1)*factor + dotSize/2, 'ro', 'MarkerSize', 20);
    end
    
    plot(gauss.fits_x, gauss.fits_y, 'yo', 'MarkerSize', 20);
    hold off;
    
    disp(strcat('Fit Score: ', num2str(sum(max_difs))));
    
end
