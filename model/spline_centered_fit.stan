data {
    int<lower=0> N; // number of data points
    int<lower=0> K; // number of predictors
    int<lower=0> L; // number of simulated samples
    matrix[N, K] x; // predictor matrix
    vector[N] y;    // outcome vector
}

parameters {
    vector[K] beta_raw;      // uncentered coefficients
    real<lower=0> sigma;     // error scale
    real mu0;                // hyperparameter for spline prior mean
    real<lower=0> sigma0;    // hyperparameter for spline prior std
}

transformed parameters {
    vector[K] beta = mu0 + sigma0 * beta_raw; // centered coefficients
}

model {
    beta_raw ~ normal(0, 1);              // prior on uncentered coefficients
    sigma ~ exponential(0.1);             // prior on error scale
    y ~ normal(x * beta, sigma);          // likelihood using centered coefficients
}

generated quantities {
    vector[L] mu = rep_vector(0, L);            // predicted values
    for (l in 1:L) {
        mu[l] = x[l] * beta;                    // calculate predicted values
    }
    real y_pred[L] = normal_rng(mu, sigma);     // simulate y
}
