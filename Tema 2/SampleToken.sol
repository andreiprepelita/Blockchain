// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SampleToken {
    
    string public name = "Sample Token";
    string public symbol = "TOK";

    uint256 public _totalSupply;
    uint256 private _totalSales;

    address owner;
    address sampleTokenSaleAddress;

    event Transfer(address indexed _from,
                   address indexed _to,
                   uint256 _value);

    event Approval(address indexed _owner,
                   address indexed _spender,
                   uint256 _value);

    mapping (address => uint256) public balances;
    mapping (address => mapping(address => uint256)) public _allowance;

    modifier onlyOwner() {

       require(msg.sender == owner, "You don't have access to this feature");
       _;
   }

   modifier hasEnoughMoney(address from, uint256 value) {

        require(value<=balances[from], "Don't have enough money");
        _;
    }

    constructor (uint256 _initialSupply) {
        balances[msg.sender] = _initialSupply;
        _totalSupply = _initialSupply;
        owner = msg.sender;
        _totalSales = 0;
        sampleTokenSaleAddress = msg.sender;

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public hasEnoughMoney(msg.sender, _value) returns (bool success) {

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        minting(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public hasEnoughMoney(_from, _value) returns (bool success) {
        require(_value <= _allowance[_from][msg.sender], "Not approved");

        
        balances[_from] -= _value;
        balances[_to] += _value;
        _allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public hasEnoughMoney(msg.sender, _value) returns (bool success) {
        
        _allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns(uint256)
    {
        return _allowance[_owner][_spender];
    }

    function setTokenSaleAddress(address _tokenSaleAddress) external onlyOwner {
        sampleTokenSaleAddress = _tokenSaleAddress;
    }

    function minting(uint256 _value) private {

        _totalSales += _value;

        while(_totalSales > 10000){
            _totalSales -=10000;
            balances[owner] +=1;
            _totalSupply +=1;
            _allowance[owner][sampleTokenSaleAddress] +=1;
            emit Transfer(address(0), owner, 1);
        }
    }
    
}