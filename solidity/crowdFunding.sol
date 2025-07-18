// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Campaign {
    struct CampaignDetails {
        string title;
        string description;
        uint goal;
        uint fundsRaised;
    }

    mapping(uint => CampaignDetails) public campaigns;
    uint public nextCampaignId;

    function createCampaign(string memory title, string memory description, uint goal) public {
        campaigns[nextCampaignId] = CampaignDetails(title, description, goal, 0);
        nextCampaignId++;
    }
}


    // Array to store all campaigns
    Campaign[] public campaigns;

    // Event to log a new campaign creation
    event CampaignCreated(uint campaignId, string title, uint goal, address owner);

    // Event to log a contribution to a campaign
    event ContributionMade(uint campaignId, address contributor, uint amount);

    // Function to create a new campaign
    function createCampaign(string memory _title, string memory _description, uint _goal) public {
        require(_goal > 0, "Goal should be greater than 0");

        // Create new campaign
        Campaign memory newCampaign = Campaign({
            title: _title,
            description: _description,
            goal: _goal,
            fundsRaised: 0,
            owner: payable(msg.sender),
            isFunded: false
        });

        campaigns.push(newCampaign);

        // Emit event to log campaign creation
        emit CampaignCreated(campaigns.length - 1, _title, _goal, msg.sender);
    }

    // Function to contribute to a campaign
    function contribute(uint campaignId) public payable {
        require(campaignId < campaigns.length, "Campaign does not exist");
        Campaign storage campaign = campaigns[campaignId];
        require(!campaign.isFunded, "Campaign already funded");
        require(msg.value > 0, "Contribution must be greater than 0");

        campaign.fundsRaised += msg.value;

        // Emit event for contribution
        emit ContributionMade(campaignId, msg.sender, msg.value);

        // Check if the goal has been reached
        if (campaign.fundsRaised >= campaign.goal) {
            campaign.isFunded = true;
        }
    }

    // Function to get the details of a campaign
    function getCampaign(uint campaignId) public view returns (
        string memory title,
        string memory description,
        uint goal,
        uint fundsRaised,
        address owner,
        bool isFunded
    ) {
        require(campaignId < campaigns.length, "Campaign does not exist");
        Campaign memory campaign = campaigns[campaignId];
        return (
            campaign.title,
            campaign.description,
            campaign.goal,
            campaign.fundsRaised,
            campaign.owner,
            campaign.isFunded
        );
    }

    // Function to withdraw funds once the goal is met
    function withdraw(uint campaignId) public {
        require(campaignId < campaigns.length, "Campaign does not exist");
        Campaign storage campaign = campaigns[campaignId];
        require(msg.sender == campaign.owner, "Only campaign owner can withdraw funds");
        require(campaign.isFunded, "Campaign goal not reached");

        uint amount = campaign.fundsRaised;
        campaign.fundsRaised = 0; // Reset funds after withdrawal

        payable(campaign.owner).transfer(amount);
    }

    // Function to get the number of campaigns
    function getCampaignCount() public view returns (uint) {
        return campaigns.length;
    }
}
