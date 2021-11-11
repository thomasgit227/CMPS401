condition = TRUE

if( condition == TRUE ){
  print("The condition is true.")
  
} else if ( condition == FALSE ){
  print("The condition is false.")
  
}

condition <- !condition

if( condition == TRUE ){
  print( "The condition is now true." )
} else{
  print( "The condition is now false.")
}

condition <- 4

x <- switch( condition, "first condition", "second condition", "third condition", "fourth condition" )

print( paste("The switch function evaluated to the", x ) )

