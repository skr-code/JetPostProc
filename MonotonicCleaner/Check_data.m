function Check_data(data, n_pts, modify)


%% check number of row
row_list = zeros(1,n_pts);
for pt_id = 1:n_pts
    row_list(pt_id) = size(data{pt_id},1);
end
if mean(row_list) == size(data{1},1)
    cprintf('green','All data have the same number of row.\n');
else
    cprintf('red','Some data has different number of row.\n');
end

%% check the time seq.
correct = true;
for i = 1:mean(row_list)
    phytime_list = zeros(1,n_pts);
    for pt_id = 1:n_pts
        phytime_list(pt_id) = data{pt_id}(i,1);
    end
    if abs(mean(phytime_list)-data{1}(i,1))>1.e-10
        cprintf('red',['The phy_time is not correct. The row is ', num2str(i),'\n']);
        correct = false;
        break;
    end
end
if correct
    cprintf('green','All data has the same seq. of phy_time.\n');
end

%% check the mono of time seq. as well as the uniform dt
correct = true;
dt_base = data{1}(2,1)-data{1}(1,1);
for j = 1:n_pts
    for i = 1:row_list(j)-1
        current = data{j}(i,1);
        next    = data{j}(i+1,1);
        dt_current = next - current;
        if abs(dt_current-dt_base) > 1.e-10
            cprintf('red',['time step is wrong! The row = ', num2str(i),'.\n']);
            correct = false;
            break;
        end
        if dt_current < 0
            cprintf('red',['time step is negative! The row = ', num2str(i),'.\n']);
            correct = false;
            break;
        end
    end
end
if correct
    cprintf('green','Pass the time seq. and time step check!\n');
else
    cprintf('red','time seq. is wrong!\n');
end

%% modify the phy time more accurate

if nargin == 3 && modify == true
    
    dt_round = round(dt_base*10^14)/(10^14);
    for pt_id = 1:n_pts
        data{pt_id}(1,1) = round(data{pt_id}(1,1)*10^14)/(10^14);
    end

    cprintf('*blue','Modify the phy time more accurate\n');
    
    for i = 1:mean(row_list)-1
        for pt_id = 1:n_pts
            data{pt_id}(i+1,1) = data{pt_id}(i,1)+dt_round;
        end
    end
end

