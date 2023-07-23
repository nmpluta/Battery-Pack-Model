data {
    int<lower=0> N; // number of data points
    int<lower=0> K; // number of predictors
    int<lower=0> L; // number of simulated samples
    matrix[N, K] x; // predictor matrix
    vector[N] y;    // outcome vector
}

transformed data {
    matrix[N, K] Q_ast;
    matrix[K, K] R_ast;
    matrix[K, K] R_ast_inverse;
    vector[L] ones_L = rep_vector(1, L);
    matrix[L, K] sub_x = block(x, 1, 1, L, K);
    // thin and scale the QR decomposition
    Q_ast = qr_thin_Q(x) * sqrt(N - 1);
    R_ast = qr_thin_R(x) / sqrt(N - 1);
    R_ast_inverse = inverse(R_ast);
}

parameters {
    vector[K] theta;        // coefficients for Q_ast
    real<lower=0> sigma;    // error scale
    real mu0;               // hyperparameter for spline prior mean
    real<lower=0> sigma0;   // hyperparameter for spline prior std
}

model {
    theta ~ normal(mu0, sigma0);        // prior on coefficients
    sigma ~ exponential(.1);            // prior on error scale
    y ~ normal(Q_ast * theta, sigma);   // likelihood
}

generated quantities {
    vector[K] beta = R_ast_inverse * theta;         // coefficients for x
    vector[L] mu = sub_x * beta;                    // predicted values
    real y_pred[L] = normal_rng(mu, ones_L*sigma);  // simulate y
}