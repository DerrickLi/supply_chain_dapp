pragma solidity ^0.4.13;

contract AmazonDapp {
  
    mapping(address => Owner) owners;
    struct Owner {
      	string name;
    	address addr; 
      	uint balance;
        uint[] ownedItems; 
    }
  	
    mapping(uint => Item) items;
    struct Item {
    	uint id;
      	uint price;
      	address[] history;
        bool forSale;
        address currentOwner;
    }
  
  modifier isItemOwner(uint id){
  	require(items[id].currentOwner == msg.sender);
    _;
    
  }
  
    modifier hasJoined(){
  	require(owners[msg.sender].addr != address(0));
    _;
    }
  
    modifier itemExistsAndIsItemOwner(uint item_id){
    require(items[item_id].id == item_id);
  	require(items[item_id].currentOwner == msg.sender);
    _;
  
  }
  

  
  
  
  	function addItem(uint serial, string n, uint price) public returns (string) {
          if (items[serial].id == serial) {
            return "Item already exists. Try again";
          }
          
          // isItemOwner
          Owner first = owners[msg.sender];
          if (first.addr != msg.sender) {
            return "You are not a valid owner";
          }
          
          // price is the highest value, actually set the price later
          items[serial] = Item(serial, price, new address[](0), true, msg.sender);
          items[serial].history.push(msg.sender); // set first owner of item
          
          return "You have successfully added an item";
  
  	}
                               
    
  
  	function purchase(uint itemID) returns (string) {
      if (owners[msg.sender].balance < items[itemID].price) {
        revert();
        return "Not enough funds to purchase this item.";
      }
      
      if (!items[itemID].forSale) {
      	revert();
        return "This item is not for sale.";
      }
      
      if (items[itemID].currentOwner == msg.sender) {
          
//      	revert();
        return "You are already the owner of this item.";
      }
      
      owners[msg.sender].balance -= items[itemID].price;
      owners[items[itemID].currentOwner].balance += items[itemID].price;
      items[itemID].currentOwner = msg.sender;
      
  	}
    
      function join(string name) public returns (string) { 
        if (owners[msg.sender].addr == msg.sender) {
          return "You are already part of the contract";
        }
        uint[] memory ownedItems;
        owners[msg.sender] = Owner(name, msg.sender, 0, ownedItems);
        return "You have joined the contract!";
      }
          
      function addFunds() public payable returns(string) {
        if (msg.value <= 0) {
          return "You must add a valid amount.";
      	}
        owners[msg.sender].balance += msg.value;
        return "You have successfully added funds.";
      }
      
     function getFunds() returns (uint) {
              return owners[msg.sender].balance;
     }                               
        
      function changeToSellable(uint item_id) itemExistsAndIsItemOwner(item_id) {
      	items[item_id].forSale = true;
      }
      
      function changeToNotSellable(uint item_id) itemExistsAndIsItemOwner(item_id) {
        items[item_id].forSale = false;
      }
                               
     function setItemPrice(uint item_id, uint newPrice) itemExistsAndIsItemOwner(item_id){
        items[item_id].price = newPrice; 
     }
     
  function withdraw(uint amount) returns (string) {
  if (amount > owners[msg.sender].balance) {
    return "Insufficient funds";
  }
  
  owners[msg.sender].balance -= amount;
  msg.sender.transfer(amount);
  return "Successfully transferred";
  
}

  
  function getItemHistory(uint item_id) returns(address[]){
      return items[item_id].history;
  }
  function () payable {
    revert();
  }
    

}