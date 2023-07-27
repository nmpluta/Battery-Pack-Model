data {
    int<lower=0> N; // number of data points
    int<lower=0> K; // number of predictors
    int<lower=0> L; // number of simulated samples
    matrix[N, K] x; // predictor matrix
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

generated quantities {
    real mu0 = normal_rng(0.4, 0.1);
    real<lower=0> sigma0 = normal_rng(0.15, 0.05);
    real<lower=0> sigma = exponential_rng(0.1);
    vector[K] theta;

    for (k in 1:K) {
        theta[k] = normal_rng(mu0, sigma0);
    }

    vector[K] beta = R_ast_inverse * theta;         // coefficients for x
    vector[L] mu = sub_x * beta;                    // predicted values
    array[L] real y_ppc = normal_rng(mu, ones_L*sigma);  // simulate y
}
