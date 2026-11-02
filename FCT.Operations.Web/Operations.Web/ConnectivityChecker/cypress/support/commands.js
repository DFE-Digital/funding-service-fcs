// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add("login", (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })

Cypress.Commands.add('login', (overrides = {}) => {
    Cypress.log({
      name: 'loginViaAuth0',
    });
  
    const options = {
      method: 'POST',
      url: 'https://login.microsoftonline.com/fcsazuresfabisgov.onmicrosoft.com/oauth2/token',
      body: {
        grant_type: 'client_credentials',
      //  username: Cypress.env('auth_username'),
      //  password: Cypress.env('auth_password'),
     //   audience: Cypress.env('auth_audience'),
        resource: 'c8e5c2bd-26ca-40aa-8205-3b24ff37e36a',
        client_id: 'c59f94bc-ab95-4244-b298-59863f70c1b1',
          client_secret: '',
      },
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    };
    cy.request(options);
  });
