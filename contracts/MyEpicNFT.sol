// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  uint256 totalMintAmount = 100;

  string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
  string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] firstWords = ["Fantastic", "Amazing", "Marvelous", "Beautiful", "Weird", "Crazy", "Wonderful", "Spicy", "Ridiculus", "Powerful"];
  string[] secondWords = ["Dog", "Puppy", "Turtle", "Rabbit", "Parrot", "Cat", "Kitten", "Goldfish", "Mouse", "Tropical fish", "Hamster", "Cow", "Rabbit", "Ducks", "Shrimp", "Pig", "Goat", "Crab", "Deer", "Bee", "Sheep", "Fish", "Turkey", "Dove", "Chicken", "Horse", "Crow", "Peacock", "Dove", "Sparrow", "Goose", "Stork", "Pigeon", "Turkey", "Hawk", "Bald eagle", "Raven", "Parrot", "Flamingo", "Seagull", "Ostrich", "Swallow", "Black bird", "Penguin", "Robin", "Swan", "Owl", "Woodpecker", "Squirrel", "Dog", "Chimpanzee", "Ox", "Lion", "Panda", "Walrus", "Otter", "Mouse", "Kangaroo", "Goat", "Horse", "Monkey", "Cow", "Koala", "Mole", "Elephant", "Leopard", "Hippopotamus", "Giraffe", "Fox", "Coyote", "Hedgehong", "Sheep", "Deer", "Giraffe", "Woodpecker", "Camel", "Starfish", "Koala", "Alligator", "Owl", "Tiger", "Bear", "Blue whale", "Coyote", "Chimpanzee", "Raccoon", "Lion", "Arctic wolf", "Crocodile", "Dolphin", "Elephant", "Squirrel", "Snake", "Kangaroo", "Hippopotamus", "Elk", "Fox", "Gorilla", "Bat", "Hare", "Toad", "Frog", "Deer", "Rat", "Badger", "Lizard", "Mole", "Hedgehog", "Otter", "Reindeer", "Crab", "Fish", "Seal", "Octopus", "Shark", "Seahorse", "Walrus", "Starfish", "Whale", "Penguin", "Jellyfish", "Squid", "Lobster", "Pelican", "Clams", "Seagull", "Dolphin", "Shells", "Sea urchin", "Cormorant", "Otter", "Pelican", "Sea anemone", "Sea turtle", "Sea lion", "Coral"];
  string[] thirdWords = ["Accountant", "Actor", "Architect", "Astronomer", "Author", "Baker", "Bricklayer", "Driver", "Butcher", "Carpenter", "Chef", "Cleaner", "Dentist", "Designer", "Doctor", "Dustman", "Electrician", "Engineer", "Farmer", "Fireman", "Fisherman", "Florist", "Gardener", "Hairdresser", "Journalist", "Judge", "Lawyer", "Lecturer", "Librarian", "Lifeguard", "Mechanic", "Model", "Newsreader", "Nurse", "Painter", "Pharmacist", "Photographer", "Pilot", "Plumber", "Politician", "Policeman", "Postman", "Receptionist", "Scientist", "Secretary", "Soldier", "Tailor "];
  string[] colors = ["red", "#08C2A8", "black", "yellow", "blue", "green"];

  event NewEpicNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("Let's do this! now with some NFT on it");
  }

  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  function pickRandomColor(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
    rand = rand % colors.length;
    return colors[rand];
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();
    require(newItemId <= totalMintAmount, "We reached the end of the minting baby!");

    // We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));

    string memory randomColor = pickRandomColor(newItemId);
    string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));

    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares with animals professions and jobs.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalSvg);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);

    _setTokenURI(newItemId, finalTokenUri);

    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    emit NewEpicNFTMinted(msg.sender, newItemId);
  }

  function getMintedAmount() public view returns (uint256) {
    return _tokenIds.current();
  }
}