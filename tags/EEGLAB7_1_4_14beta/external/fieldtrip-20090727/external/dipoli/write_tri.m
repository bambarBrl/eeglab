function write_tri(fn, pnt, dhk)

% WRITE_TRI writes a triangulation to a MBF file
%	write_tri(filename, pnt, dhk)
%
% See also READ_PNT, READ_TRI, WRITE_PNT

% Copyright (C) 1998, Robert Oostenveld
% 
% $Log: not supported by cvs2svn $
% Revision 1.1  2008/12/24 10:25:41  roboos
% cleaned up the dipoli wrapper, replaced the binary by a better one and added a copy of the helper functions (from fileio)
%
% Revision 1.2  2003/03/11 15:24:52  roberto
% updated help and copyrights
%

fid = fopen(fn, 'wt');
if fid~=-1

  % write the vertex points
  fprintf(fid, '%d\n', size(pnt,1));
  fprintf(fid, '%d\t%f\t%f\t%f\n', ([(1:size(pnt,1))' pnt])');

  % write the triangles
  fprintf(fid, '%d\n', size(dhk,1));
  fprintf(fid, '%d\t%d\t%d\t%d\n', ([(1:size(dhk,1))' dhk])');

  fclose(fid);

else
  error('unable to open file');
end


