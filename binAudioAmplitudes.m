function bins = binAudioAmplitudes(audio, onsets, Fs, epoch_duration, nbins, plot_amps)
% binAudioAmplitudes - Bin audio epochs based on maximum amplitude
%
% Syntax:
%   bins = binAudioAmplitudes(audio, onsets, Fs, epoch_duration, nbins, plot_amps)
%
% Description:
%   This function segments an audio signal into epochs based on provided onset 
%   times, calculates the maximum absolute amplitude of each epoch, and 
%   categorizes the epochs into a specified number of bins according to their 
%   amplitudes. Optionally, it can visualize the audio signal with marked 
%   epochs and their amplitudes.
%
% Inputs:
%   audio          - Vector of audio samples.
%   onsets         - Vector of onset times (in seconds) where epochs start.
%   Fs             - Sampling frequency of the audio signal (Hz).
%   epoch_duration - Duration of each epoch (in seconds).
%   nbins          - Number of bins to divide epochs based on amplitude.
%   plot_amps      - Boolean flag (true/false) to plot audio with epoch 
%                    amplitudes overlaid.
%
% Outputs:
%   bins - Cell array of structures, each corresponding to a bin:
%          bins{b}.epochidx   - Indices of epochs in this bin (relative to original onsets)
%          bins{b}.amplitudes - Maximum amplitudes of epochs in this bin
%
% Example:
%   % Bin audio epochs into 5 bins and plot amplitudes
%   bins = binAudioAmplitudes(audio, onsets, Fs, 0.5, 5, true);

if nargin < 6
    error('binAudioAmplitudes Usage: bins = binAudioAmplitudes(audio, onsets, Fs, epoch_duration, nbins))');
end

% convert to samples
onsets_samples = round(onsets * Fs);
epochduration_samples = round(epoch_duration * Fs);

% epoching audio
nevents = length(onsets_samples);
epochs = cell(nevents,1);
for i = 1:nevents
    st = onsets_samples(i);
    ed  = st + epochduration_samples - 1;
    % check bounds
    if ed <= length(audio)
        epochs{i} = audio(st:ed);
    else
        epochs{i} = [];  
    end
end

% compute maximum absolute amplitude for each epoch
epoch_amplitudes = zeros(nevents,1);
for i = 1:nevents
    if ~isempty(epochs{i})
        epoch_amplitudes(i) = max(abs(epochs{i}));  
    end
end

% sort the epochs in descending amplitudes values 
[sortedAmps, sortIdx] = sort(epoch_amplitudes, 'descend');

% create bins
nbins = 5;
binSize = ceil(length(sortedAmps) / nbins);
bins = cell(nbins,1);
for b = 1:nbins
    startIdx = (b-1)*binSize + 1;
    endIdx   = min(b*binSize, length(sortedAmps));
    
    % Get indices in this bin
    binIndices = sortIdx(startIdx:endIdx);   % original epoch indices
    binAmps    = sortedAmps(startIdx:endIdx);
    
    % Store as a struct
    bins{b}.epochidx = binIndices;
    bins{b}.amplitudes = binAmps;
end

% plot amplitudes on audio
if plot_amps
    t = (0:length(audio)-1)/Fs;   % time vector for audio
    figure;
    plot(t, audio, 'k'); hold on;
    xlabel('Time (s)'); ylabel('Amplitude');  
    % overlay epoch amplitudes at onset positions
    for i = 1:nevents
        if ~isempty(epochs{i})
            onset_time = onsets_samples(i)/Fs;
            amp = epoch_amplitudes(i);
    
            % mark the onset with a circle sized to amplitude
            xline(onset_time, 'r--', 'LineWidth', 1.2);
    
            % optional: line showing epoch window
            line([onset_time onset_time+epoch_duration], [amp amp], 'Color','b','LineWidth',1.5);
        end
    end
end 