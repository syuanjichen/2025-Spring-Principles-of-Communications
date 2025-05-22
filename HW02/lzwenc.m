function [output, table] = lzwenc(vector)
%   lzwenc(X) returns the compressed vector of X using the LZW algorithm.
%   [output, table] = lzwenc(X) returns also the table that the algorithm produces.
%
%   Input X is a uint8 vector.
%   Output 'output' is a uint16 vector.
%   Output 'table' is a cell array, each element containig the corresponding code.

% ensure to handle uint8 input vector
if ~isa(vector,'uint8')
	error('input argument must be a uint8 vector')
end

% vector as uint16 row
vector = uint16(vector(:)');

% initialize table
table = cell(1,256);
for index = 1:256
	table{index} = uint16(index - 1);
end

% initialize output
output = vector;

% main loop
outputindex = 1;
startindex = 1;
for index = 2:length(vector)
	element = vector(index);
	substr = vector(startindex:(index - 1));
	code = getindexfor([substr element], table);
	if isempty(code) %if there's no same codeword in the codebook, add it to the table
		output(outputindex) = getindexfor(substr, table);
		[table, code] = addcode(table, [substr element]);
		outputindex = outputindex + 1;
		startindex = index;
	end
	% otherwise, keep increasing string length
end

substr = vector(startindex:index);
output(outputindex) = getindexfor(substr,table);

% remove not used positions
output((outputindex+1):end) = [];


% ###############################################
function code = getindexfor(substr, table)
code = uint16([]);
if length(substr) == 1
	code = substr;
else % this is to skip the first 256 known positions
	for index = 257:length(table)
		if isequal(substr, table{index})  % True if arrays are numerically equal
            % search the table
			code = uint16(index - 1);   % start from 0
			break
		end
	end
end


% ###############################################
function [table, code] = addcode(table, substr)
% the code index
% the indices should start from 1 internally since the array is indexed from 1 in matlab
code = length(table) + 1;  

table{code} = substr;
% the indices should start from 0 externally since the ASCII code starts
% from 0
code = uint16(code - 1);    
