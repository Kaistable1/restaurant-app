// cypress/e2e/smoke_spec.cy.js
/// <reference types="cypress" />

/**
 * Savrli City V1 – Smoke Test
 *
 * Critical path:
 *   1. Sign-up (new user)
 *   2. Concierge onboarding
 *   3. Create a restaurant reservation (primary task)
 *
 * Replace the `data-cy` selectors with the real ones when the UI is implemented.
 */

describe('Savrli City Concierge – Full Smoke Flow', () => {
  const baseUrl = Cypress.config('baseUrl') || 'http://localhost:8080';

  // -------------------------------------------------------------------------
  // Test data (unique per run)
  // -------------------------------------------------------------------------
  const timestamp = Date.now();
  const user = {
    email: `test+${timestamp}@example.com`,
    password: 'Password123!',
    firstName: 'Smoke',
    lastName: 'Tester',
    phone: '+15550199',
  };

  const onboarding = {
    cuisines: ['Italian', 'Japanese'],
    dietary: ['vegetarian'],
    price: 'moderate',
    city: 'San Francisco',
    zip: '94102',
  };

  const reservation = {
    restaurant: 'The Blue Duck',
    partySize: 4,
    // 7 days from now, ISO string (Flutter date-picker expects ISO)
    dateTime: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
    notes: 'Window seat preferred',
  };

  // -------------------------------------------------------------------------
  // Helper: wait for Flutter app to be ready
  // -------------------------------------------------------------------------
  const waitForApp = () => {
    cy.visit('/', { timeout: 30_000 });
    // Flutter web injects a <flt-glass-pane> element when fully booted
    cy.get('flt-glass-pane', { timeout: 20_000 }).should('exist');
    cy.log('Flutter app bootstrapped');
  };

  // -------------------------------------------------------------------------
  // Main flow
  // -------------------------------------------------------------------------
  it('completes signup → onboarding → reservation', () => {
    // ---------------------------------------------------------------------
    // 1. Load the app
    // ---------------------------------------------------------------------
    waitForApp();

    // ---------------------------------------------------------------------
    // 2. Sign-up
    // ---------------------------------------------------------------------
    cy.log('**Step 1 – Sign-up**');
    cy.get('[data-cy=nav-signup]').click();
    cy.url().should('include', '/signup');

    cy.get('[data-cy=email]').type(user.email);
    cy.get('[data-cy=password]').type(user.password);
    cy.get('[data-cy=first-name]').type(user.firstName);
    cy.get('[data-cy=last-name]').type(user.lastName);
    cy.get('[data-cy=phone]').type(user.phone);
    cy.get('[data-cy=signup-submit]').click();

    // Expect redirect to onboarding
    cy.url({ timeout: 15_000 }).should('include', '/onboarding');
    cy.contains('Welcome', { timeout: 10_000 }).should('be.visible');

    // ---------------------------------------------------------------------
    // 3. Onboarding
    // ---------------------------------------------------------------------
    cy.log('**Step 2 – Onboarding**');

    // Cuisines
    onboarding.cuisines.forEach((c) => {
      cy.get(`[data-cy=cuisine-${c.toLowerCase()}]`).click();
    });

    // Dietary restrictions
    onboarding.dietary.forEach((d) => {
      cy.get(`[data-cy=diet-${d}]`).click();
    });

    // Price range
    cy.get(`[data-cy=price-${onboarding.price}]`).click();

    // Location
    cy.get('[data-cy=city]').type(onboarding.city);
    cy.get('[data-cy=zip]').type(onboarding.zip);

    cy.get('[data-cy=onboarding-next]').click();
    cy.get('[data-cy=onboarding-complete]').click();

    // Dashboard after onboarding
    cy.url({ timeout: 15_000 }).should('include', '/dashboard');
    cy.contains('Your concierge is ready').should('be.visible');

    // ---------------------------------------------------------------------
    // 4. Primary task – restaurant reservation
    // ---------------------------------------------------------------------
    cy.log('**Step 3 – Create reservation**');

    cy.get('[data-cy=create-task]').click();
    cy.get('[data-cy=task-type-reservation]').click();

    cy.get('[data-cy=restaurant]').type(reservation.restaurant);
    cy.get('[data-cy=party-size]').clear().type(reservation.partySize.toString());

    // Date-time picker – simple click-into-field then type ISO string
    cy.get('[data-cy=datetime]').type(reservation.dateTime.slice(0, 16)); // YYYY-MM-DDTHH:mm

    cy.get('[data-cy=special-requests]').type(reservation.notes);
    cy.get('[data-cy=task-submit]').click();

    // Success indicator
    cy.get('[data-cy=task-success]', { timeout: 20_000 })
      .should('be.visible')
      .and('contain', 'created');

    cy.log('Full smoke flow passed!');
  });

  // -------------------------------------------------------------------------
  // Optional: API endpoint health checks (does not fail the build)
  // -------------------------------------------------------------------------
  context('API endpoint availability (soft check)', () => {
    const api = Cypress.env('API_BASE_URL') || 'https://staging-api.savrli.city/v1';

    const check = (path) => {
      cy.request({ method: 'OPTIONS', url: `${api}${path}`, failOnStatusCode: false })
        .then((resp) => cy.log(`${path} → ${resp.status}`));
    };

    it('signup endpoint', () => check('/auth/signup'));
    it('onboarding endpoint', () => check('/onboarding'));
    it('primary task endpoint', () => check('/tasks/primary'));
  });
});