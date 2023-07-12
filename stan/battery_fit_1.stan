data { 
    int<lower=0> N;                            // number of data points
    vector[N] current_measured;                // current measurement in A
    vector[N] time_measured;                   // time in seconds
    real<lower=0> discharge_capacity_measured; // measured discharge capacity in Ah
}

parameters {
    real<lower=-3, upper=-1> current_prior; // current prior in A
    real<lower=0, upper=1> current_error;    // current measurement noise in A

    real<lower=0> time_step_prior;              // time step prior in seconds
    real<lower=0, upper=1> time_error;       // time measurement noise in seconds

    real<lower=1, upper=3> discharge_capacity_prior;  // discharge capacity prior in Ah
    real<lower=0> discharge_capacity_error;             // discharge capacity measurement noise in Ah

    real<lower=0.5, upper=1.2> initial_soc_prior;   // initial state of charge prior in %

    real<lower=0> discharge_error;              // discharged charge noise in Ah
    real<lower=0> soc_error;                    // state of charge noise in %
}

transformed parameters {
    array[N] real<lower=0, upper=40> time_step;

    // time steps are calculated using the time vector
    for (i in 1:N) 
    {
        if (i == 1)
        {
            time_step[i] = time_measured[i];
        } 
        else
        {
            time_step[i] = time_measured[i] - time_measured[i-1];
        }
    }
}

model {
    // priors

    // assume that soc sigma is 0.01%
    soc_error ~ normal(0, 0.0001);

    // assume that the discharged charge sigma is 0.01 Ah
    discharge_error ~ normal(0, 0.01);

    // assume that the current prior is -2A
    current_prior ~ normal(-2, 0.1);
    // assume that the current sigma is 1% of the measured current
    current_error ~ uniform(0, 0.01);

    // assume that time step between measurements is 18 seconds
    time_step_prior ~ normal(18, 2);
    // assume that the time step sigma is 0.5 seconds
    time_error ~ normal(0, 0.5);

    // randomly distributed beetwen values 2Ahr (rated capacity) to 1.4Ahr (30% fade in rated capacity)
    discharge_capacity_prior ~ uniform(1.4, 2);
    // assume that the discharge capacity sigma is 1% of the measured discharge capacity
    discharge_capacity_error ~ uniform(0, 0.01);

    // likelihood
    for (i in 1:N)
    {
        time_step[i] ~ normal(time_step_prior, time_error);
        current_measured[i] ~ normal(current_prior, current_error);
    }
    discharge_capacity_measured ~ normal(discharge_capacity_prior, discharge_capacity_error);

    // initial state of charge prior is around 100%
    initial_soc_prior ~ uniform(0.99, 1);
}

generated quantities {
    array[N] real estimated_soc;       // estimated state of charge in %
    array[N] real estimated_discharge; // estimated discharge capacity in Ah

    // calculate state of charge using coulomb counting method
    for (i in 1:N)
    {
        if (i == 1)
        {
            estimated_discharge[1] = 0;
            // set initial state of charge
            estimated_soc[1] = initial_soc_prior;
        }
        else
        {
            estimated_discharge[i] = normal_rng(estimated_discharge[i-1] + (fabs(current_measured[i]) * time_step[i]) / 3600, discharge_error);
            estimated_soc[i] = normal_rng(estimated_soc[i-1] + (current_measured[i] * time_step[i]) / (discharge_capacity_measured*3600), soc_error);
        }
    }
}