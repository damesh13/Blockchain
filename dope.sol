// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721Pausable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Dope is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    uint16 public maxSupply=13; 
    bool public publicMint=false;
    bool public allowlistMint=false;
    mapping(address => bool ) public listOfAllowedPeople;
    function addPeopleToList(address _address,bool _bool) external onlyOwner{
        listOfAllowedPeople[_address] = _bool;
    }

    function editMinting(bool _publicMint,bool _allowListMint) external  onlyOwner{
        publicMint = _publicMint;
        allowlistMint=_allowListMint;
    }

    constructor( ) ERC721("Dope", "DK") Ownable(msg.sender) {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmY5rPqGTN1rZxMQg2ApiSZc7JiBNs1ryDzXPZpQhC1ibm/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    

    function PublicMint() public payable  {
        require(publicMint,"sorry minting is closed ");
        require(msg.value >= 0.001 ether ,"enter more than 1 Ether");
        mint();
        
    }

    function allowListMint() public payable {
        require(listOfAllowedPeople[msg.sender],"sorry you are not on the list");
        require(allowlistMint,"sorry minting is closed ");
        require(msg.value >= 0.0001 ether ,"enter more than 1 Ether");
        mint();
        

    }

    function mint() internal {
        require(totalSupply() <= maxSupply,"we are sold out!!!!");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);

    }

    function withdraw() external onlyOwner{
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}