
data {
    int<lower=0> N;
    vector[N] ptps;
}

generated quantities {
    real alpha = normal_rng(1.5, 0.3);
    real theta = normal_rng(0.6, 0.2);
    real sigma = normal_rng(0.0001, 0.00001); // measurement error is assumed to be very low
    vector[N] capacity;
    
    for (i in 1:N) {
     capacity[i] = normal_rng(alpha + theta * ptps[i], sigma);
    }
}
