% pop_rejmenu() - Main menu for rejecting trials in an EEG dataset
%
% Usage: >> pop_rejmenu(INEEG, typerej);
%
% Inputs:
%   INEEG      - input dataset
%   typerej    - type of rejection (0 = based on independent components; 
%                1 = based on raw data). Default is 1 (reject on raw data).
%
% Author: Arnaud Delorme, CNL / Salk Institute, 2001
%
% See also: eeglab(), pop_eegplot(), pop_eegthresh, pop_rejtrend()
% pop_rejkurt(), pop_jointprob(), pop_rejspec() 

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 2001 Arnaud Delorme, Salk Institute, arno@salk.edu
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
% Revision 1.15  2002/11/12 16:16:57  scott
% button text
%
% Revision 1.14  2002/08/22 02:11:12  arno
% text edit
%
% Revision 1.13  2002/08/14 18:21:53  arno
% new supergui arg
%
% Revision 1.12  2002/08/14 16:06:58  arno
% updating size of buttons
%
% Revision 1.11  2002/08/14 00:58:51  arno
% debug some calls
%
% Revision 1.10  2002/08/13 19:01:06  arno
% remove manual size constraint
%
% Revision 1.9  2002/08/13 17:31:35  arno
% new supergui call
%
% Revision 1.8  2002/08/12 22:26:28  arno
% button color and text
%
% Revision 1.7  2002/08/07 22:23:00  arno
% editing spelling
%
% Revision 1.6  2002/08/02 14:27:15  arno
% changing default
%
% Revision 1.5  2002/07/31 18:25:56  arno
% changing default
%
% Revision 1.4  2002/07/31 17:07:26  arno
% debugging
%
% Revision 1.3  2002/07/30 23:39:34  arno
% rejection with lots of colors
%
% Revision 1.2  2002/07/26 17:01:17  arno
% debugging icacomp
%
% Revision 1.1  2002/04/05 17:46:04  jorn
% Initial revision
%
% 01-25-02 reformated help & license -ad 

function cb_compthresh = pop_rejmenu( EEG, icacomp ); 

if icacomp == 0
	if isempty( EEG.icasphere )
		disp('Error: you must first run ICA on the data'); return;
	end;
end;

if icacomp == 1 	rejtitle = 'Reject trials using data statistics - pop_rejmenu()'; tagmenu = 'rejtrialraw';
else            	rejtitle = 'Reject trials using ICA activity statistics - pop_rejmenu()'; tagmenu = 'rejtrialica';
end;	

if ~isempty( findobj('tag', tagmenu))
	error('cannot open two identical windows; close the first one first');
end;

figure('visible', 'off', 'numbertitle', 'off', 'name', rejtitle, 'tag', tagmenu);

% definition of callbacks
% -----------------------
checkstatus = [ 'rejstatus = get( findobj(''parent'', gcbf, ''tag'', ''rejstatus''), ''value'');' ...
                'if rejstatus == 3,' ...
                '    EEG.reject.disprej = {};' ...
				'    if get( findobj(''parent'', gcbf, ''tag'', ''IManual''), ''value''), EEG.reject.disprej{1} = ''manual''; end;' ...
                '    if get( findobj(''parent'', gcbf, ''tag'', ''IThresh''), ''value''), EEG.reject.disprej{2} = ''thresh''; end;' ...
                '    if get( findobj(''parent'', gcbf, ''tag'', ''IConst''), ''value''), EEG.reject.disprej{3} = ''const''; end;' ...
                '    if get( findobj(''parent'', gcbf, ''tag'', ''IEnt''), ''value''), EEG.reject.disprej{4} = ''jp''; end;' ...
                '    if get( findobj(''parent'', gcbf, ''tag'', ''IKurt''), ''value''), EEG.reject.disprej{5} = ''kurt''; end;' ...
                '    if get( findobj(''parent'', gcbf, ''tag'', ''IFreq''), ''value''), EEG.reject.disprej{6} = ''freq''; end;' ...
                'end;' ...
                'rejstatus = rejstatus-1;' ]; % from 1-3 range, go to 0-2 range

tmp_com =         [ '  set(findobj(''''parent'''', findobj(''''tag'''', ''''' tagmenu ...
					'''''), ''''tag'''', ''''mantrial''''), ''''string'''', num2str(sum(tmprej)));']; 
cb_manual = [ 	checkstatus ...
				'pop_eegplot( EEG, ' int2str( icacomp ) ', rejstatus, 0,''' tmp_com ''');' ...
				'clear rejstatus;' ]; 

% -----------------------------------------------------

% tmp_com is used when returning from eegplot
tmp_com =       [ '  set(findobj(''''parent'''', findobj(''''tag'''', ''''' tagmenu ...
				  '''''), ''''tag'''', ''''threshtrial''''), ''''string'''', num2str(sum(tmprej)));']; 
cb_compthresh = [ '  posthresh = get( findobj(''parent'', gcbf, ''tag'', ''threshpos''), ''string'' );' ...
                  '  negthresh = get( findobj(''parent'', gcbf, ''tag'', ''threshneg''), ''string'' );' ...
                  '  startime  = get( findobj(''parent'', gcbf, ''tag'', ''threshstart''), ''string'' );' ...
                  '  endtime   = get( findobj(''parent'', gcbf, ''tag'', ''threshend''), ''string'' );' ...
                  '  elecrange = get( findobj(''parent'', gcbf, ''tag'', ''threshelec''), ''string'' );' ...
                  checkstatus ...
				  '[EEG Itmp LASTCOM] = pop_eegthresh( EEG,' int2str(icacomp) ...
				  ', elecrange, negthresh, posthresh, startime, endtime, rejstatus, 0,''' tmp_com ''');' ...
				  'h(LASTCOM);' ...
				  'clear com Itmp elecrange posthresh negthresh startime endtime rejstatus;' ];

%                  '  set(findobj(''parent'', gcbf, ''tag'', ''threshtrial''), ''string'', num2str(EEG.trials - length(Itmp)));' ...
%				  'h(LASTCOM);' ...
%				  'clear Itmp elecrange posthresh negthresh startime endtime rejstatus;' ];

% -----------------------------------------------------
tmp_com =       [ '  set(findobj(''''parent'''', findobj(''''tag'''', ''''' tagmenu ...
				  '''''), ''''tag'''', ''''freqtrial''''), ''''string'''', num2str(sum(tmprej)));']; 
cb_compfreq   = [ '  posthresh = get( findobj(''parent'', gcbf, ''tag'', ''freqpos''), ''string'' );' ...
                  '  negthresh = get( findobj(''parent'', gcbf, ''tag'', ''freqneg''), ''string'' );' ...
                  '  startfreq = get( findobj(''parent'', gcbf, ''tag'', ''freqstart''), ''string'' );' ...
                  '  endfreq   = get( findobj(''parent'', gcbf, ''tag'', ''freqend''), ''string'' );' ...
                  '  elecrange = get( findobj(''parent'', gcbf, ''tag'', ''freqelec''), ''string'' );' ...
                  checkstatus ...
				  '[EEG Itmp LASTCOM] = pop_rejspec( EEG,' int2str(icacomp) ...
				  ', elecrange, negthresh, posthresh, startfreq, endfreq, rejstatus, 0,''' tmp_com ''');' ...
				  'h(LASTCOM);' ...
				  'clear Itmp elecrange posthresh negthresh startfreq endfreq rejstatus;' ];

% -----------------------------------------------------
tmp_com =         [ '  set(findobj(''''parent'''', findobj(''''tag'''', ''''' tagmenu ...
					'''''), ''''tag'''', ''''consttrial''''), ''''string'''', num2str(sum(tmprej)));']; 
cb_compconstrej = [ '  minslope   = get( findobj(''parent'', gcbf, ''tag'', ''constpnts''), ''string'' );' ...
					'  minstd    = get( findobj(''parent'', gcbf, ''tag'', ''conststd''), ''string'' );' ...
					'  elecrange = get( findobj(''parent'', gcbf, ''tag'', ''constelec''), ''string'' );' ...
                    checkstatus ...
				    '[rej LASTCOM] = pop_rejtrend(EEG,' int2str(icacomp) ', elecrange, ''' ...
					int2str(EEG.pnts) ''', minslope, minstd, rejstatus, 0,''' tmp_com ''');' ...
				    'h(LASTCOM);' ...
				    'clear rej elecrange minslope minstd rejstatus;' ];

% -----------------------------------------------------
tmp_com =        [ '  set(findobj(''''parent'''', findobj(''''tag'''', ''''' tagmenu ...
				   '''''), ''''tag'''', ''''enttrial''''), ''''string'''', num2str(sum(tmprej)));']; 
cb_compenthead = [ '  locthresh  = get( findobj(''parent'', gcbf, ''tag'', ''entloc''), ''string'' );', ...
				   '  globthresh = get( findobj(''parent'', gcbf, ''tag'', ''entglob''), ''string'' );', ...
				   '  elecrange  = get( findobj(''parent'', gcbf, ''tag'', ''entelec''), ''string'' );' ];
cb_compenttail = [ '  set( findobj(''parent'', gcbf, ''tag'', ''entloc''), ''string'', num2str(locthresh) );', ...
				   '  set( findobj(''parent'', gcbf, ''tag'', ''entglob''), ''string'', num2str(globthresh) );', ...
				   '  set( findobj(''parent'', gcbf, ''tag'', ''enttrial''), ''string'', num2str(nrej) );' ...
				   'h(LASTCOM);' ...
				   'clear nrej elecrange locthresh globthresh rejstatus;' ];
cb_compentplot =  [ cb_compenthead ...	
				    '[EEG locthresh globthresh nrej LASTCOM] = pop_jointprob( EEG, ' int2str(icacomp) ...
					', elecrange, locthresh, globthresh, 0, 0,''' tmp_com ''');', ...
				    cb_compenttail ];
cb_compentcalc =  [ cb_compenthead ...	
				    '[EEG locthresh globthresh nrej LASTCOM] = pop_jointprob( EEG, ' int2str(icacomp) ...
					', [ str2num(elecrange) ], str2num(locthresh), str2num(globthresh), 0, 0);', ...
 				    cb_compenttail ];
cb_compenteeg  =  [ cb_compenthead ...	
                    checkstatus ...
				    '[EEG locthresh globthresh nrej LASTCOM] = pop_jointprob( EEG, ' int2str(icacomp) ...
					', elecrange, locthresh, globthresh, rejstatus, 0, 1,''' tmp_com ''');', ...
 				    cb_compenttail ];

% -----------------------------------------------------
tmp_com =        [ '  set(findobj(''''parent'''', findobj(''''tag'''', ''''' tagmenu ...
				   '''''), ''''tag'''', ''''kurttrial''''), ''''string'''', num2str(sum(tmprej)));']; 
cb_compkurthead =[ '  locthresh  = get( findobj(''parent'', gcbf, ''tag'', ''kurtloc''), ''string'' );', ...
				   '  globthresh = get( findobj(''parent'', gcbf, ''tag'', ''kurtglob''), ''string'' );', ...
				   '  elecrange  = get( findobj(''parent'', gcbf, ''tag'', ''kurtelec''), ''string'' );' ];
cb_compkurttail =[ '  set( findobj(''parent'', gcbf, ''tag'', ''kurtloc''), ''string'', num2str(locthresh) );', ...
				   '  set( findobj(''parent'', gcbf, ''tag'', ''kurtglob''), ''string'', num2str(globthresh) );', ...
				   '  set( findobj(''parent'', gcbf, ''tag'', ''kurttrial''), ''string'', num2str(nrej) );' ...
				   'h(LASTCOM);' ...
				   'clear nrej elecrange locthresh globthresh rejstatus;' ];
cb_compkurtplot = [ cb_compkurthead ...	
				    '[EEG locthresh globthresh nrej LASTCOM] = pop_rejkurt( EEG, ' int2str(icacomp) ...
					', elecrange, locthresh, globthresh, 0, 0,''' tmp_com ''');', ...
				    cb_compkurttail ];
cb_compkurtcalc = [ cb_compkurthead ...	
				    '[EEG locthresh globthresh nrej LASTCOM] = pop_rejkurt( EEG, ' int2str(icacomp) ...
					', [ str2num(elecrange) ], str2num(locthresh), str2num(globthresh), 0, 0);', ...
 				    cb_compkurttail ];
cb_compkurteeg  = [ cb_compkurthead ...	
                    checkstatus ...
				    '[EEG locthresh globthresh nrej LASTCOM] = pop_rejkurt( EEG, ' int2str(icacomp) ...
					', elecrange, locthresh, globthresh, rejstatus, 0, 1,''' tmp_com ''');', ...
 				    cb_compkurttail ];

% -----------------------------------------------------
cb_reject =      [ 'set( findobj(''parent'', gcbf, ''tag'', ''rejstatus''), ''value'', 3);' ... % force status to 3 
				    checkstatus ...
				   '[EEG LASTCOM] = eeg_rejsuperpose(EEG,' int2str(icacomp) ',1,1,1,1,1,1,1); h(LASTCOM);' ...
				   '[EEG LASTCOM] = pop_rejepoch( EEG, EEG.reject.rejglobal, 1);' ...
				   'if ~isempty(LASTCOM), ' ...
				   '   h(LASTCOM); [ALLEEG EEG CURRENTSET LASTCOM] = pop_newset(ALLEEG, EEG, CURRENTSET); h(LASTCOM);' ...
				   'end; eeglab redraw; close(gcbf);' ];

cb_clear =       [ 'close gcbf; EEG = rmfield( EEG, ''reject''); EEG.reject.rejmanual = [];' ...
				   'EEG=eeg_checkset(EEG); pop_rejmenu(' inputname(1) ',' int2str(icacomp) ');' ];   

cb_close =       [ 'close gcbf;' ...
				   'disp(''Marks stored in dataset'');' ...
				   '[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);' ...
				   'h(''[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);'');'];   

lisboxoptions = { 'string', [ 'Show only the new trials marked for rejection by the measure selected above|' ...
                  'Show previous and new trials marked for rejection by the measure selected above|' ...
                  'Show all trials marked for rejection by the measure selected above or checked below'], 'tag', 'rejstatus', 'value', 1, 'callback', ...
                  [ 'if get(gcbo, ''value'') == 3,' ...
                    '   set(findobj(''parent'', gcbf, ''style'', ''checkbox''), ''enable'', ''on'');' ...
                    'else' ...
                    '   set(findobj(''parent'', gcbf, ''style'', ''checkbox''), ''enable'', ''off'');' ...
                    'end;' ] };

	chanliststr = ['List of ' fastif(icacomp,'electrode(s)','component(s)') ];
	chanlistval = fastif(icacomp, [ '1:' int2str(EEG.nbchan) ], [ '1:' int2str(size(EEG.icaweights,1)) ]);
	
	% assess previous rejections
	% --------------------------
	sizeman = 0; 
	sizethresh = 0;
	sizetrend = 0;
	sizejp = 0;
	sizekurt = 0;
	sizespec = 0;
	if icacomp == 1
		if ~isempty(EEG.reject.rejmanual), sizeman   = length(find(EEG.reject.rejmanual)); end;
		if ~isempty(EEG.reject.rejconst),  sizetrend = length(find(EEG.reject.rejconst)); end;
		if ~isempty(EEG.reject.rejjp),     sizejp    = length(find(EEG.reject.rejjp)); end;
		if ~isempty(EEG.reject.rejkurt),   sizekurt  = length(find(EEG.reject.rejkurt)); end;
		if ~isempty(EEG.reject.rejfreq),   sizespec  = length(find(EEG.reject.rejfreq)); end;
	else 
		if ~isempty(EEG.reject.icarejmanual), sizeman   = length(find(EEG.reject.icarejmanual)); end;
		if ~isempty(EEG.reject.icarejconst),  sizetrend = length(find(EEG.reject.icarejconst)); end;
		if ~isempty(EEG.reject.icarejjp),     sizejp    = length(find(EEG.reject.icarejjp)); end;
		if ~isempty(EEG.reject.icarejkurt),   sizekurt  = length(find(EEG.reject.icarejkurt)); end;
		if ~isempty(EEG.reject.icarejfreq),   sizespec  = length(find(EEG.reject.icarejfreq)); end;	
	end;
		
    stdl = [0.25 1.2 0.8 1.2 0.8]; % standard line
	titl = [0.9 0.18 1.55]; % title line
    geometry = { 	[0.883 0.195 .2 .45 .4 .4] ...
					[1] titl stdl stdl stdl stdl ...
					[1] titl stdl stdl stdl  ...
					[1] titl stdl stdl stdl  ...
					[1] titl stdl stdl stdl  ...
					[1] titl stdl stdl stdl stdl ...
					[1] [1] [1] [1 1 1] [1 1 1]  ...
					[1] [1 1 1]};
	
	listui = {{'Style', 'text', 'string', 'Mark trials by appearance', 'fontweight', 'bold' }, ...
    {  'Style', 'pushbutton', 'string', '', 'tag', 'butmanual', ...
	   'callback', [ 'tmpcolor = uisetcolor(EEG.reject.rejmanualcol); if length(tmpcolor) ~= 1,' ...
	   'EEG.reject.rejmanualcol=tmpcolor; set(gcbo, ''backgroundcolor'', tmpcolor); end; clear tmpcolor;'] },...
	{ } { 'Style', 'pushbutton', 'string', 'Scroll Data', 'callback', cb_manual }, ...
	{ 'Style', 'text', 'string', 'Marked trials:' }, ...
	{ 'Style', 'text', 'string', int2str(sizeman), 'tag', 'mantrial' }, ...
	{ }, ...
	... % ---------------------------------------------------------------------------
	{ 'Style', 'text', 'string', 'Find abnormal values', 'fontweight', 'bold' }, ...
    {  'Style', 'pushbutton', 'string', '', 'tag', 'butthresh',  ...
	   'callback', [ 'tmpcolor = uisetcolor(EEG.reject.rejthreshcol); if length(tmpcolor) ~= 1,' ...
	   'EEG.reject.rejthreshcol=tmpcolor; set(gcbo, ''backgroundcolor'', tmpcolor); end; clear tmpcolor;'] }, { },...
	...
	{ }, { 'Style', 'text', 'string', ['Upper limit(s) ' fastif(icacomp,'(uV)', '(std.)')] }, ...
	{ 'Style', 'edit', 'string', '25', 'tag', 'threshpos' }, ...
	{ 'Style', 'text', 'string', ['Lower limit(s) ' fastif(icacomp,'(uV)', '(std.)')] }, ...
	{ 'Style', 'edit', 'string', '-25', 'tag', 'threshneg' }, ...
	...
	{ }, { 'Style', 'text', 'string', 'Start time(s) (ms)' }, ...
	{ 'Style', 'edit', 'string', int2str(EEG.xmin*1000), 'tag', 'threshstart' }, ...
	{ 'Style', 'text', 'string', 'Ending time(s) (ms)' }, ... 
	{ 'Style', 'edit', 'string', int2str(EEG.xmax*1000), 'tag', 'threshend' }, ...
	...
	{ }, { 'Style', 'text', 'string', chanliststr }, ...
	{ 'Style', 'edit', 'string', chanlistval, 'tag', 'threshelec' }, ...
	{ 'Style', 'text', 'string', 'Marked trials:' }, ...
	{ 'Style', 'text', 'string', int2str(sizethresh), 'tag', 'threshtrial' }, ...
	...
	{ }, { 'Style', 'pushbutton', 'string', 'Calc / Plot', 'callback', cb_compthresh }, ...
	{ }, { },{ 'Style', 'pushbutton', 'string', 'HELP', 'callback', 'pophelp(''pop_eegthresh'');' }, ...
	... % ---------------------------------------------------------------------------
	{ }, { 'Style', 'text', 'string', 'Find abnormal trends', 'fontweight', 'bold' }, ...
    {  'Style', 'pushbutton', 'string', '', 'tag', 'buttrend', ...
	   'callback', [ 'tmpcolor = uisetcolor(EEG.reject.rejconstcol); if length(tmpcolor) ~= 1,' ...
	   'EEG.reject.rejconstcol=tmpcolor; set(gcbo, ''backgroundcolor'', tmpcolor); end; clear tmpcolor;'] }, { },...
	...
	{ }, { 'Style', 'text', 'string', ['Max slope ' fastif(icacomp, '(uV/epoch)', '(unit/epoch)') ] }, ...
	{ 'Style', 'edit', 'string', '50', 'tag', 'constpnts' }, ...
	{ 'Style', 'text', 'string', 'R^2 limit' }, ...
	{ 'Style', 'edit', 'string', '0.3', 'tag', 'conststd'  }, ...
    ...
	{ }, { 'Style', 'text', 'string', chanliststr }, ...
	{ 'Style', 'edit', 'string', chanlistval, 'tag', 'constelec'  }, ...
	{ 'Style', 'text', 'string', 'Marked trials:' }, ...
	{ 'Style', 'text', 'string', int2str(sizetrend), 'tag', 'consttrial'  }, ...	
	...
	{ }, { 'Style', 'pushbutton', 'string', 'Calc / Plot', 'callback', cb_compconstrej }, ...
	{ }, { }, { 'Style', 'pushbutton', 'string', 'HELP', 'callback', 'pophelp(''pop_rejtrend'');' }, ...
	...  % ---------------------------------------------------------------------------
	{ }, { 'Style', 'text', 'string', 'Find improbable data', 'fontweight', 'bold' }, ...
    {  'Style', 'pushbutton', 'string', '',  'tag', 'butjp', ...
	   'callback', [ 'tmpcolor = uisetcolor(EEG.reject.rejjpcol); if length(tmpcolor) ~= 1,' ...
	   'EEG.reject.rejjpcol=tmpcolor; set(gcbo, ''backgroundcolor'', tmpcolor); end; clear tmpcolor;'] }, { },...
	...
	{ }, { 'Style', 'text', 'string', fastif(icacomp, 'Single-channel limit (std.)', 'Single-comp. limit (std.)') }, ...
	{ 'Style', 'edit', 'string', '5', 'tag', 'entloc' }, ...
	{ 'Style', 'text', 'string', fastif(icacomp, 'All channels limit (std.)', 'All comp. limit (std.)') }, ...
	{ 'Style', 'edit', 'string', '5', 'tag', 'entglob' }, ...
    ...
	{ }, { 'Style', 'text', 'string', chanliststr }, ...
	{ 'Style', 'edit', 'string', chanlistval, 'tag', 'entelec' }, ...
	{ 'Style', 'text', 'string', 'Marked trials:' }, ...
	{ 'Style', 'text', 'string', int2str(sizejp), 'tag', 'enttrial' }, ...	
	...
	{ }, { 'Style', 'pushbutton', 'string', 'Calculate', 'callback', cb_compentcalc }, ...
	{ 'Style', 'pushbutton', 'string', 'Scroll Data', 'callback', cb_compenteeg }, ...
	{ 'Style', 'pushbutton', 'string', 'PLOT', 'callback', cb_compentplot }, ...
	{ 'Style', 'pushbutton', 'string', 'HELP', 'callback', 'pophelp(''pop_jointprob'');' }, ...
	...  % ---------------------------------------------------------------------------
	{ }, { 'Style', 'text', 'string', 'Find abnormal distributions', 'fontweight', 'bold' }, ...
    {  'Style', 'pushbutton', 'string', '', 'tag', 'butkurt', ...
	   'callback', [ 'tmpcolor = uisetcolor(EEG.reject.rejkurtcol); if length(tmpcolor) ~= 1,' ...
	   'EEG.reject.rejkurtcol=tmpcolor; set(gcbo, ''backgroundcolor'', tmpcolor); end; clear tmpcolor;'] }, { },...
	...
	{ }, { 'Style', 'text', 'string', fastif(icacomp, 'Single-channel limit (std.)', 'Single-comp. limit (std.)') }, ...
	{ 'Style', 'edit', 'string', '5', 'tag', 'kurtloc' }, ...
	{ 'Style', 'text', 'string', fastif(icacomp, 'All channels limit (std.)', 'All comp. limit (std.)') }, ...
	{ 'Style', 'edit', 'string', '5', 'tag', 'kurtglob' }, ...
    ...
	{ }, { 'Style', 'text', 'string', chanliststr }, ...
	{ 'Style', 'edit', 'string', chanlistval, 'tag', 'kurtelec' }, ...
	{ 'Style', 'text', 'string', 'Marked trials:' }, ...
	{ 'Style', 'text', 'string', int2str(sizekurt), 'tag', 'kurttrial' }, ...	
	...
	{ }, { 'Style', 'pushbutton', 'string', 'Calculate', 'callback', cb_compkurtcalc }, ...
	{ 'Style', 'pushbutton', 'string', 'Scroll Data', 'callback', cb_compkurteeg }, ...
	{ 'Style', 'pushbutton', 'string', 'PLOT', 'callback', cb_compkurtplot }, ...
	{ 'Style', 'pushbutton', 'string', 'HELP', 'callback', 'pophelp(''pop_rejkurt'');' }, ...
	... % ---------------------------------------------------------------------------
	{ }, { 'Style', 'text', 'string', 'Find abnormal spectra (efficient but slow)', 'fontweight', 'bold' }, ...
    {  'Style', 'pushbutton', 'string', '', 'tag', 'butspec', ...
	   'callback', [ 'tmpcolor = uisetcolor(EEG.reject.rejfreqcol); if length(tmpcolor) ~= 1,' ...
	   'EEG.reject.rejfreqcol=tmpcolor; set(gcbo, ''backgroundcolor'', tmpcolor); end; clear tmpcolor;'] }, { },...
	...
	{ }, { 'Style', 'text', 'string', 'Upper limit(s) (dB)' }, ...
	{ 'Style', 'edit', 'string', '25', 'tag', 'freqpos' }, ...
	{ 'Style', 'text', 'string', 'Lower limit(s) (dB)' }, ...
	{ 'Style', 'edit', 'string', '-25', 'tag', 'freqneg' }, ...
	...
	{ }, { 'Style', 'text', 'string', 'Low frequency(s) (Hz)' }, ...
	{ 'Style', 'edit', 'string', '0', 'tag', 'freqstart' }, ...
	{ 'Style', 'text', 'string', 'High frequency(s) (Hz)' }, ... 
	{ 'Style', 'edit', 'string', '50', 'tag', 'freqend' }, ...
	...
	{ }, { 'Style', 'text', 'string', chanliststr }, ...
	{ 'Style', 'edit', 'string', chanlistval, 'tag', 'freqelec' }, ...
	{ 'Style', 'text', 'string', 'Marked trials:' }, ...
	{ 'Style', 'text', 'string', int2str(sizespec), 'tag', 'freqtrial' }, ...
	...
	{ }, { 'Style', 'pushbutton', 'string', 'Calc / Plot', 'callback', cb_compfreq }, ...
	{ }, { },{ 'Style', 'pushbutton', 'string', 'HELP', 'callback', 'pophelp(''pop_rejspec'');' }, ...
    ...
    {}, ...  % ---------------------------------------------------------------------------
	...
	{ 'Style', 'text', 'string', 'Select plotting options', 'fontweight', 'bold' }, ...
	{ 'style', 'listbox', lisboxoptions{:} }, ...
	{ 'style', 'checkbox', 'String', 'Abnormal appearance', 'tag', 'IManual', 'value', 1, 'enable', 'off'}, ...
	{ 'style', 'checkbox', 'String', 'Abnormal values', 'tag', 'IThresh', 'value', 1, 'enable', 'off'}, ...
	{ 'style', 'checkbox', 'String', 'Abnormal trends', 'tag', 'IConst', 'value', 1, 'enable', 'off'}, ...
	{ 'style', 'checkbox', 'String', 'Improbable epochs', 'tag', 'IEnt', 'value', 1, 'enable', 'off'}, ...
	{ 'style', 'checkbox', 'String', 'Abnormal distributions', 'tag', 'IKurt', 'value', 1, 'enable', 'off'}, ...
	{ 'style', 'checkbox', 'String', 'Abnormal spectra', 'tag', 'IFreq', 'value', 1, 'enable', 'off'}, ...
	...
	{ }, ...
 	{ 'Style', 'pushbutton', 'string', 'CLOSE (KEEP MARKS)', 'callback', cb_close }, ...
 	{ 'Style', 'pushbutton', 'string', 'CLEAR ALL MARKS', 'callback', cb_clear  }, ...
	{ 'Style', 'pushbutton', 'string', 'REJECT MARKED TRIALS', 'callback', cb_reject }};

	allh = supergui( gcf, geometry, [], listui{:});

%	{ 'style', 'checkbox', 'String', ['Include ' fastif(icacomp, 'ica data', 'raw data')], 'tag', 'IOthertype', 'value', 1}, { }, ...
set(gcf, 'userdata', { allh });	
set(findobj('parent', gcf', 'tag', 'butmanual'), 'backgroundcolor', EEG.reject.rejmanualcol);
set(findobj('parent', gcf', 'tag', 'butthresh'), 'backgroundcolor', EEG.reject.rejthreshcol);
set(findobj('parent', gcf', 'tag', 'buttrend'),  'backgroundcolor', EEG.reject.rejconstcol);
set(findobj('parent', gcf', 'tag', 'butjp'),     'backgroundcolor', EEG.reject.rejjpcol);
set(findobj('parent', gcf', 'tag', 'butkurt'),   'backgroundcolor', EEG.reject.rejkurtcol);
set(findobj('parent', gcf', 'tag', 'butspec'),   'backgroundcolor', EEG.reject.rejfreqcol);
set( findobj('parent', gcf, 'tag', 'rejstatus'), 'style', 'popup');

