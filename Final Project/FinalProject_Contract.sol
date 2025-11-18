/*
We have not discussed the Solidity language code in our program with anyone other than our instructor or the teaching assistants assigned to this course.
We have not used Solidity language code obtained from another student, or any other unauthorized source, either modified or unmodified.
If any Solidity language code or documentation used in our program was obtained from another source, such as a textbook or course notes, that has been clearly noted with a proper citation in the comments of our program.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract P2PFileShare{
    enum Role {student, teacher}
    
    struct FileInfo{
        uint idnumber;
        address uploader;       // Who posted it (Teacher/Student)
        string subject;         // e.g., "CS101", "Math"
        string fileName;        // e.g., "Assignment_1.pdf"
        string Url;     // The link (Google Drive, Dropbox, etc.)
        string hash;    // SHA-256 hash to prove file hasn't been modified
        uint256 timestamp;      // When it was posted
    }
}