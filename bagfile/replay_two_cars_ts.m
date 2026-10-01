function replay_cars_ts(cars, varargin)
% replay_cars_ts  Animate multiple cars from their odometry time series.
%   cars : cell array of car data (each one may be timeseries, timetable, Nx2, or struct with .t and .x)
%
% Name-Value options:
%   'L'           : car length [m], default 4.0
%   'W'           : car width  [m], default 1.8
%   'Speed'       : playback speed multiplier, default 1
%   'Trail'       : true/false, draw trails, default true
%   'Labels'      : cellstr of car labels, default {'Car 1','Car 2',...}
%   'Ego'         : index of ego car (for centering), default 1
%   'Window'      : MIN x-span [m], default 80
%   'WindowMax'   : MAX x-span [m]; [] = no hard max
%   'Signals'     : cell array of extra time series to plot below
%   'SignalNames' : cellstr of labels for Signals (optional)
%   'SignalHeight': height fraction for signal axes (0.15–0.45), default 0.25
%
% Example:
%   replay_cars_ts({car1,car2,car3}, 'Ego', 2, 'Labels', {'Lead','Ego','Follower'});

% ---------- Parse inputs ----------
p = inputParser;
p.addParameter('L', 4.0, @(v)isnumeric(v)&&isscalar(v)&&v>0);
p.addParameter('W', 1.8, @(v)isnumeric(v)&&isscalar(v)&&v>0);
p.addParameter('Speed', 1, @(v)isnumeric(v)&&isscalar(v)&&v>0);
p.addParameter('Trail', true, @(v)islogical(v)&&isscalar(v));
p.addParameter('Labels', {}, @(v)iscellstr(v)||isstring(v));
p.addParameter('Ego', 1, @(v)isnumeric(v)&&isscalar(v)&&v>=1);
p.addParameter('Window', 80, @(v)isnumeric(v)&&isscalar(v)&&v>0);
p.addParameter('WindowMax', [], @(v)isempty(v)||(isnumeric(v)&&isscalar(v)&&v>0));
p.addParameter('Signals', {}, @(v)iscell(v));
p.addParameter('SignalNames', {}, @(v)iscellstr(v)||isstring(v));
p.addParameter('SignalHeight', 0.25, @(v)isnumeric(v)&&isscalar(v)&&v>=0.15&&v<=0.45);
p.parse(varargin{:});
L = p.Results.L; W = p.Results.W;
spd = p.Results.Speed;
drawTrail = p.Results.Trail;
labels = cellstr(string(p.Results.Labels));
ego  = p.Results.Ego;
winMin  = p.Results.Window;
winMax  = p.Results.WindowMax;
signals = p.Results.Signals;
sigNames = cellstr(string(p.Results.SignalNames));
sigH    = p.Results.SignalHeight;

nCars = numel(cars);
if isempty(labels)
    labels = arrayfun(@(k)sprintf('Car %d',k),1:nCars,'uni',0);
end

% ---------- Extract all car trajectories ----------
tAll = cell(1,nCars); xAll = cell(1,nCars);
for i = 1:nCars
    [tAll{i}, xAll{i}] = get_tx(cars{i});
    [tAll{i}, xAll{i}] = sort_tx(tAll{i}, xAll{i});
end
t0 = min(cellfun(@(t)t(1), tAll));

% Robust concatenation of all time vectors
tSecsAll = cellfun(@(t)to_seconds(t,t0), tAll, 'UniformOutput', false);
tu = unique(sort(vertcat(tSecsAll{:})));

% ---------- Interpolate and clamp ----------
xU = zeros(nCars, numel(tu));
for i = 1:nCars
    ti = to_seconds(tAll{i}, t0);
    xi = xAll{i};
    xiU = interp1(ti, xi, tu, 'linear', 'extrap');
    xiU(tu<ti(1)) = xi(1);
    xiU(tu>ti(end)) = xi(end);
    xU(i,:) = xiU;
end

% ---------- Extra signals ----------
numSig = numel(signals);
sigY = [];
if numSig > 0
    sigY = zeros(numSig, numel(tu));
    for i = 1:numSig
        [ts_i, ys_i] = get_tx(signals{i});
        [ts_i, ys_i] = sort_tx(ts_i, ys_i);
        tsi = to_seconds(ts_i, t0);
        yi  = interp1(tsi, ys_i, tu, 'linear', 'extrap');
        yi(tu < tsi(1)) = ys_i(1);
        yi(tu > tsi(end)) = ys_i(end);
        sigY(i,:) = yi(:).';
    end
    if isempty(sigNames) || numel(sigNames) ~= numSig
        sigNames = arrayfun(@(k)sprintf('Signal %d',k), 1:numSig, 'uni', 0);
    end
end

% ---------- Figure setup ----------
clf; figure(gcf); set(gcf,'Color','w','Name','Multi-Car Replay');

left = 0.08; right = 0.06; top = 0.06; bottom = 0.10; midGap = 0.06;
playH = 1 - top - bottom - (numSig>0)*(sigH+midGap);
if playH <= 0.2, playH = 0.2; end

axPlay = axes('Position',[left, bottom+(numSig>0)*(sigH+midGap), 1-left-right, playH]);
hold(axPlay,'on'); axis(axPlay,'equal'); grid(axPlay,'on');
xlabel(axPlay,'Longitudinal position x [m]');
ylabel(axPlay,'Lateral position y [m]');
title(axPlay,sprintf('Replay of %d Cars (Top-Down)', nCars));

% Assign lateral offsets evenly spaced
yOffsets = linspace((nCars-1)*W, -(nCars-1)*W, nCars);

% Create graphics handles for each car
colors = lines(nCars);
carXY = [ -L/2  -W/2;  L/2  -W/2;  L/2   W/2; -L/2   W/2 ];
T = gobjects(1,nCars);
labelsH = gobjects(1,nCars);
trails = gobjects(1,nCars);

for i = 1:nCars
    T(i) = hgtransform('Parent', axPlay);
    patch('XData',carXY(:,1),'YData',carXY(:,2),'Parent',T(i), ...
          'FaceColor',colors(i,:),'EdgeColor','k','LineWidth',1.0);
    plot(T(i), [L/2 L/2], [-W/4 W/4], 'k-', 'LineWidth',2);
    labelOffset = W*0.8;
    labelsH(i) = text(axPlay, xU(i,1), yOffsets(i)+labelOffset, labels{i}, ...
        'HorizontalAlignment','center','VerticalAlignment','bottom', ...
        'FontWeight','bold','Color',colors(i,:),'FontSize',10);
    if drawTrail
        trails(i) = plot(axPlay, xU(i,1), yOffsets(i), '-', 'LineWidth', 1.0, 'Color', colors(i,:));
    end
end
ylim(axPlay, [min(yOffsets)-3*W, max(yOffsets)+3*W]);

% Bottom signals
if numSig > 0
    axSig = axes('Position',[left,bottom,1-left-right,sigH]);
    hold(axSig,'on'); grid(axSig,'on');
    tt = tu;
    for i = 1:numSig
        plot(axSig, tt, sigY(i,:), 'LineWidth',1.0);
    end
    legend(axSig,sigNames,'Location','eastoutside');
    xlabel(axSig,'Time [s]'); ylabel(axSig,'Value');
    try
        tc = xline(axSig, tt(1), '--', 'Cursor', 'LabelOrientation','horizontal');
    catch
        tc = line(axSig,[tt(1) tt(1)], ylim(axSig), 'LineStyle','--','Color',[0 0 0]);
    end
else
    axSig=[]; tc=[];
end

% Initial placement
for i = 1:nCars
    set(T(i), 'Matrix', makehgtform('translate',[xU(i,1), yOffsets(i), 0]));
end

% ---- Axis padding & centering ----
xMargin  = 1.5*L;
baseMin  = max(winMin, 4*L);
xEgo0 = xU(ego,1);
span0 = baseMin;
if ~isempty(winMax), span0 = min(span0, winMax); end
xlim(axPlay, [xEgo0 - span0/2, xEgo0 + span0/2]);

% ---------- Animation ----------
N = numel(tu);
for k = 1:N
    % update transforms & labels
    for i = 1:nCars
        set(T(i),'Matrix',makehgtform('translate',[xU(i,k), yOffsets(i), 0]));
        set(labelsH(i),'Position',[xU(i,k), yOffsets(i)+labelOffset, 0]);
        if drawTrail
            set(trails(i),'XData',xU(i,1:k),'YData',yOffsets(i)*ones(1,k));
        end
    end

    % ego-centered view
    xEgo = xU(ego,k);
    minx = min(xU(:,k)); maxx = max(xU(:,k));
    need = (maxx - minx) + 2*xMargin;
    span = max(baseMin, need);
    if ~isempty(winMax), span = min(span, winMax); end
    xlim(axPlay, [xEgo - span/2, xEgo + span/2]);

    if ~isempty(axSig)
        try
            tc.Value = tu(k);
        catch
            set(tc,'XData',[tu(k) tu(k)],'YData',ylim(axSig));
        end
    end

    drawnow limitrate nocallbacks;
    if k<N
        dt=(tu(k+1)-tu(k))/spd;
        if dt>0, pause(min(dt,0.05)); end
    end
end
end

% ===== Helpers =====
function [t, x] = get_tx(s)
    if isa(s, 'timeseries')
        t = s.Time;  x = s.Data;
    elseif istimetable(s)
        if width(s) ~= 1, error('Timetable must have exactly one variable (position x).'); end
        t = s.Properties.RowTimes; x = s{:,1};
    elseif isnumeric(s)
        if size(s,2) < 2, error('Numeric input must be Nx2 [t, x].'); end
        t = s(:,1); x = s(:,2);
    elseif isstruct(s) && isfield(s,'t') && isfield(s,'x')
        t = s.t; x = s.x;
    else
        error('Unsupported input type.');
    end
    t = t(:); x = x(:);
end

function [t, x] = sort_tx(t, x)
    if isnumeric(t) && any(t > 7e5) && any(t < 1e6)
        try t = datetime(t, 'ConvertFrom','datenum'); end %#ok<TRYNC>
    end
    if isdatetime(t) || isduration(t)
        [t, idx] = sort(t);
    else
        [t, idx] = sort(t(:));
    end
    x = x(idx);
end

function ts = to_seconds(t, t0)
    if isdatetime(t) || isduration(t)
        ts = seconds(t - t0);
    else
        ts = t - t0;
    end
    ts = ts(:);
end