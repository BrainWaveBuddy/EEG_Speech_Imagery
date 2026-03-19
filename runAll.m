addpath(".\utils")

function runIsolated(fname)
% Run script file fname inside this function's workspace. This is a fix
% that the following code clears the workspace when run calls a script that
% in turn calls clear.
run(fname);
end

% find all script files
files = dir('script_*.m');

for k = 1:numel(files)
    fname = fullfile(files(k).folder, files(k).name); % full path
    try
        runIsolated(fname);
    catch ME
        fprintf('Error running %s: %s\n', files(k).name, ME.message);
    end
end