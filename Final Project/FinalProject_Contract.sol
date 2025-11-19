/*
We have not discussed the Solidity language code in our program with anyone other than our instructor or the teaching assistants assigned to this course.
We have not used Solidity language code obtained from another student, or any other unauthorized source, either modified or unmodified.
If any Solidity language code or documentation used in our program was obtained from another source, such as a textbook or course notes, that has been clearly noted with a proper citation in the comments of our program.
*/

// SPDX-License-Identifier: MIT
// Decentralized file sharing system using IPFS hashes
pragma solidity ^0.8.27;

contract P2PFileShare{

    struct FileInfo {
        uint idnumber;
        string ipfs; //file location on IPFS (gets the hash)
        address uploader;       // Who posted it (Teacher/Student)
        string subject; // "CSCI 101.14" / "THEO 12" / "MSYS 41" 
        string fileName;        // "Assignment_1.pdf"
        uint256 timestamp;      // When it was posted
    }

}