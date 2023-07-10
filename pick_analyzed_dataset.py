import pandas as pd
import os
import shutil
import copy
from tqdm import tqdm

# Load all data files from cleaned_dataset/data directory
file_dir = 'cleaned_dataset/data/'

# Create a new directory for the analyzed dataset
new_dir = 'analyzed_dataset/'
if not os.path.exists(new_dir):
    os.makedirs(new_dir)

# Create a dictionary for the types of data containing charge, discharge, and impedance data and count for each
types = {
    'charge': {'subdir': 'charge/', 'count': 0},
    'discharge': {'subdir': 'discharge/', 'count': 0},
    'impedance': {'subdir': 'impedance/', 'count': 0},
}

# Create a dictionary containing directory name and types for each battery
batteries = {
    'B0005': {'dir': new_dir + 'B0005/', 'count': 0, 'types': copy.deepcopy(types)},
    'B0006': {'dir': new_dir + 'B0006/', 'count': 0, 'types': copy.deepcopy(types)},
    'B0007': {'dir': new_dir + 'B0007/', 'count': 0, 'types': copy.deepcopy(types)},
    'B0018': {'dir': new_dir + 'B0018/', 'count': 0, 'types': copy.deepcopy(types)},
}

# Create a directory for each battery
for key, value in batteries.items():
    if not os.path.exists(value['dir']):
        os.makedirs(value['dir'])

# Create a directory for each subdirectory
for key, value in batteries.items():
    for key2, value2 in value['types'].items():
        subdir_path = value['dir'] + value2['subdir']
        if not os.path.exists(subdir_path):
            os.makedirs(subdir_path)

# Read and store metadata information for analyzed batteries
metadata = pd.read_csv('cleaned_dataset/metadata.csv')

# Create a progress bar
pbar = tqdm(total=len(metadata))

# Iterate over each row in the metadata dataframe
for index, row in metadata.iterrows():
    battery_id = row['battery_id']
    data_type = row['type']
    filename = row['filename']

    # Check if the battery ID exists in the batteries dictionary
    if battery_id in batteries:
        # Check the data type and save the file to the appropriate subdirectory
        if data_type == 'charge':
            subdir = batteries[battery_id]['types']['charge']['subdir']
        elif data_type == 'discharge':
            subdir = batteries[battery_id]['types']['discharge']['subdir']
        elif data_type == 'impedance':
            subdir = batteries[battery_id]['types']['impedance']['subdir']
        else:
            # Skip unrecognized data types
            print('Unrecognized data type: ' + data_type)
            continue

        # Copy the file to the appropriate subdirectory
        src = file_dir + filename
        dst = batteries[battery_id]['dir'] + subdir + filename
        shutil.copyfile(src, dst)

        # Increment the count for the battery and data type
        batteries[battery_id]['count'] += 1
        batteries[battery_id]['types'][data_type]['count'] += 1

    # Update the progress bar
    pbar.update(1)

# Close the progress bar
pbar.close()

# Create a new statistics.txt file
statistics = open(new_dir + 'statistics.txt', 'w+')

# Summarize the number of files copied for each battery
sum_files = 0
for key, value in batteries.items():
    sum_files += value['count']
text = 'Total number of files copied: ' + str(sum_files) + '\n'
print('\n' + text)
statistics.write(text + '\n')

# Print the number of files copied for each battery
for key, value in batteries.items():
    text = 'Battery ID: ' + key
    print(text)
    statistics.write(text + '\n')

    text = 'Number of files: ' + str(value['count'])
    print(text)
    statistics.write(text + '\n')

    for key2, value2 in value['types'].items():
        text = 'Number of ' + key2 + ' files: ' + str(value2['count'])
        print(text)
        statistics.write(text + '\n')
    statistics.write('\n')
    print('')

# Close the statistics.txt file
statistics.close()
