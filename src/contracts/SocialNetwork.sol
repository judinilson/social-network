pragma solidity >=0.4.16 <0.9.0;

contract SocialNetwork{
    string public name;
    uint public postCount = 0;
    mapping(uint => Post) public posts; // key value store that allow us store data

    struct Post {
        uint id;
        string content;
        uint tipAmount; 
        address payable author;
    }

    event PostCreated(
        uint id,
        string content,
        uint tipAmount,
        address payable author
    );
event PostTipped(
        uint id,
        string content,
        uint tipAmount,
        address payable author
    );
    constructor() public{
        name = "Social Network Blockchain";
    }

    function createPost(string memory _content)public{
        //require valid contentType
        require(bytes(_content).length>0);
        postCount++;
        posts[postCount] = Post(postCount,_content,0,msg.sender);
        // trigger event 
        emit PostCreated(postCount,_content,0,msg.sender);
    }

    function tipPost(uint _id ) public payable{
        //Make sure ther id is valid 
        require(_id > 0 && _id <= postCount);
        //fetch the post
        Post memory _post = posts[_id];
        // fetch the author 
        address payable _author = _post.author;
        //pay the author
        address(_author).transfer(msg.value);
        //increment the tip Amount
        _post.tipAmount = _post.tipAmount + msg.value;
        //update the post 
        posts[_id] = _post;
        //trigger event
        emit PostTipped(postCount,_post.content,_post.tipAmount,_author);
    }
}