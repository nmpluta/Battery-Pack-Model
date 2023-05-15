# Ideas for final project for DA

## 1 Estimation of lion cell time to discharge based on discharge current and operating temperature.

### Setup
 - one lion cell with initial voltage 4.2V and end voltage 2.8V - measurement stops after that and end time is noted
 - cells temperature is measured
 - constant load is applied (e.g. 4A of discharge current)

### Measurements
i_discharge - discharge current
v_cell - voltage on cell
t_cell - lion cell temperature

### Prediction
t_operation - time to save discharge (minimum safe voltage stored on cell)


## 2 Estimation of lion cell battery pack time to discharge with PV panel charge based on charge/discharge paramters (optionally) and operating temperature.

### Setup
 - x s, y p lion battery pack with custom BMS
 - specific lion cell (don't remember which at this time)
 - maximum voltage on cell will be 4.2V and minimum voltage (after measurements, discharge) will be 2.8V
 - the battery pack is [12s, 9p] built from these cells - this means:
    - 50.4V battery pack initial voltage
    - ~1500Wh ~30Ah
 - it will be charged with a single PV panel composed of 4 PV cells (can't remember parameters, but we can easily check them)
 - when first cell series hits 2.8V, the discharge stops and time is measured -> this is the value we want to predict

### Measurements
v_initial - initial battery pack voltage
v_cell_max - maximum cell voltage
v_cell_min - minimum cell voltage
i_charge_battery - charge current (PV panel -> battery pack)
i_discharge_battery - discharge current (battery pack -> load)
v_pv - voltage on PV panel
[optional] t_battery - battery pack temperature

### Prediction
t_operation - time to save discharge (minimum safe voltage for entire battery pack)

