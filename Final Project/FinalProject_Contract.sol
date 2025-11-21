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
        string subject; // "CSCI 101.14" / "THEO 12" / "MSYS 41" 
        string fileName;        // "Assignment_1.pdf"
        address uploader;       // Who posted it (Teacher/Student)
    }

    //mapping to store files (it acts like a hash table/dictionary
    mapping(uint256 => FileInfo) public files;
    uint256 public fileCount = 0;

    //to be able to see the IDs of a specific subject
    mapping(string => uint256[]) private courses;

    //Base URL (to be used with the ipfs hash) (just copy this url + the hash and paste it on browser to grab the file) (no need to download ipfs desktop)
    string constant baseGateway = "https://ipfs.io/ipfs/";

    //Event to notify when a file is uploaded
    event FileUploaded(
        uint idnumber,
        string ipfs,
        string indexed subject, // allows searching by Course subject
        string fileName,
        address indexed uploader //allows searching by uploader
    );



    //Function to upload the file
    function uploadFile(string memory _ipfs, string memory _fileName, string memory _subject) public {
        require(bytes(_ipfs).length > 0, "IPFS Hash is required");
        require(bytes(_fileName).length > 0, "File Name is required");
        require(bytes(_subject).length > 0, "Subject is required");

        //this counts the number of files have been uploaded to the contract
        fileCount++;

        //show the details of the file uploaded
        files[fileCount] = FileInfo(
            fileCount,
            _ipfs,
            _subject,
            _fileName,
            msg.sender
        );

        //This adds the new ID to the specific course's list
        courses[_subject].push(fileCount);

        //emit is used to trigger the "event"
        emit FileUploaded(fileCount,_ipfs,_subject,_fileName,msg.sender);
    }

    //function on getting the file details
    function getFile(uint _idnumber) public view returns (FileInfo memory info, string memory downloadUrl) {
        FileInfo memory file = files[_idnumber];

        // this makes it possible to just copy the text itself and paste it on a browser
        string memory fullUrl = string(abi.encodePacked(baseGateway, file.ipfs));

        return (file, fullUrl);
    }

    //function to get FileIDs for a specific course
    function getCourse(string memory _subject) public view returns (uint256[] memory){
        return courses[_subject];
    }
}