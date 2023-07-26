data {
    int<lower=0> N; // number of data points
    int<lower=0> K; // number of predictors
    int<lower=0> L; // number of simulated samples
    matrix[N, K] x; // predictor matrix
    vector[N] y;    // outcome vector
    real<lower=0> alpha; // regularization strength (hyperparameter)
}

parameters {
    vector[K] beta;    // coefficients
    real<lower=0> sigma; // error scale
}

model {
    beta ~ normal(0, alpha);          // Gaussian prior with regularization
    sigma ~ exponential(0.1);         // prior on error scale
    y ~ normal(x * beta, sigma);      // likelihood
}

generated quantities {
    vector[L] mu = rep_vector(0, L); // predicted values
    vector[L] log_likelihood = rep_vector(0, L);
    for (l in 1:L) {
        mu[l] = x[l] * beta;        // calculate predicted values
    }
    
    real y_pred[L] = normal_rng(mu, sigma); // simulate y

    for (l in 1:L) {
        log_likelihood[l] = normal_lpdf(y[l] | mu[l], sigma); // log of likelihood function
    }
}
