


// all nfts of the collection creator will be on this contract

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.4.2/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol"; 
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; 

/* Dortzio NFT-ERC721 */
contract DortzioNFT is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    
    using Counters for Counters.Counter;
    mapping (uint256 => string) private _tokenURIs;
    Counters.Counter private _tokenIdCounter;
    uint256 private royaltyFee;
    address private royaltyRecipient;

    constructor(
        string memory _name,
        string memory _symbol,
        address _owner,
        uint256 _royaltyFee,
        address _royaltyRecipient
    ) ERC721(_name, _symbol){
        require(_royaltyFee <= 10000, "can't more than 10 percent");
        require(_royaltyRecipient != address(0));
        royaltyFee = _royaltyFee;
        royaltyRecipient = _royaltyRecipient;
        transferOwnership(_owner);
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _tokenURIs[tokenId] = uri;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function totalNFTsMinted() external view returns (uint256) {
        return _tokenIdCounter.current();
    }

    function batchMint(address to, 
                      string[] memory tokenUris
                      ) public onlyOwner{

    
        for (uint256 i = 0; i < tokenUris.length; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _tokenURIs[tokenId] = tokenUris[i];
            _safeMint(to, tokenId);
            _setTokenURI(tokenId, tokenUris[i]);            
        }
    } 


    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function setTokenURIs(string[] memory newtokenUris, uint256[] memory ids)
        public
        onlyOwner
        
    {   
        for (uint256 i = 0; i < ids.length; i++) {
            require(_exists(ids[i]), "token with this id doesn't exist");
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _tokenURIs[ids[i]] = newtokenUris[ids[i]];
        }
        
    }

    function getRoyaltyFee() external view returns (uint256) {
        return royaltyFee;
    }

    function getRoyaltyRecipient() external view returns(address) {
        return royaltyRecipient;
    }

    function updateRoyaltyFee(uint256 _royaltyFee) external onlyOwner {
        require(_royaltyFee <= 10000, "can't more than 10 percent");
        royaltyFee = _royaltyFee;
    }
}
