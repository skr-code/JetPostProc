function data_output = MonoData(data, n_pts)

dt_base = data{1}(2,1)-data{1}(1,1);
assert(abs(dt_base - (data{1}(3,1)-data{1}(2,1)))<1.e-11);
row_list = zeros(1,n_pts);

for pt_id = 1:n_pts
    row_list(pt_id) = size(data{pt_id},1);
end
for pt_id = 1:n_pts
    i = 1;
    while i<=row_list(pt_id)-1
        curr = data{pt_id}(i,1);
        next = data{pt_id}(i+1,1);
        if abs(next-curr-dt_base) > 1.e-10
            % find the correct next row
            cprintf('red',['find duplicated row or not-mono row at ',num2str(pt_id),...
                ', row=',num2str(i),' ...']);
            if (i+2)>=row_list(pt_id)
                data{pt_id} = data{pt_id}(1:end-1,:);
            else
                for j = i+2:1:row_list(pt_id)
                    corr_next = data{pt_id}(j,1);
                    if abs(corr_next-curr-dt_base) < 1.e-10
                        data{pt_id} = data{pt_id}([1:i,j:end],:);
                        % update row_list
                        row_list(pt_id) = size(data{pt_id},1);
                        cprintf('blue','cleared.\n');
                        break;
                    end
                end
            end
        end
        i = i+1;
    end
end

data_output = data;
