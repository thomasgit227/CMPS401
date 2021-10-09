# Inside of R there exists several different collections of data that can be made.
# These are called "vectors".

# A vector of 5 numerics. Vectors of primitive types are called "atmoic vectors".
vectorNumeric <- c( 0, 3.14, 2.718, 1.61803, 4.669 )
print( paste( "VectorFloat is of type ", class(vectorNumeric), "and it's contents are", vectorNumeric[1:5] ) )

# A vector of atmoic vectors becomes a single vector containing the contents of the inner vectors.
vectorOfVectors <- c( c("first", "vector"), c("second", "vector"), c("third", "vector") )
print( vectorOfVectors[1:3] )
