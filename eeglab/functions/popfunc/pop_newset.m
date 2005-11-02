% pop_newset() - Edit EEG dataset structure information. 
%
% Usage:
%   >> [ALLEEG EEG CURRENTSET] = pop_newset( ALLEEG, EEG, CURRENTSET, ...
%                                            'key', val,...);
% Inputs and outputs:
%   ALLEEG     - array of EEG dataset structures
%   EEG        - current dataset structure or structure array
%   CURRENTSET - index/indices of the current EEG dataset(s) in ALLEEG
%
% Optional inputs:
%   'setname'     - Name of the new dataset
%   'comments'    - ['string'] comments on the new dataset
%   'overwrite'   - ['on'|'off'] overwrite the parent dataset (ignored
%                    if the eeg_options.m dataset overwrite option is set).
%   'save'        - ['filename'] filename to use to save the dataset
%   'retrieve'    - [index] retrieve this current ALLEEG dataset 
%
% Note: Calls eeg_store() which may modify the variable ALLEEG 
%       containing the current dataset(s).
%
% Author: Arnaud Delorme, CNL / Salk Institute, 23 Arpil 2002
%
% See also: eeg_store(), pop_editset(), eeglab()

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 23 Arpil 2002 Arnaud Delorme, Salk Institute, arno@salk.edu
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% $Log: not supported by cvs2svn $
% Revision 1.30  2005/09/27 22:03:38  arno
% save multiple datasets
%
% Revision 1.29  2005/08/16 17:54:39  scott
% edit help message. EEG.changes_not_saved -> EEG.saved   -sm
%
% Revision 1.28  2005/08/08 18:43:33  arno
% do not erase filename and filepath
%
% Revision 1.27  2005/08/08 18:40:59  arno
% fix saving file
%
% Revision 1.26  2005/08/04 17:25:18  arno
% typo
%
% Revision 1.25  2005/08/04 16:28:55  arno
% modified -> changes to save
%
% Revision 1.24  2005/08/04 16:27:30  arno
% implement EEG.modified
%
% Revision 1.23  2005/08/04 15:36:48  arno
% remove option of keeping only 1 dataset
%
% Revision 1.22  2005/07/30 01:22:24  arno
% allowing to remove channels for multiple datasets
%
% Revision 1.21  2004/07/07 19:07:30  arno
% return empty if cancel
%
% Revision 1.20  2003/12/05 20:01:05  arno
% eeg_hist for history
%
% Revision 1.19  2003/12/05 00:48:28  arno
% saving setname
%
% Revision 1.18  2003/07/20 19:37:11  scott
% typo
%
% Revision 1.17  2003/05/30 16:48:31  arno
% removing debug message
%
% Revision 1.16  2003/05/12 15:35:22  arno
% updated output command
%
% Revision 1.15  2003/02/27 00:38:58  arno
% typo
%
% Revision 1.14  2003/02/03 20:01:58  arno
% debugging overwrite option call from the command line
%
% Revision 1.13  2003/02/03 01:46:42  scott
% header edits -sm
%
% Revision 1.12  2002/12/04 19:11:35  arno
% macOSX directory compatibility
%
% Revision 1.11  2002/11/14 17:40:55  arno
% comment -> description
%
% Revision 1.10  2002/10/23 15:04:00  arno
% isppc -> computer
%
% Revision 1.9  2002/10/15 23:28:07  arno
% debugging dataset save
%
% Revision 1.8  2002/10/15 17:07:19  arno
% drawnow
%
% Revision 1.7  2002/10/10 17:08:29  arno
% output command ';'
%
% Revision 1.6  2002/08/14 01:29:17  arno
% updating save
%
% Revision 1.5  2002/08/12 18:33:48  arno
% questdlg2
%
% Revision 1.4  2002/05/03 03:05:11  arno
% editing interface
%
% Revision 1.3  2002/05/03 02:59:44  arno
% debugging cancel
%
% Revision 1.2  2002/04/26 02:51:26  arno
% adding com parameter
%
% Revision 1.1  2002/04/26 02:46:37  arno
% Initial revision
%

%   'aboutparent' - ['on'|'off'] insert reference to parent dataset in the comments

function [ALLEEG, EEG, CURRENTSET, com] = pop_newset( ALLEEG, EEG, CURRENTSET, varargin);

com = '';
if nargin < 3
   help pop_newset;
   return;
end;   

if nargin < 4 & length(EEG) == 1 % if several arguments, assign values 
    % popup window parameters	
    % -----------------------
    comcomment = ['tmpuserdat = get(gcbf, ''userdata'');' ...
				  'tmpuserdat{1} = pop_comments(tmpuserdat{1}, ''Edit dataset comments'');' ...
				  'set(gcbf, ''userdata'', tmpuserdat); clear tmpuserdat;'];
	comsave    = ['tmpuserdat = get(gcbf, ''userdata'');' ...
				  '[tmpfile tmppath] = uiputfile(''*.set'', ''Enter filename''); drawnow;' ...
				  'if tmpfile ~= 0,' ...
			      '    tmpuserdat{2} = strcat(tmppath, tmpfile);' ...
				  '    set(gcbf, ''userdata'', tmpuserdat);' ...
				  '    set(findobj(''parent'', gcbf, ''tag'', ''saveedit''), ''string'', tmpuserdat{2});' ...
				  'end;' ...
				  'clear tmpuserdat tmpfile tmppath;'];
    comover   = [ 'tmpuserdat = get(gcbf, ''userdata'');' ...
				  'tmpuserdat{3} = get(gcbo, ''value'');' ...
				  'set(gcbf, ''userdata'', tmpuserdat); clear tmpuserdat;'];
	userdat = { EEG.comments, '', comover };
    geometry    = { [1 3 1] [1] [1.5 1.8 1 0.5 1.5]};
    uilist = { ...
         { 'Style', 'text', 'string', 'Dataset name:', 'horizontalalignment', 'right', 'fontweight', 'bold' }, ...
		 { 'Style', 'edit', 'string', EEG.setname } ...
		 { 'Style', 'pushbutton', 'string', 'Description', 'tooltipstring', 'Modify comments of this new dataset', 'callback', comcomment }, ...
		 {} ...
         ...
         { 'Style', 'text', 'string', 'File to save dataset', 'tooltipstring', 'It is advised to save dataset as often as possible' }, ...
         { 'Style', 'edit', 'string', '', 'tag', 'saveedit' }, ...
         { 'Style', 'pushbutton', 'string', 'Browse', 'tooltipstring', 'It is advised to save dataset as often as possible', 'callback', comsave }, ...
         {} { 'Style', 'checkbox'  , 'string', 'Overwrite parent', 'tooltipstring', 'Overwritting parent dataset can help to save memory', 'callback', comover }, ...
		...
         %{ 'Style', 'pushbutton', 'string', 'Memory options', 'tooltipstring', 'Change these options if your computer is short in memory' }, ...
	};

    [result userdat] = inputgui( geometry, uilist, 'pophelp(''pop_newset'');', ...
								  fastif(isempty(EEG.data), 'Import dataset info -- pop_newset()', 'Edit dataset info -- pop_newset()'), userdat);
    if length(result) == 0,
		args = { 'retrieve', CURRENTSET };
	else 
		args = { 'setname', result{1} };
		if ~isempty(result{2}) 
			args = { args{:} 'save', result{2} };
		end;
		if ~strcmp(EEG.comments, userdat{1})
			args = { args{:} 'comments', userdat{1} };
		end;
		if userdat{3} == 1
			args = { args{:} 'overwrite' 'on' };
		end;
	end;
elseif length(EEG) > 1
    % processing multiple datasets
    % ----------------------------
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, CURRENTSET ); % it is possible to undo the operation here
    com = '[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, CURRENTSET );';
    return;
else
    % no interactive inputs
    args = varargin;
end;

% assigning values
% ----------------
overWflag    = 0;
EEG.saved = 'no';
for ind = 1:2:length(args)
    switch lower(args{ind})
	 case 'setname'   , EEG.setname = args{ind+1}; EEG = eeg_hist(EEG, [ 'EEG.setname=''' EEG.setname ''';' ]);
	 case 'comments'  , EEG.comments = args{ind+1};
	 case 'retrieve'  , if ~isempty(ALLEEG) 
                            EEG = eeg_retrieve(ALLEEG, args{ind+1}); 
                        else
                            EEG = eeg_emptyset;
                        end;
                        overWflag = 1; com = ''; return;
	 case 'save'      , [filepath filename ext] = fileparts( args{ind+1} );
                        EEG.saved = 'yes';
                        EEG = pop_saveset(EEG, [ filename ext ], filepath);
	 case 'overwrite' , if strcmpi(args{ind+1}, 'on') | strcmpi(args{ind+1}, 'yes')
                            overWflag = 1; 
                        end;
	 otherwise, error(['pop_newset error: unrecognized key ''' args{ind} '''']); 
    end;
end;
if overWflag
	[ALLEEG, EEG] = eeg_store( ALLEEG, EEG, CURRENTSET);
else
	[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0); % 0 means that it is saved on disk
end;
	
% generate the output command
% ---------------------------
com = sprintf( '[ALLEEG EEG %s] = pop_newset(ALLEEG, EEG, %s, %s);', inputname(3), inputname(3), vararg2str(args));
return;

function num = popask( text )
	 ButtonName=questdlg2( text, ...
	        'Confirmation', 'Cancel', 'Yes','Yes');
	 switch lower(ButtonName),
	      case 'cancel', num = 0;
	      case 'yes',    num = 1;
	 end;
