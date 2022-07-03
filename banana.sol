// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

pragma solidity ^0.8.6;

interface IERC721 is IERC165 {

    function ownerOf(uint256 tokenId) external view returns (address owner);
}

contract Banana is ERC1155, Ownable {
    uint256 public constant MAX_SUPPLY = 8888;
    string private baseURI;
    uint256 public _minted = 0;
    uint256 public bananaPrice = 0.05 ether;
    mapping (uint256 => uint256) private AlreadyClaimed;
    address SuperBanana;
    IERC721 NFTEE = IERC721(0x8F3819b281012fBa163c57100d5d819798FE12f6);
    
    constructor() ERC1155("") {
    }

    function mint(uint256 amount, uint256 NfTeesId) public payable {
        require(amount + _minted <= MAX_SUPPLY, "Banana: Exceed max supply");
        address owner = NFTEE.ownerOf(NfTeesId);
        require(owner == msg.sender, "Must be Owner of OG collection to mint");
        require(msg.value == amount * bananaPrice, "Invalid funds provided");
        require(AlreadyClaimed[NfTeesId] < 2 , "Token already claimed");
        _minted += amount;
        AlreadyClaimed[NfTeesId] += amount;
        _mint(msg.sender, 0, amount, "");
        delete owner;
    }

    function burnBanana(address burnTokenAddress) external {
        require(msg.sender == SuperBanana , "Invalid caller, must be called from SuperBanana Smart Contract");
        _burn(burnTokenAddress, 0, 1);
    }

    function setSuperBananaAddress(address SuperBananaAddress) external onlyOwner {
        SuperBanana = SuperBananaAddress;
    }

//    function setGodHatesAddress(address _GodHatesAddress) external onlyOwner {
//        GodHatesAddress = _GodHatesAddress;
//    }

    function updateBaseUri(string memory _baseURI) external onlyOwner {
        baseURI = _baseURI;
    }
}
