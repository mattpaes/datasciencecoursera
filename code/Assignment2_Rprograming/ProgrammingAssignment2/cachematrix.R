##The first function creates an environment around a matrix x. This environment has four functions that can be used to probe the matrix and its inverse.
##The result is a list containing four arguments corresponding to the existing functions of the environment.

makeCacheMatrix <- function(x = matrix()) 
{
       inv <- NULL
        
        set<- function(y)
        {
                x <<- y
                inv <<-NULL
        }
        
       get<- function() x
        
       setinv<- function(invert) inv<<- invert
      
       getinv<- function() inv

       
       list(set = set, get = get,
                     setinv = setinv,
                     getinv = getinv)
       
}


##This function takes an element from the previously defined environment and calculates the inverse matrix of x.
##First it verifies if the invert matrix has already been stored and if not it calculates it with the solve() function.

cacheSolve <- function(x, ...) 
{
        inv <- x$getinv()
        
        if(!is.null(inv)) 
                {
                        message("getting cached data")
                        return(inv)
                }
               
        data <- x$get()
        inv <- solve(data)
        x$setinv(inv)
        inv
}
