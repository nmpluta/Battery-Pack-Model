
data {
    int<lower=0> N;
    vector[N] current_ptp;
    vector[N] capacity;
}

parameters {
    real alpha;
    real theta;
    real sigma;
}

model {
    alpha ~ normal(1.6, 0.1);
    theta ~ normal(0.6, 0.05);
    sigma ~ normal(0.0001, 0.00001);

    capacity ~ normal(alpha + theta * current_ptp, sigma);
}

generated quantities {
    vector[N] single_capacity;
    for (i in 1:N) { 
        single_capacity[i] = normal_rng(alpha + theta * current_ptp[i], sigma);
    }
}
