# Test rPLB() etc. with different options

test_that("rPLB() etc. functions work with different settings", {

  set.seed(42)       # Not resetting before each line, so have to run all these
                     # in order
  expect_equal(rPLB(n = 1000,
                    x_max = 1000),
               sim_vec)

  expect_equal(rPLB(),
               6.24259824)

  expect_equal(rPLB(b = -1),
               1.335035037)

  # Then do rest in order of R/PLB.R
  expect_equal(dPL(x = 1.5),
               0.444444444)

  expect_equal(pPL(),
               0.9)

  expect_equal(rPL(),
               5.55077842)

  expect_equal(dPLB(x = 1.5),
               0.448933782)

  expect_equal(dPLB(x = 1.5, b = -1),
               0.144764827)

  expect_equal(pPLB(x = 1.5),
               0.336700337)

  expect_equal(pPLB(x = 1.5, b = -1),
               0.08804563)

  expect_equal(qPLB(),
               1.109877913)

  expect_equal(qPLB(b = -1),
               1.58489319)

  expect_error(dPL(b = -1))
  expect_error(pPL(b = -1))
  expect_error(rPL(b = -1))

  expect_error(dPLB(x_min = -1))
  expect_error(pPLB(x_min = -1))
  expect_error(rPLB(x_min = -1))
  expect_error(qPLB(x_min = -1))
  expect_error(qPLB(p = 1.5))
})
