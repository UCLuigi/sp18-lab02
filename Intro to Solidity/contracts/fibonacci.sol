pragma solidity 0.4.19;


contract Fibonacci {
    /* Carry out calculations to find the nth Fibonacci number */
    function fibRecur(uint n) public pure returns (uint) {
      if (n < 2) {
        return n;
      } else {
          return fibRecur(n-1) + fibRecur(n-2);
      }
    }


    /* Carry out calculations to find the nth Fibonacci number */
    function fibIter(uint n) public returns (uint) {
      uint a = 0;
      uint b = 1;
      for (uint i = 0; i < n; i++) {
        uint temp = a;
        a = b;
        b = temp + b;
      }
      return a;
    }
}
