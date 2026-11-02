describe('Should be able to hit Ops Web with OAuth', () => {
    it('First get a token and hit contract atom feed page', () => {
      cy.login().then((resp)=>{
        //cy.request('https://fcs-dev-dat-app-x-opsweb.azurewebsites.net/ConnectivityChecker/dist/#/login', {headers: })
        const {access_token} = resp.body;
        cy.log('access_token:' + access_token);
        cy.request({
          method: "GET",
          url: 'https://fcs-dev-dat-app-x-opsweb.azurewebsites.net/ConnectivityChecker/dist/#/contract-atom-feed',
          headers: {
            Authorization: `Bearer ${access_token}`,
            "Content-type": "application/json"
          }
        });

        cy.server({
          onAnyRequest: function(route, proxy) {
               proxy.xhr.setRequestHeader('Authorization', `Bearer ${access_token}`);
               cy.log('bb:' + access_token);
           }
        });

        cy.visit('https://fct-opsweb-dat.fct-sfa.com/ConnectivityChecker/dist/#/contract-atom-feed/', {
          headers: {
          Authorization: `Bearer ${access_token}`,
          "Content-type": "application/json"
        }});
        
        cy.get('input')
        .type('MAIN')
      });
      })
    })