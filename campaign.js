// Assuming web3 is already initialized and the contract is set up
const contractAddress = 'YOUR_CONTRACT_ADDRESS';
const contractABI = []; // Add your contract ABI here

const web3 = new Web3(window.ethereum);
const contract = new web3.eth.Contract(contractABI, contractAddress);

export const createCampaign = async (title, description, goal) => {
    const accounts = await web3.eth.getAccounts();
    await contract.methods.createCampaign(title, description, web3.utils.toWei(goal, 'ether')).send({ from: accounts[0] });
};

export const loadCampaigns = async () => {
    const campaignsList = document.getElementById('campaigns');
    campaignsList.innerHTML = '';

    const campaigns = await contract.methods.getCampaigns().call();
    campaigns.forEach(campaign => {
        const listItem = document.createElement('li');
        listItem.className = 'list-group-item';
        listItem.innerText = `${campaign.title} - Goal: ${web3.utils.fromWei(campaign.goal, 'ether')} ETH`;
        campaignsList.appendChild(listItem);
    });
};