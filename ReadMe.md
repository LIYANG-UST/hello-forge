# Solidity-by-Example with Foundry

This repo is to write some tests with foundry/forge for solidity-by-example (https://solidity-by-example.org/).

For learning solidity and forge.

## Progress

- [x] multi delegatecall
- [x] multi call
- [x] time lock

## Cheatcodes

With forge-std, you do not need to manually declare the interface of Vm.

```
import "forge-std/Test.sol"
```

Or you can just declare the interface

```
interface Vm {
    function prank(address) external;

    function assume(bool) external;
}
```
