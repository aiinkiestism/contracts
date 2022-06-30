// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MinimumViableERC721Enumerable is
    ERC721Enumerable,
    ERC721URIStorage,
    ERC721Pausable,
    Ownable
{
    using Strings for uint256;

    uint256 public maxSupply = 100e6;

    struct NFTData {
        string title;
        string[] someStringData;
        uint256[] someNumData;
    }

    mapping(uint256 => NFTData) private nftData;

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    function mint(
        string memory _imageUrl,
        string memory _title,
        string[] memory _someStringData,
        uint256[] memory _someNumData
    ) public whenNotPaused {
        uint256 supply = totalSupply();
        require(supply + 1 <= supply, "cannot mint more than maxSupply.");

        _safeMint(_msgSender(), supply + 1);
        _setTokenURI(supply + 1, _imageUrl);

        nftData[supply + 1] = NFTData(
            _title,
            _someStringData,
            _someNumData
        );
    }

    function mintByOwner(
        address _to,
        string memory _title,
        string[] memory _someStringData,
        uint256[] memory _someNumData
    ) external onlyOwner {
        uint256 supply = totalSupply();
        require(supply + 1 <= supply, "cannot mint more than maxSupply.");

        _safeMint(_to, supply + 1);
        _satTokenURI(supply + 1, _imageUrl);

        nftData[supply + 1] = NFTData(
            _title,
            _someStringData,
            _someNumData
        );
    }

    function pauseMint() external onlyOwner returns (bool) {
        require(!paused(), "_paused is already true.");
        _pause();
        return paused();
    }

    function unpauseMint() external onlyOwner returns (bool) {
        require(paused(), "_paused is already true.");
        _unpause();
        return paused();
    }

    function setMaxSupply(uint256 _newMaxSupply) external onlyOwner {
      uint256 supply = totalSupply();
      require(_newMaxSupply > supply, "_newMaxSupply should be more than supply.");

      maxSupply = _newMaxSupply;
    }

    function getTokenURI(uint256 tokenId)
        external
        view
        returns (string memory)
    {
        return ERC721URIStorage.tokenURI(tokenId);
    }

    function getOwnedTokenIds(address owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);

        for (uint256 i; i < ownerTokenCount;) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);

            unchecked {
                ++i;
            }
        }
    }

    function getNftData(uint256 tokenId)
        external
        view
        returns(NFTData memory)
    {
        return nftData[tokenId];
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
