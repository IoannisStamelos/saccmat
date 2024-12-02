function [left,right,samplerate] = preprocess(path)

   left = readtable(strcat(path,"\EyePositionData Left.csv"));
   right = readtable(strcat(path,"\EyePositionData Right.csv"));

   left = table2array(left(:,[1 3 6]));
   right = table2array(right(:,[1 3 6]));
   left(:,1) = left(:,1) - left(1,1);
   right(:,1) = right(:,1) - right(1,1);
   % Define overlapping time range
   t1 = left(:,1)/1000;
   t2 = right(:,1)/1000;
   x1 = left(:,2);
   x2 = right(:,2);
   y1 = left(:,3);
   y2 = right(:,3);
   % Check for duplicates in t1
 

   % Remove duplicates by keeping the first occurrence
   [t1, ia1] = unique(t1, 'stable');  % 'stable' ensures order is preserved
   x1 = x1(ia1);  % Update x1 to match the unique t1 values
   y1 = y1(ia1);  % Update y1 to match the unique t1 values
   
   [t2, ia2] = unique(t2, 'stable');  % Same for t2
   x2 = x2(ia2);  % Update x2 to match the unique t2 values
   y2 = y2(ia2);  % Update y2 to match the unique t2 values


   % Calculate mean sampling intervals
   dt1 = diff(t1);
   dt2 = diff(t2);
  
    
   mean_dt1 = mean(dt1);
   mean_dt2 = mean(dt2);
   
   % Calculate sampling rates
   fs1 = 1 / mean_dt1;
   fs2 = 1 / mean_dt2;
    
   % Define common sampling rate
   fs_common = min(fs1, fs2); % Use the lower sampling rate
   dt_common = 1 / fs_common;
    
   % Define the common time vector
   t_start = max(min(t1), min(t2));
   t_end = min(max(t1), max(t2));
   t_common = t_start:dt_common:t_end;

   % Interpolate positions for the first eye
   x1_common = pchip(t1, x1, t_common);
   y1_common = pchip(t1, y1, t_common);

   % Interpolate positions for the second eye
   x2_common = pchip(t2, x2, t_common);
   y2_common = pchip(t2, y2, t_common);
   % %%
   % figure;
   % subplot(2, 1, 1);
   % hold on;
   % plot(t1, x1, '.', 'DisplayName', 'Original x1');
   % plot(t2, x2, '.', 'DisplayName', 'Original x2');
   % plot(t_common, x1_common, '-', 'DisplayName', 'Interpolated x1');
   % plot(t_common, x2_common, '-', 'DisplayName', 'Interpolated x2');
   % title('Horizontal Position (x)');
   % xlabel('Time (s)');
   % ylabel('Position');
   % legend;
   % grid on;
   % 
   % subplot(2, 1, 2);
   % hold on;
   % plot(t1, y1, '.', 'DisplayName', 'Original y1');
   % plot(t2, y2, '.', 'DisplayName', 'Original y2');
   % plot(t_common, y1_common, '-', 'DisplayName', 'Interpolated y1');
   % plot(t_common, y2_common, '-', 'DisplayName', 'Interpolated y2');
   % title('Vertical Position (y)');
   % xlabel('Time (s)');
   % ylabel('Position');
   % legend;
   % grid on;
   %%
   left = vertcat(t_common,x1_common,y1_common)';
   right = vertcat(t_common,x2_common,y1_common)';
   samplerate = fs_common;


end 