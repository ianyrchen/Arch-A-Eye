function All_Images_SL_Stats()
% All_Images_SL_Stats
% Demo of image stats: Calculate image spectral slope, fractal dimension, 
% Shannon entropy.
%
% Crops images to largest square that is a power of two. (accurate FFT).
%
% Slope of amplitude spectrum:
% Limits range of SF to avoid possible artefacts introduced by 
% nonlinearities that usually affect very low and high SFs. See function.
%
% Fractal Dimension (D):
% Differential box count, see function for details.
%
% Shannon Entropy:
% Standard Matlab entropy function.
%
% Available under CC-BY-NC license
% Please cite: 
% Mather, G. (2017) Visual statistics of large samples of Western artworks. Art & Perception, 5, 368.
% Mather, G. (submitted) Visual statistics in the history of Western art. Art & Perception, under review.% 
%
clear;
close all;

% go to directory
files = dir('C:/Users/heath/PycharmProjects/MyImages/CalculatedBackground/*.PNG');
%files = dir('C:/Users/heath/PycharmProjects/MyImages/RandomBackground/*.PNG');
%files = dir('Img/*.JPG');

% Preallocate arrays and tables
sz = [100 9];
varTypes = ["double","double","double","double","double","double","double","double","double"];
varNames = ["Luminance","Luminance-c","Luminance-p","a","a-c","a-p","b","b-c","b-p"];
SL_Table = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

% ----- Load files to analyse -----
for i=1:length(files)
    fname=strcat('C:/Users/heath/PycharmProjects/MyImages/CalculatedBackground/', files(i).name);
    %fname=strcat('C:/Users/heath/PycharmProjects/MyImages/RandomBackground/', files(i).name);
    %fname=strcat('Img/', files(i).name);

    [PathName, FileName,extname] = fileparts(fname); 
    imgin = imread(fname);
    %     imshow(imgin)
% end

    % ---- Prepare image for analysis ----
    % crop to largest central rectangle
    [nr, nc, N] = size(imgin);  % get y & x dimensions of image

    % find largest square that is a power of 2 (for boxcount)
    if (nr < nc)
        np = 2^nextpow2(nr);
        if (nr < np)
            nnr = 2^(nextpow2(nr)-1);
        else
            nnr = 2^(nextpow2(nr));
        end
            
        dc = nc - nnr;
        dr = nr - nnr;
        nnc = nnr;
    else
        np = 2^nextpow2(nc);
        if (nc < np)
            nnc = 2^(nextpow2(nc)-1);
        else
            nnc = 2^(nextpow2(nc));
        end
        dr = nr - nnc;
        dc = nc - nnc;
        nnr = nnc;
    end
    nr = nnr;
    nc = nnc;
    
    % centred crop
    ci = imgin (round(1+dr/2):round(dr/2+nr),round(1+dc/2):round(dc/2+nc),:); % centred
    
    suppress = 1; % don't show graphs
    
    % ---- Analyze image ----
    
    fprintf('\nImage Statistics:\n');
    fprintf('File %s (%gx%g):\n', FileName, nr, nr);
    
    % If image is RGB, split into Lab & analyse each
    if (ndims(ci) > 2)
        C = makecform('srgb2lab');
        clab = applycform(ci, C);
        cl = clab(:,:,1); % lightness    
        ca = clab(:,:,2); % red-green
        cb = clab(:,:,3); % blue-yellow
        
        % ----- Spectral slope -----
        [Sl, Scl, Spl] = SpecSlope(cl, suppress);
        [Sa, Sca, Spa] = SpecSlope(ca, suppress);
        [Sb, Scb, Spb] = SpecSlope(cb, suppress);
        fprintf(['\nSpectral slope:\n' ...
            'L: %5.3f (c=%2.3f; p=%2.5f)\n' ...
            'a: %5.3f (c=%2.3f; p=%2.5f)\n' ...
            'b: %5.3f (c=%2.3f; p=%2.5f)\n'], ...
            Sl, Scl, Spl, Sa, Sca, Spa, Sb, Scb, Spb);

        SL_Table(i,:) = {Sl, Scl, Spl, Sa, Sca, Spa, Sb, Scb, Spb};

        % Box count
        [Dl, Dcl, Dpl] = CDBC(cl, suppress);
        [Da, Dca, Dpa] = CDBC(ca, suppress);
        [Db, Dcb, Dpb] = CDBC(cb, suppress);
        fprintf(['\nBox Count:\n' ...
            'L: %5.3f (c=%2.3f; p=%2.5f)\n' ...
            'a: %5.3f (c=%2.3f; p=%2.5f)\n' ...
            'b: %5.3f (c=%2.3f; p=%2.5f)\n'], ...
            Dl, Dcl, Dpl, Da, Dca, Dpa, Db, Dcb, Dpb);
                
        % Entropy
        El = entropy(cl);
        Ea = entropy(ca);
        Eb = entropy(cb);
        fprintf(['\nEntropy:\n' ...
            'L: %5.3f\na: %5.3f\nb: %5.3f\n'], ...
            El, Ea, Eb);
        
    % Otherwise just analyse greyscale
    else
        cl (:,:,1) = ci;
        [Dl, Dcl, Dpl] = CDBC(cl, suppress);
        [Sl, Scl, Spl] = SpecSlope(cl, suppress);
        El = entropy(cl);
        fprintf(['Spectral slope:\n' ...
            '%5.3f (c=%2.3f; p=%2.5f)\n'], ...
            Sl, Scl, Spl);
        fprintf(['Box count:\n' ...
            '%5.3f (c=%2.3f; p=%2.5f)\n'], ...
            Dl, Dcl, Dpl);
        fprintf(['Entropy:\n' ...
            '%5.3f\n'], ...
            El);
    end
end

% Output to excel
outputFileName = 'calculatedBG_spectralslope.xlsx';
%outputFileName = 'randomBG_spectralslope.xlsx';

writetable(SL_Table,outputFileName,'Sheet',1);

end


