.TEST_matrices <- list(
    matrix(1:15, nrow=3, ncol=5,
           dimnames=list(NULL, paste0("M1y", 1:5))),
    matrix(101:135, nrow=7, ncol=5,
           dimnames=list(paste0("M2x", 1:7), paste0("M2y", 1:5))),
    matrix(1001:1025, nrow=5, ncol=5,
           dimnames=list(paste0("M3x", 1:5), NULL))
)

.TEST_arrays <- list(
    array(1:60, c(3, 5, 4),
           dimnames=list(NULL, paste0("M1y", 1:5), NULL)),
    array(101:240, c(7, 5, 4),
           dimnames=list(paste0("M2x", 1:7), paste0("M2y", 1:5), NULL)),
    array(10001:10100, c(5, 5, 4),
           dimnames=list(paste0("M3x", 1:5), NULL, paste0("M3z", 1:4)))
)


test_arbind_default <- function()
{
    arbind_default <- SummarizedExperiment:::arbind_default

    ## on matrices
    target <- do.call(rbind, .TEST_matrices)
    current <- do.call(arbind_default, .TEST_matrices)
    checkIdentical(target, current)

    ## on empty matrices
    m1 <- matrix(nrow=0, ncol=3, dimnames=list(NULL, letters[1:3]))
    m2 <- matrix(1:15, ncol=3, dimnames=list(NULL, LETTERS[1:3]))

    target <- do.call(rbind, list(m1, m2))
    current <- do.call(arbind_default, list(m1, m2))
    checkIdentical(target, current)

    target <- do.call(rbind, list(m2, m1))
    current <- do.call(arbind_default, list(m2, m1))
    checkIdentical(target, current)

    target <- do.call(rbind, list(m1, m1))
    current <- do.call(arbind_default, list(m1, m1))
    checkIdentical(target, current)

    ## on arrays
    current <- do.call(arbind_default, .TEST_arrays)
    for (k in 1:4) {
        target <- do.call(rbind, lapply(.TEST_arrays, `[`, , , k))
        checkIdentical(target, current[ , , k])
    }
}

test_acbind_default <- function()
{
    acbind_default <- SummarizedExperiment:::acbind_default

    ## on matrices
    matrices <- lapply(.TEST_matrices, t)
    target <- do.call(cbind, matrices)
    current <- do.call(acbind_default, matrices)
    checkIdentical(target, current)

    ## on empty matrices
    m1 <- matrix(nrow=3, ncol=0, dimnames=list(letters[1:3], NULL))
    m2 <- matrix(1:15, nrow=3, dimnames=list(LETTERS[1:3], NULL))

    target <- do.call(cbind, list(m1, m2))
    current <- do.call(acbind_default, list(m1, m2))
    checkIdentical(target, current)

    target <- do.call(cbind, list(m2, m1))
    current <- do.call(acbind_default, list(m2, m1))
    checkIdentical(target, current)

    target <- do.call(cbind, list(m1, m1))
    current <- do.call(acbind_default, list(m1, m1))
    checkIdentical(target, current)

    ## on arrays

    ## transpose the 1st 2 dimensions
    arrays <- lapply(.TEST_arrays,
        function(a) {
            a_dimnames <- dimnames(a)
            dim(a)[1:2] <- dim(a)[2:1]
            a_dimnames[1:2] <- a_dimnames[2:1]
            dimnames(a) <- a_dimnames
            a
    })
    current <- do.call(acbind_default, arrays)
    for (k in 1:4) {
        target <- do.call(cbind, lapply(arrays, `[`, , , k))
        checkIdentical(target, current[ , , k])
    }
}

