import pandas as pd
import matplotlib.pyplot as plt
import os
from tqdm import tqdm

# Load all data files from cleaned_dataset/data directory
file_dir = 'cleaned_dataset/data/'

# Create a new directory for the sorted dataset
new_dir = 'sorted_dataset/'
if not os.path.exists(new_dir):
    os.makedirs(new_dir)

# create a dictionary containg directory name for all, charge, discharge, impedance, error and count for each
files = {
    'all': { 'dir': 'cleaned_dataset/data/', 'count': 0 },
    'charge': { 'dir': new_dir + 'charge/', 'count': 0 },
    'discharge': { 'dir': new_dir + 'discharge/', 'count': 0 },
    'impedance': { 'dir': new_dir + 'impedance/', 'count': 0 },
    'error': { 'dir': new_dir + 'error/', 'count': 0 },
}

# create a directory for each file type, omit all
for key, value in files.items():
    if key != 'all':
        if not os.path.exists(value['dir']):
            os.makedirs(value['dir'])

headers = {
    'charge': ['Voltage_measured', 'Current_measured', 'Temperature_measured', 'Current_load', 'Voltage_load', 'Time'],
    'discharge': ['Voltage_measured', 'Current_measured', 'Temperature_measured', 'Current_charge', 'Voltage_charge', 'Time'],
    'impedance': ['Sense_current', 'Battery_current', 'Current_ratio', 'Battery_impedance', 'Rectified_impedance'],
}

# Read and store data for each file in file_dir
# Sort data into charge, discharge, and impedence data based on the csv headers
for file in tqdm(os.listdir(files['all']['dir'])):
    if file.endswith('.csv'):
        data = pd.read_csv(file_dir + file)
        files['all']['count'] += 1

    # Check if the file is charge, discharge, or impedance data
    # Increment the count for the file type
    file_type = None
    processed_headers = False
    for key, value in headers.items():
        if data.columns.tolist() == value:
            file_type = key
            files[file_type]['count'] += 1
            break

    # If the file is not charge, discharge, or impedance data, it is error data
    if file_type is None:
        file_type = 'error'
        print('Error: ' + file + ' is not charge, discharge, or impedance data')
        files[file_type]['count'] += 1
    else:
        # Save the file to the appropriate directory
        data.to_csv(files[file_type]['dir'] + file, index=False)

# Check if new_dir + statistics.txt exists if yes delete it and create a new one
if os.path.exists(new_dir + 'statistics.txt'):
    os.remove(new_dir + 'statistics.txt')

# Create a new statistics.txt file
statistics = open(new_dir + 'statistics.txt', 'w+')
# Show statistics for the sorted dataset and write them to the statistics.txt file
for key, value in files.items():
    text = 'Number of ' + key + ' files: ' + str(value['count'])
    statistics.write(text + '\n')
    print(text)
    if key != 'all':
        text = 'Percentage of ' + key + ' files: ' + str(round(value['count'] / files['all']['count'] * 100, 2)) + '%'
        statistics.write(text + '\n')
        print(text)
statistics.close()
