mu <- c(1.2, -3.0, -4.8, 2.6)

V <- rbind(c(6.4, 3.0, 1.3, 2.1),

           c(3.0, 3.2, .59, 3.7),

           c(1.3, .59, 3.0, -.51),

           c(2.1, 3.7, -.51, 5.4))

# Cholsky Decomp
L.trans <- chol(V)
chol.check <- V == t(L.trans) %*% L

# Eigen Decomp

