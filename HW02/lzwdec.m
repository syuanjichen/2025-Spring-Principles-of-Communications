function [output, table] = lzwdec(vector)
%   lzwdec(X) returns the uncompressed vector of X using the LZW algorithm.
%   [output, table] = lzwdec(X) returns also the table that the algorithm produces.
%   Input X must be a uint16 vector.
%   Output 'output' is a uint8 vector.
%   Output 'table' is a cell array, each element containig the corresponding code.


% ensure to handle uint16 input vector
    if ~isa(vector,'uint16')
	    error('Input argument must be a uint16 vector.')
    end

% vector as a row
    vector = vector(:)';

% initialize table
    table = cell(1, 256);
    for index = 1:256
	    table{index} = uint16(index - 1);
    end

% initialize output
    output = uint8([]);

% Write your decoder here.
% Remember to also record the constructed table for comparison with the encoder table.
% Be careful in handling the situation where a code word is
% looked up before being added to the table.
% You may copy the "addcode" function from the encoder and use it here.

    oldcode = vector(1); % Locate the first code
    string = table{oldcode + 1};
    output = uint8(string);

    for index = 2:length(vector)
        newcode = vector(index);
        if newcode + 1 <= length(table) && ~isempty(table{newcode + 1})
            entry = table{newcode + 1};
        elseif newcode == length(table)
            % Special case: code not yet in dictionary
            entry = [string, string(1)];
        else
            error('Invalid LZW code');
        end
    
        output = [output, uint8(entry)];
    
        newstring = [string, entry(1)];
        [table, ~] = addcode(table, newstring);
    
        string = entry;
    end

% Print the decoded sentence.
    fprintf('%s\n', char(output));

end

function [table, code] = addcode(table, substr)
    code = length(table) + 1;  
    table{code} = substr;
    code = uint16(code - 1);    % Return code as 0-based (to match encoder)
end
