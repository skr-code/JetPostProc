function Write_data_pressure(output_name, index, data)

p_col=6;

dlmwrite(output_name, [data(:,1), data(:,p_col)], 'delimiter',' ','precision',16);


cprintf('*blue',['The pressure data files on Point has been written.\n']);

