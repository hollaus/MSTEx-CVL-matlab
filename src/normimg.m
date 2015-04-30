function img = normimg(img, varargin)
% function img = normimg(img);
%
% DESCRIPTION:
%  IMG = normimg(IMG); normalizes an image IMG. It simply adds the minimal 
%  value < 0 of an image matrix so that all values are positive. Afterwards
%  it divides all values by the maximum. The resultant image IMG is an
%  image whose values are between zero and one.
%  IMG = normimg(IMG, RESPECTIVELY); normalizes each color channel of a
%  color image respectively. Hence, color casts are removed. The default
%  value for RESPECTIVELY is false.
%
% INPUTS:
%  IMG is a rgb or graylevel image.
%
% OUTPUTS:
%  IMG is a normalized image whose values are between 0 and 1.
% 
%  Copyright (C) 2014-2015 Fabian Hollaus <holl@caa.tuwien.ac.at>
%  Copyright (C) 2014-2015 Markus Diem <markus@nomacs.org>
%  Vienna University of Technology, Computer Vision Lab
%  This file is part of ViennaMS2.
% 
%  ViennaMS2 is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
% 
%  ViennaMS2 is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
% 
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.


if isempty(img)
    return;
end

res = ParseInputs(varargin{:});

img = im2double(img);

if isequal(ndims(img),3) && res
    
    img(:,:,1) = normimg(img(:,:,1));
    img(:,:,2) = normimg(img(:,:,2));
    img(:,:,3) = normimg(img(:,:,3));
    
else

    img = img-min(img(:));
    img = img./max(img(:));
end

%----------------------------------------------------------------------
% Subfunction ParseInputs
%----------------------------------------------------------------------
function res= ParseInputs(varargin)

res = 0;

if nargin > 1
    warning('WarnInput:convert','   Too many input arguments. \n    Use:    img= normimg(img, respectively); \n');
elseif nargin == 1
    res= varargin{1};
end

