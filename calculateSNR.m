function SNR = calculateSNR(pxx, f)
% function SNR = calculateSNR(pxx, f)
%
% The function computes the SNR for each channel from a power spectrum (pxx) 
% and frequency vector (f). It identifies the alpha band (8–12 Hz) as the signal, 
% calculates the Individual Alpha Frequency (IAF), fits a 1/f noise model excluding 
% the alpha band, and computes the SNR by comparing the power at IAF with the fitted 
% noise. The output is the SNR in decibels for each channel.
%
% Inputs:
%   pxx        - power spectrum (values x channels)
%   f          - frequency vector 

    % loop over channels 
    for ch = 1:size(pxx,2)

        % defining alpha band in f
        alphaBand = (f >= 8 & f <= 12);
        % maximum power within alpha band
        [signalpow, signalidx] = max(pxx(alphaBand, ch));
        iafFreq = f(alphaBand);
        iaf = iafFreq(signalidx);
        
        % find alpha peak
        [peaks, locs] = findpeaks(pxx(alphaBand, ch), iafFreq); 
        % checking if there are multiple peaks
        if numel(peaks) > 1
            % IAF determined using weighted average of multiple peaks
            iaf = sum(peaks .* locs) / sum(peaks); 
        end

        % log of power spectrum
        log_pxx = log10(pxx);
        % log of freq vector 
        log_f = log10(f);
        % define signal band to be excluded from fitting
        exclude_signal = (f < 8 | f > 12);
        % define noise band to be excluded from fitting
        exclude_noise = (f >= 1 & f <= 7) | (f >= 35 & f <= 65);
        exclude_fit = exclude_signal & exclude_noise;

        % performs a linear regression to model the 1/f noise
        p = polyfit(log_f(exclude_fit), log_pxx(exclude_fit), 1); 
        fitted_line = polyval(p, log_f); 

        % compute SNR at IAF
        iaf_idx = find(abs(f - iaf) == min(abs(f - iaf)), 1);
        SNR(ch) = 10 * (log_pxx(iaf_idx) - fitted_line(iaf_idx));
    end 
end


