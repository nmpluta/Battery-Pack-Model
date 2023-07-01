# NASA Battery Dataset

This directory contains the NASA Battery Dataset, which provides valuable information about battery performance, degradation, and failure. The dataset is suitable for various data analysis and modeling tasks related to batteries.

## Generic Dataset Informations

Repeated charge and discharge cycles result in accelerated aging of the batteries while impedance measurements provide insight into the internal battery parameters that change as aging progresses.

 - Charge profile:
   - The charge profile for all battery tests seems to be identifical.
   - Charging was carried out in a constant current (CC) mode at 1.5A until the battery voltage reached 4.2V and then continued in a constant voltage (CV) mode until the charge current dropped to 20mA.

 - Discharge profile:
   - Discharge profiles were different from battery to battery.
   - Discharge was carried out at a constant current (CC) level of 1-4 A until the battery voltage fell to values such 2.7V, 2.5V, 2.2V and 2.5V.

 - Impedance:
   - Impedance measurement was carried out through an electrochemical impedance spectroscopy (EIS) frequency sweep from 0.1Hz to 5kHz.

The experiments were stopped when the batteries reached a given end-of-life (EOL) criteria: for example 30% fade in rated capacity (from 2Ahr to 1.4Ahr). Other stopping criteria were used such as 20% fade in rated capacity. Note that for batteries 49,50,51,52, the experiments were not stop due to battery EOL but because the software has crashed.

## Files and Directories

- `data` directory: Contains the data files related to battery measurements and features.
- `extra_infos` directory: Contains additional information or supplementary files related to the battery dataset.
- `metadata.csv`: A CSV file providing metadata information about the dataset, such as the variables, their meanings, units, and other relevant details.

## Usage

To use this dataset, you can access the relevant CSV files within the `data` directory for loading and processing the battery measurements and features. You can use popular data manipulation libraries in Python, such as Pandas, to read and analyze the CSV files.

The `extra_infos` directory contains supplementary files or additional information that may be useful for understanding the dataset or conducting specific analyses. You can explore the files within this directory to access any relevant details.

The `metadata.csv` file provides essential metadata information about the dataset. You can refer to this file to understand the variables, their meanings, units, and other relevant details, which can guide your data analysis and modeling process.

## Structure of data files
Each file depending on measured feature contains following columns:
- for charge the fields are:
  - Voltage_measured: Battery terminal voltage (Volts)
  - Current_measured: Battery output current (Amps)
  - Temperature_measured: Battery temperature (degree C)
  - Current_charge: Current measured at charger (Amps)
  - Voltage_charge: Voltage measured at charger (Volts)
  - Time: Time vector for the cycle (secs)
- for discharge the fields are:
  - Voltage_measured: Battery terminal voltage (Volts)
  - Current_measured: Battery output current (Amps)
  - Temperature_measured: Battery temperature (degree C)
  - Current_load: Current measured at load (Amps)
  - Voltage_load: Voltage measured at load (Volts)
  - Time: Time vector for the cycle (secs)
  - Capacity: Battery capacity (Ahr) for discharge till 2.7V
- for impedance the fields are:
  - Sense_current: Current in sense branch (Amps)
  - Battery_current: Current in battery branch (Amps)
  - Current_ratio: Ratio of the above currents
  - Battery_impedance: Battery impedance (Ohms) computed from raw data
  - Rectified_impedance: Calibrated and smoothed battery impedance (Ohms)
  - Re: Estimated electrolyte resistance (Ohms)
  - Rct: Estimated charge transfer resistance (Ohms)

## Acknowledgements

This dataset is sourced from [Kaggle](https://www.kaggle.com/datasets/patrickfleith/nasa-battery-dataset), provided by [Patrick Fleith](https://www.kaggle.com/patrickfleith). We acknowledge and appreciate their efforts in collecting and sharing the data.

## License

Please refer to the original dataset source on Kaggle for licensing information and terms of use.
