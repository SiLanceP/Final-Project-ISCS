/*
We have not discussed the Solidity language code in our program with anyone other than our instructor or the teaching assistants assigned to this course.
We have not used Solidity language code obtained from another student, or any other unauthorized source, either modified or unmodified.
If any Solidity language code or documentation used in our program was obtained from another source, such as a textbook or course notes, that has been clearly noted with a proper citation in the comments of our program.
*/

// SPDX-License-Identifier: MIT
// Decentralized file sharing system using IPFS hashes
pragma solidity ^0.8.27;

/// @title Peer-to-Peer File Sharing System
/// @author Shaan Graal Dayag, Jez Deign Gonzales, Bea Montaño, Lance Pequierda, Jeanne Regala
/// @notice System for managing files in an academic setting

/// @notice Contract for the system
contract P2PFileShare{
    /// @notice Base URL (to be used with the IPFS hash)
    /// @dev (Copy this url + the hash and paste it in browser to grab the file)
    /// @dev (No need to download IPFS desktop)
    string constant BASE_GATEWAY = "https://ipfs.io/ipfs/";

    /// @notice fileCount   number of files in the system
    uint256 public fileCount = 0;

    /// @notice Structure representing metadata information of the file being shared
    /// @notice fileID Unique file identifier
    /// @notice ipfs Hash of the file location on IPFS
    /// @notice subject Official subject code for the subject the file is for (ex: "CSCI 101.14", "THEO 12", "MSYS 41")
    /// @notice fileName Name of the file including the filetype extension (ex: "Assignment_1.pdf")
    /// @notice uploader Address of the uploader
    struct FileInfo {
        uint fileID;
        string ipfs;
        string subject;
        string fileName;
        address uploader;
    }

    ///@notice Struct for getCourse (to show FileID and FileName
    ///@notice fileID unique file identifier
    ///@notice filename Name of the file 
    struct FileSummary {
        uint fileID;
        string fileName;
    }

    /// @notice Mapping that stores files by acting like a hash table/dictionary
    mapping(uint256 => FileInfo) public files;

    /// @notice Mapping to be able to see the IDs of a specific subject
    mapping(string => uint256[]) private _courses;

    /// @notice Event that notifies upon successful file upload
    /// @param fileID Unique file identifier
    /// @param ipfs Hash of the file location on IPFS
    /// @param subject Allows searching by subject course code; official course code for the subject the file is for (ex: "CSCI 101.14", "THEO 12", "MSYS 41")
    /// @param fileName Name of the file including the filetype extension (ex: "Assignment_1.pdf")
    /// @param uploader Allows searching by uploader; address of the uploader
    event FileUploaded(
        uint fileID,
        string ipfs,
        string indexed subject,
        string fileName,
        address indexed uploader
    );

    /// @notice Function to upload the file
    /// @param _ipfs IPFS file location hash for the file
    /// @param _fileName Filename with filetype extension
    /// @param _subject Official course code for the subject that file is being uploaded for
    function uploadFile(string memory _ipfs, string memory _fileName, string memory _subject) public {
        require(bytes(_ipfs).length > 0, "IPFS Hash is required");
        require(bytes(_fileName).length > 0, "File Name is required");
        require(bytes(_subject).length > 0, "Subject is required");

        /// @dev Updates the number of files have been uploaded to the contract
        fileCount++;

        /// @dev Populates the details of the file uploaded
        files[fileCount] = FileInfo(
            fileCount,
            _ipfs,
            _subject,
            _fileName,
            msg.sender
        );

        /// @dev Adds the new ID to the specific course's list
        _courses[_subject].push(fileCount);

        /// @dev Log successful file upload
        emit FileUploaded(fileCount, _ipfs, _subject, _fileName, msg.sender);
    }

    /// @notice Function that returns the file details
    /// @param _fileID File ID for the file being downloaded
    /// @return info Metadata from the uploaded file
    /// @return downloadUrl URL that allows users to download the file
    function getFile(uint _fileID) public view returns (FileInfo memory info, string memory downloadUrl) {
        FileInfo memory file = files[_fileID];

        /// @dev This makes it possible to just copy the text itself and paste it on a browser
        string memory fullUrl = string(abi.encodePacked(BASE_GATEWAY, file.ipfs));

        return (file, fullUrl);
    }

    /// @notice Function to get FileIDs for a specific course
    /// @param _subject Official course code of that subject
    function getCourse(string memory _subject) public view returns (FileSummary[] memory){
        uint256[] memory ids = _courses[_subject];
        /// @dev Create a temporary array to hold the results
        FileSummary[] memory result = new FileSummary[](ids.length);
        /// @dev Loop through IDs and populate the result array
        for (uint i = 0; i < ids.length; i++) {
            uint currentId = ids[i];
            result[i] = FileSummary(currentId, files[currentId].fileName);
        }

        return result;
    }
}