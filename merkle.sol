// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.5.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.5.0/utils/cryptography/MerkleProof.sol";

contract employee_existence is ERC721, Ownable {
    using Counters for Counters.Counter;
    bytes32 public root;
    address public _owner;

mapping(address => uint256) public emp_addrToid;
mapping(uint256 =>address ) public emp_idToaddr;
    Counters.Counter private _tokenIdCounter;

    constructor(address owner) ERC721("Mikasa", "AOT") {
         _owner= owner;
    }

    function Idcard(bytes32[] memory proof) public {
        require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "Not an employee ");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        emp_addrToid[msg.sender]=tokenId;
        emp_idToaddr[tokenId]=msg.sender;
    }

    function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
        return MerkleProof.verify(proof, root, leaf);
    }

    function setRoot(bytes32 _root)external{
        require(msg.sender==_owner,"no authorization");
        root=_root;
    }

         function getEmployeeAddress(uint256 id) public view returns (address) {
        return emp_idToaddr[id];
         }

         function getEmployeeId(address emp) public view returns (uint256) {
        return emp_addrToid[emp];
    }


}
