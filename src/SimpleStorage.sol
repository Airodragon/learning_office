// SPDX-License-Identifier: MIT
// SPDX = license for this code. MIT means "you can use this freely".

pragma solidity 0.8.19;
// pragma tells the compiler which Solidity version to use.
// 0.8.19 means: use exactly version 0.8.19 (not newer, not older).

/**
 * SimpleStorage
 * -------------
 * A tiny practice contract.
 * It remembers one favorite number, a list of people, and a name -> number lookup.
 *
 * Think of the blockchain like a shared notebook:
 * - "store" writes in the notebook
 * - "retrieve" only reads the notebook (cheaper, no state change)
 */
contract SimpleStorage {
    // State variable: saved forever on the blockchain until someone changes it.
    // "uint256" = unsigned integer (only 0 or positive), up to a very large number.
    // This one is private-ish by default (no "public"), so we need retrieve() to read it.
    uint256 myFavoriteNumber;

    // struct = a custom bundle of related data (like a small form).
    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    // Dynamic array of Person structs.
    // "public" creates a free getter: listOfPeople(index) returns that person.
    Person[] public listOfPeople;

    // mapping = like a dictionary / hashmap.
    // Key: name (string)  ->  Value: favorite number (uint256)
    // Example: nameToFavoriteNumber["Alice"] = 7
    mapping(string => uint256) public nameToFavoriteNumber;

    // Writes a new favorite number on-chain.
    // "public" means anyone can call this function.
    // Underscore prefix (_favoriteNumber) is just a naming habit for inputs.
    function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
    }

    // Reads the saved favorite number.
    // "view" means: this function does NOT change blockchain state.
    // It only looks at data, so it costs no gas when you call it off-chain (e.g. with cast).
    function retrieve() public view returns (uint256) {
        return myFavoriteNumber;
    }

    // Adds one person to the list AND updates the name -> number mapping.
    // "memory" on _name means: this string lives only during the function call,
    // then we copy what we need into storage (the list / mapping).
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // push adds a new Person to the end of the array
        listOfPeople.push(Person(_favoriteNumber, _name));
        // also save a fast lookup by name
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
