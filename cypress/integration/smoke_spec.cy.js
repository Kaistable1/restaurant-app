// Minimal Cypress smoke test skeleton — update selectors and endpoints to match your app.
describe('Savrli City V1 core flow', () => {
  const email = `test+${Date.now()}@example.com`;
  const password = 'Password123!';

  it('signup -> onboarding -> primary task', () => {
    // 1) Visit signup page
    cy.visit('/signup');

    // 2) Fill signup (adjust selectors)
    cy.get('input[name="email"]').type(email);
    cy.get('input[name="password"]').type(password);
    cy.get('button[type="submit"]').click();

    // 3) Confirm redirected to onboarding
    cy.url().should('include', '/onboarding');

    // 4) Complete onboarding steps (adjust selectors)
    // Step 1
    cy.get('[data-cy="onboard-step-1"] input').first().type('Test');
    cy.get('[data-cy="onboard-next"]').click();

    // Step 2 (if exists)
    // cy.get('[data-cy="onboard-step-2"] input').first().type('More info');
    // cy.get('[data-cy="onboard-complete"]').click();

    // 5) Ensure onboarding complete
    cy.get('[data-cy="onboard-complete"]').click();
    cy.url().should('include', '/dashboard');

    // 6) Perform primary task (adjust selectors)
    cy.get('[data-cy="primary-action-input"]').type('Sample payload');
    cy.get('[data-cy="primary-action-submit"]').click();

    // 7) Verify success state
    cy.get('[data-cy="primary-action-success"]').should('be.visible');
  });
});
