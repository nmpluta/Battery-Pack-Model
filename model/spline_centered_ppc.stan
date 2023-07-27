data {
    int<lower=0> N; // number of data points
    int<lower=0> K; // number of predictors
    int<lower=0> L; // number of simulated samples
    matrix[N, K] x; // predictor matrix
}

generated quantities {
    // prior estimates
    real<lower=0> sigma0 = normal_rng(0.25, 0.1);
    real mu0 = normal_rng(1.6, 0.1);
    real<lower=0> sigma = exponential_rng(0.1);

    vector[K] beta_raw;
    vector[K] beta;
    for (k in 1:K) {
        beta_raw[k] = normal_rng(0, 1);
        beta[k] = mu0 + sigma0 * beta_raw[k];   // regularized with hyperparameters
    }

    vector[L] mu;
    for (l in 1:L) {
        mu[l] = x[l] * beta;    // calculate predicted values
    }

    array[L] real y_ppc = normal_rng(mu, sigma);    // simulate y
}
