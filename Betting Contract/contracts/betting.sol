pragma solidity 0.4.19;


contract Betting {

    /* Constructor function, where owner and outcomes are set */
    function Betting(uint[] _outcomes) public {
        owner = msg.sender;
        outcomes_length = 0;
        for (uint i = 0; i < _outcomes.length; i++) {
            outcomes[i] = _outcomes[i];
            outcomes_length++;
        }
    }

    /* Fallback function */
    function() public payable {
        revert();
    }

    /* Standard state variables */
    address public owner;
    address public gamblerA;
    address public gamblerB;
    address public oracle;

    /* Structs are custom data structures with self-defined parameters */
    struct Bet {
        uint outcome;
        uint amount;
        bool initialized;
    }

    /* Keep track of every gambler's bet */
    mapping (address => Bet) bets;
    /* Keep track of every player's winnings (if any) */
    mapping (address => uint) winnings;
    /* Keep track of all outcomes (maps index to numerical outcome) */
    mapping (uint => uint) public outcomes;
    /* Length of outcomes array (How many outcomes there are). */
    uint outcomes_length;

    /* Add any events you think are necessary */
    event BetMade(address gambler);
    event BetClosed();

    /* Uh Oh, what are these? */
    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }
    modifier oracleOnly() {
        require(msg.sender == oracle);
        _;
    }
    modifier outcomeExists(uint outcome) {
        require(outcome < outcomes_length);
        _;
    }

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() returns (address) {
        oracle = _oracle;
    }

    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome) public payable returns (bool) {
        if (msg.sender == owner || msg.sender == oracle) {
            return false;
        } else if (gamblerA == 0) {
            gamblerA = msg.sender;
            bets[gamblerA] = Bet(msg.value, _outcome, true);
            BetMade(gamblerA);
            return true;
        } else if (gamblerB == 0) {
            gamblerB = msg.sender;
            bets[gamblerB] = Bet(msg.value, _outcome, true);
            BetMade(gamblerB);
            return true;
        } else {
            revert();
            return false;
        }
    }

    /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {
        if (gamblerA != 0 && gamblerB != 0) {
            BetClosed();
            Bet a = bets[gamblerA];
            Bet b = bets[gamblerB];
            if (a.outcome == _outcome && b.outcome == _outcome) {
                winnings[gamblerA] += a.amount;
                winnings[gamblerB] += b.amount;
            } else {
                uint total = a.amount + b.amount;
                if (a.outcome == _outcome) {
                    winnings[gamblerA] += total;
                } else if (b.outcome == _outcome) {
                    winnings[gamblerB] += total;
                } else {
                    winnings[oracle] += total;
                }
            }
            contractReset();
        }
    }

    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
        if (withdrawAmount < winnings[msg.sender]) {
            winnings[msg.sender] -= withdrawAmount;
            msg.sender.transfer(withdrawAmount);
        }
    }

    /* Allow anyone to check the outcomes they can bet on */
    function checkOutcomes(uint outcome) public view returns (uint) {
        for (uint i = 0; i < outcomes_length; i++) {
            if (outcome == outcomes[i]) {
                return i;
            }
        }
    }

    /* Allow anyone to check if they won any bets */
    function checkWinnings() public view returns(uint) {
        return winnings[msg.sender];
    }

    /* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
    function contractReset() public ownerOnly() {
        delete(oracle);
        delete(bets[gamblerA]);
        delete(bets[gamblerB]);
        delete(gamblerA);
        delete(gamblerB);
    }
}
