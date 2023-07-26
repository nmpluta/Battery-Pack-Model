data {
    int<lower=0> N;
    int<lower=0> K;
    int<lower=0> L;
    matrix[N, K] x;
    real<lower=0> alpha;
}

generated quantities {
    vector[K] beta;
    for (k in 1:K) {
        beta[k] = normal_rng(0, alpha);
    }

    real sigma = exponential_rng(0.1);
    
    vector[L] mu;
    for (l in 1:L) {
        mu[l] = x[l] * beta;
    }
    
    vector[L] y;
    for (l in 1:L) {
        y[l] = normal_rng(mu[l], sigma);
    }
}
