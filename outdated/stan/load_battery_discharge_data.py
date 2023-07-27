#!/usr/bin/python3

import pandas as pd

import os

""" Loads the data necessary for SoC modelling on a discharge profile
    Outputs a dictionary in such format:
    {
        "battery1": {
            "test_set_id_1": {
                "previous_capacity": "capacity value",
                "data": "data as pandas DataFrame"
            },
            "test_set_id_2": {
                "previous_capacity": "capacity value",
                "data": "data as pandas DataFrame"
            },
            ...
            "test_set_id_N": {
                "previous_capacity": "capacity value",
                "data": "data as pandas DataFrame"
            }
        },
        ...
    }
"""
def make_battery_discharge_dir(battery_test_data_root, battery_name):
    return battery_test_data_root + "/" + battery_name + "/discharge/"

def get_battery_test_metadata(test_id, metadata_path):
    metadata = pd.read_csv(metadata_path)
    discharge_rows = metadata.query("type == 'discharge'")
    test_id_row = discharge_rows.query(f"filename == '{test_id}.csv'")
    return float(test_id_row["Capacity"].to_numpy()[0])

def load_battery_test_data(battery_test_data_dir, battery_name, metadata_path):
    battery_discharge_data_dir = make_battery_discharge_dir(battery_test_data_dir, battery_name)
    test_datasets = {}
    for filename in os.listdir(battery_discharge_data_dir):
        test_id = os.path.splitext(filename)[0] # filepath without extension
        filepath = battery_discharge_data_dir + filename
        test_datasets[test_id] = {
            "discharge_capacity": get_battery_test_metadata(test_id, metadata_path),
            "data": pd.read_csv(filepath)
        }
    test_data = {f"{battery_name}": test_datasets}
    return test_data

if __name__ == "__main__":
    battery_test_data = load_battery_test_data("./analyzed_dataset", "B0005", "./cleaned_dataset/metadata.csv")
    datasets_for_b0005 = ["05122", "05322", "05535", "05645", "05734"]
    for dataset in datasets_for_b0005:
        print(battery_test_data["B0005"][dataset]['data'].head(2))
        print(battery_test_data["B0005"][dataset]['discharge_capacity'])
        print(type(battery_test_data["B0005"][dataset]['discharge_capacity']))
        
