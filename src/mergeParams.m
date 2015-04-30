function params = mergeParams(defaultParams, params)
%MERGEPARAMS Merges default params with user defined params, in favour of user defined ones.
% 
% This function is used very often in the project. Every function, that
% calls MERGEPARAMS has a function called PARSEINPUTS. In this PARSEINPUTS
% method default settings are set, by initializing different fields of one 
% struct. Then MERGEPARAMS is called with the default settings and the user
% settings. Note that the user settings may be empty or may have less 
% fields as the default settings. MERGEPARAMS iterates through the default
% settings and checks if there is a user setting with the same name. If so,
% the user settings are taken, else the default settings are used.
% 
%Input:
% defaultParams: Struct holding default settings.
% params:        Struct holding user-defined settings.
%Output:
% params:        Struct holding merged settings.
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

if isempty(defaultParams)
    return;
end

names = fieldnames(defaultParams);

for i = 1:length(names)
    name = names{i};
    if (~isfield(params, name))
        params.(name) = defaultParams.(name);
    end
end

