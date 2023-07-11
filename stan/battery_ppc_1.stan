data {
    int<lower=0> N;                          // number of data points
    vector[N] time_measured;                 // time in seconds
    int<lower=1> discharge_mode_start_index; // index of the start of the discharge mode
    int<lower=1> discharge_mode_stop_index;  // index of the stop of the discharge mode
}

generated quantities {
    array[N] real<lower=0> time;
    array[N] real<lower=0> time_step;
    array[N] real current;
    array[N] real estimated_soc;       // estimated state of charge in %
    array[N] real estimated_discharge; // estimated discharge in Ah
    real final_soc;
    real final_discharge_capacity;

    // randomly distributed beetwen values 2Ahr (rated capacity) to 1.4Ahr (30% fade in rated capacity)
    real<lower=1.4, upper=2.0> prior_discharge_capacity = uniform_rng(1.4, 2);
    real prior_initial_soc = 1 - uniform_rng(0, 0.01);       // initial state of charge in %

    // current inaccuracy is 1% of the current value
    for (i in 1:N)
    {
        if (i < discharge_mode_start_index)
        {
            current[i] = normal_rng(0, 0.01);
        }
        else if (i > discharge_mode_stop_index)
        {
            current[i] = normal_rng(0, 0.01);
        }
        else
        {
            current[i] = normal_rng(-2, 0.01);
        }
    }

    // incorporate the time measurement error - assume 0.5 seconds inaccuracy
    for (i in 1:N)
    {
        if (i == 1)
        {
            time[i] = time_measured[i];
        } 
        else
        {
            time[i] = normal_rng(time_measured[i], 0.5);
        }
    }

    // time steps are calculated using the time vector
    for (i in 1:N) 
    {
        if (i == 1)
        {
            time_step[i] = time[i];
        } 
        else
        {
            time_step[i] = time[i] - time[i-1];
        }
    }

    // calculate state of charge using coulomb counting method
    for (i in 1:N)
    {
        if (i == 1)
        {
            estimated_discharge[1] = 0;
            // set initial state of charge
            estimated_soc[1] = prior_initial_soc;
        }
        else
        {
            estimated_discharge[i] = estimated_discharge[i-1] + (fabs(current[i]) * time_step[i]) / 3600;
            estimated_soc[i] = estimated_soc[i-1] + (current[i] * time_step[i]) / (prior_discharge_capacity*3600);
        }
    }

    final_discharge_capacity = estimated_discharge[discharge_mode_stop_index];
    final_soc = estimated_soc[discharge_mode_stop_index];
}