function index = findIDx(time2find, timepts)
% function to find the time index 
    [~, index] = min(abs(timepts - time2find));
end 