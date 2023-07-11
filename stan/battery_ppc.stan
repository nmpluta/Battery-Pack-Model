data { 
    int<lower=0> N;                     // number of data points
    vector[N] current_measured;         // current measurement in A
    vector[N] time_measured;            // time in seconds
    real<lower=0> rated_capacity;       // rated capacity in Ah
    real<lower=0, upper=1> initial_soc; // initial state of charge in %
    real<lower=0, upper=1> initial_soh; // initial state of health in %
}

generated quantities {
    real<lower=0> prior_capacity;       // prior capacity in Ah
    array[N] real<lower=0> time_step;
    array[N] real<lower=0> time;
    array[N] real current;
    array[N] real estimated_soc;       // estimated state of charge in %
    array[N] real estimated_discharge; // estimated discharge capacity in Ah

    // use rated capacity in defining prior capacity
    // assume that the prior capacity sigma is 10% of the rated capacity
    prior_capacity = normal_rng(rated_capacity, 0.1*rated_capacity);

    // incorporate the current measurement error - assume 1% inaccuracy
    current = normal_rng(current_measured, fabs(0.01*current_measured));

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
            estimated_soc[1] = initial_soc;
        }
        else
        {
            estimated_discharge[i] = estimated_discharge[i-1] + (fabs(current[i]) * time_step[i]) / 3600;
            estimated_soc[i] = estimated_soc[i-1] + (current[i] * time_step[i]) / (prior_capacity*3600 * initial_soh);
        }
    }
}