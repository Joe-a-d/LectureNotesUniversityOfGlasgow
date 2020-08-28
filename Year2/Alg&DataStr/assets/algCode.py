INSERTION-SORT(A)
    for j = 1 to n-1
        key := A[j]
        i := j-1
    while i >= 0 and A[i] > key
        A[i+1] := A[i]
        i := i-1
        A[i+1] := key
