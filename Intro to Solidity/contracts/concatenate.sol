pragma solidity 0.4.19;


contract Concatenate {
  
    function concatWithoutImport(string _s, string _t) public returns (string) {
      bytes memory a_bytes = bytes(a);
      bytes memory b_bytes = bytes(b);
      string memory ab = new string(a_bytes.length + b_bytes.length);
      bytes memory ab_bytes = bytes(ab);
      uint k = 0;
      for (uint i = 0; i < a_bytes.length; i++)
        ab_bytes[k++] = a_bytes[i];
      for (i = 0; i < b_bytes.length; i++)
        ab_bytes[k++] = b_bytes[i];

      return string(ab_bytes);
    }

    /* BONUS */
    function concatWithImport(string s, string t) public returns (string) {
    }
}
