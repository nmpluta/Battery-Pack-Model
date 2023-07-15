#!/usr/bin/python3

import numpy as np
import pandas as pd

"""Start voltage feature"""
def get_start_voltage(voltage_timeseries: pd.Index):
    return voltage_timeseries.max()

"""Stop voltage feature"""
def get_stop_voltage(voltage_timeseries: pd.Index):
    return voltage_timeseries.min()

"""Current peak to peak time is counter from the first time
   the load is applied to the time it's disconnected"""
def get_current_ptp(current_timeseries: pd.Index, time_timeseries: pd.Index):
    
    load_applied_idxs = [None, None]

    for i in range(current_timeseries.size):
        if load_applied_idxs[0] is None:
            if current_timeseries[i] < -0.5:
                load_applied_idxs[0] = i
        elif load_applied_idxs[1] is None:
            if current_timeseries[i] > -0.5:
                load_applied_idxs[1] = i


    # the first index in the list will give us the start time and the last one will give us the disconnection time
    start_timestamp = time_timeseries.to_numpy()[load_applied_idxs[0]]
    stop_timestamp = time_timeseries.to_numpy()[load_applied_idxs[-1]]
    # this means peak to peak value will be the difference in time between those
    # since we know that time can only go up, we can assume stop time is greater than start time
    return stop_timestamp - start_timestamp