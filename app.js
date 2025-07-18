const Web3 = require('web3');

// Correct Web3 instantiation
const web3 = new Web3('http://localhost:8545');

document.addEventListener("DOMContentLoaded", () => {
    const campaignForm = document.getElementById("create-campaign");

    campaignForm.addEventListener("submit", (e) => {
        e.preventDefault(); // Prevent page reload

        // Get input values
        const title = document.getElementById("title").value;
        const description = document.getElementById("description").value;
        const goal = document.getElementById("goal").value;

        // Create a new campaign object
        const newCampaign = { title, description, goal };

        // Retrieve existing campaigns from localStorage or initialize empty array
        let campaigns = JSON.parse(localStorage.getItem("campaigns")) || [];

        // Add the new campaign to the campaigns array
        campaigns.push(newCampaign);

        // Save updated campaigns array to localStorage
        localStorage.setItem("campaigns", JSON.stringify(campaigns));

        // Redirect to the new page
        window.location.href = "active-campaigns.html"; // Change to the actual URL
    });
});
