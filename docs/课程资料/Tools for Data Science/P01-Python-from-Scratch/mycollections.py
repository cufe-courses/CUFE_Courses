def fib(n):    # write Fibonacci series up to n
    """Print a Fibonacci series up to n.

        argument
            n: numeric number

        vaule
            return Fibonacci series
    """
    a, b = 0, 1
    while a < n:
        print(a, end=' ')
        #  better than print(a), why?
        a, b = b, a+b


def fib_return(n):    # write Fibonacci series up to n
    """Print a Fibonacci series up to n.

        argument
            n: numeric number

        vaule
            return Fibonacci series
    """
    a, b = 0, 1
    out = []
    while a < n:
        out.append(a)
        #  better than print(a), why?
        a, b = b, a+b

    return out
    
    
def is_leapyear(year):
    """Check if a given year is leap year"""
    
    if (year % 400 == 0) or (year % 100 != 0 and year % 4 == 0):
        return True
    else:
        return False
