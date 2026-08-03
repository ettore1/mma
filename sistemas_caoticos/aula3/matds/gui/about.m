function varargout = about(varargin)
% ABOUT Application M-file for about.fig
%    FIG = ABOUT launch about GUI.
%    ABOUT('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 29-Dec-2002 02:39:41


        fprintf('\n\n Matds is a MATLAB-based program for');
        fprintf('\n   dynamical system investigation');
        fprintf('\nAuthor: Govorukhin V., Rostov University.');
        fprintf('\n      E-Mail: vgov@math.rsu.ru\n');
	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
        varargout{1} = handles;
%        pause;
%        close;
%        return;