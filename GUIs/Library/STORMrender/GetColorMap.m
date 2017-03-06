function clrmap = GetColorMap(clrmapName,varargin)
% GetColorMap('hsv')
% GetColorMap('redToWhite');
% GetColorMap('redToWhite',10);
%

% defaults
defaults = cell(0,3);
defaults(end+1,:) = {'verbose','boolean',true};


if nargin > 1
    pts = varargin{1};
else
    pts = 256;
end

varin = varargin(2:end);
parameters = ParseVariableArguments(varin,defaults,mfilename);


if ~ischar(clrmapName)
    clrmap = clrmapName;
    return
end

try 
    if strcmp(clrmapName,hsv)
        clrmap = eval([clrmapName, '(',num2str(pts+1),')']);
    else
        clrmap = eval([clrmapName, '(',num2str(pts),')']);
    end
catch

    % Black to white colormaps via the indicated color name;
  switch clrmapName
        case 'yellow'
        clrmap = hot(pts);
        clrmap = [clrmap(:,1),clrmap(:,1),clrmap(:,2)];
        clrmap(clrmap<0) = 0;

        case 'red'
        clrmap = hot(pts);
        clrmap = [clrmap(:,1),clrmap(:,2),clrmap(:,3)];
        clrmap(clrmap<0) = 0;
        
        case 'blue'
        clrmap = hot(pts);
        clrmap = [clrmap(:,3),clrmap(:,2),clrmap(:,1)];
        clrmap(clrmap<0) = 0;

        case 'green'
        clrmap = hot(pts);
        clrmap = [clrmap(:,3),clrmap(:,1),clrmap(:,2)];
        clrmap(clrmap<0) = 0;

        case 'purple'
        clrmap = hot(pts);
        clrmap = [clrmap(:,1),clrmap(:,3),clrmap(:,1)];
        clrmap(clrmap<0) = 0; 
        
        case 'black'
        clrmap = gray(pts);
        
        case 'cyan'
        clrmap = hot(pts);
        clrmap = [clrmap(:,3),clrmap(:,1),clrmap(:,1)];
        clrmap(clrmap<0) = 0;

      case 'whiteOrangeRed'
        nPts = pts;
        whiteToYellow = zeros(nPts,3);
        yellowToRed  = zeros(nPts,3);
        redToBlack  = zeros(nPts,3);
        redToWhite = zeros(nPts,3); 
        redToYellow= zeros(nPts,3); 
        for n=1:nPts
            yellowToRed(n,:) = [1,(nPts-n+1)/nPts,0];
            redToBlack(n,:) =  [(nPts-n+1)/nPts,0,0];
            redToWhite(n,:) = [1,n/nPts,n/nPts];
            whiteToYellow(n,:) = [1, (nPts-n*.3+.3)/nPts, (nPts-n+1)/nPts];
            redToYellow(n,:)= [1,.7*n/nPts,0];
        end
        clrmap = flipud([redToYellow;flipud(whiteToYellow)]);

      case 'blackCyanOrange'
        nPts = round(pts/2);
        blackToCyan = zeros(nPts,3);
        CyanToOrange  = zeros(nPts,3);
        for n=1:nPts
            blackToCyan(n,:) = [0 n/nPts n/nPts];
            CyanToOrange(n,:) = [ n/nPts, (nPts-(n/2))/nPts, (nPts-n)/nPts];
        end
        clrmap = ([blackToCyan; (CyanToOrange)]);
        
      case 'RedWhiteBlue'
          nPts = round(pts/2);
          redToWhite = zeros(nPts,3);
          whiteToBlue = zeros(nPts,3);
          for n=1:nPts
              redToWhite(n,:) = [1,n/nPts,n/nPts];
              whiteToBlue(n,:) = [(nPts-n+1)/nPts,(nPts-n+1)/nPts,1];
          end
          clrmap = [redToWhite; whiteToBlue];

    case 'redToWhite'
        nPts = pts;
        redToWhite = zeros(nPts,3);
        for n=1:nPts
          redToWhite(n,:) = [1,((n-1)/(nPts-1)),((n-1)/(nPts-1))];
        end
        clrmap = redToWhite;   
        
    case 'redToWhite2'
        nPts = pts;
        redToWhite = zeros(nPts,3);
        for n=1:nPts
          redToWhite(n,:) = [1,((n-1)/(nPts-1))^.5,((n-1)/(nPts-1))^.5];
        end
        clrmap = redToWhite;      
        
    otherwise
        if parameters.verbose
            warning(['colormap ',clr,' not recognized']);
        end
  end
end

if nargout == 0
        colormap(clrmap); 
end