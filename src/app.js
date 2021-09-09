App = {
  loading: false,
  contracts: {},

  load: async () => {
    await App.loadAccount();
    await App.loadContract();
    await App.render();
  },

  loadAccount: async () => {
    const accounts = await ethereum.request({ method: 'eth_accounts' });
    
    // Set the current blockchain account
    App.account = accounts[0];
    console.log(accounts[0]);
  },
  
  
  loadContract: async () => {
    // Create a JavaScript version of the smart contract
    const medProduct = await $.getJSON('MedProduct.json');
    App.contracts.MedProduct = TruffleContract(medProduct);
    App.contracts.MedProduct.setProvider(window.ethereum);
    
    // Hydrate the smart contract with values from the blockchain
    App.medProduct = await App.contracts.MedProduct.deployed();
  },

  render: async () => {
    
     // Prevent double render
    if (App.loading) {
      return;
    }
    
    //set app status loading
    App.setLoading(true);
    // Render Account
    $('#account').html(App.account);
    console.log(App.account);
    App.setLoading(false);
  },
  
  // Javascript function to collect data from the create-medicine form and create a new block in the blockchain.
  createMed: async () => {
    App.setLoading(true);
    const medName = $('#medName').val();
    const mrp = $('#mrp').val();
    const expiry = $('#expiry').val();
    const manuDate = $('#manuDate').val();
    
    //using the newMed() function of smart contarct to create a new instance of the collected data.
    const medId = await App.medProduct.newMed(medName,mrp,expiry,manuDate, {from: App.account })
    console.log(medId);
    $('#medDetail').html(`The ID of your newely created medicine is: `+medId.logs[0].args[0].words[0]+"\n")
    console.log(medId.logs[0].args[0]);
  },
  
  // Javascript function to collect data from the create-retailer form and add the detail to the medicine block.
  addRet: async () => {
    App.setLoading(true);
    const mID = $('#mID').val();
    const date = $('#date').val();
    const name = $('#name').val();
    const location = $('#location').val();
    const addRetailer = await App.medProduct.addret(mID,date,location,name,{from: App.account });
    $('#message-success').html(`Your registration is successful !!!`)
    console.log(addRetailer);
  },

  // Javascript function to display all details
  getMed: async () => {
    App.setLoading(true);
    const medicineID = $('#medicineID').val();
    const medDetails = await App.medProduct.medInfo(medicineID);
    $('#Details').html(`Details of your Medicine  : `+"\n"+medDetails)
    console.log(medDetails);
  },


  setLoading: (boolean) => {
    App.loading = boolean;
    const loader = $('#loader');
    const content = $('#content');
    if (boolean) {
      loader.show();
      content.hide();
    } else {
      loader.hide();
      content.show();
    }
  }
}

$(() => {
  $(window).load(() => {
    App.load();
  })
})

