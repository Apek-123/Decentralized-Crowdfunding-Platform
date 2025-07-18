import { ethers } from 'ethers';
import contractABI from './Crowdfunding.json'; // ABI of the deployed contract
const provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();
const crowdfundingContract = new ethers.Contract(contractAddress, contractABI, signer);

// Example function to create a campaign
async function createCampaign(title, description, goal) {
    const tx = await crowdfundingContract.createCampaign(title, description, ethers.utils.parseEther(goal));
    await tx.wait();
}

// Example function to contribute to a campaign
async function contributeToCampaign(campaignId, amount) {
    const tx = await crowdfundingContract.contribute(campaignId, { value: ethers.utils.parseEther(amount) });
    await tx.wait();
}