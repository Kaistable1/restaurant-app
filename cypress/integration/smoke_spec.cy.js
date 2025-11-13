/// <reference types="cypress" />

/**
 * Savrli City – Smoke Test Suite
 *
 * Critical path:
 * 1. App loads
 * 2. Signup
 * 3. Onboarding (concierge preferences)
 * 4. Primary task – restaurant reservation
 * 5. Full end-to-end flow
 *
 * Update `data-cy` selectors to match your actual UI.
 */

const BASE_URL = Cypress.config('baseUrl') || 'http://localhost:8080';
const API_URL = Cypress.env('API_BASE_URL') || 'https://staging-api.savrli.city/v1';

describe('Savrli City – Smoke Test', () => {
  // -------------------------------------------------------------------------
  // Test data – unique per run
  // -------------------------------------------------------------------------
  const timestamp = Date.now();
  const user = {
    email: `test+${timestamp}@example.com`,
    password: 'Password123!',
    firstName: 'Test',
    lastName: 'User',
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
    dateTime: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
    notes: 'Window seat preferred',
  };

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------
  const selectCuisine = (name) => cy.get(`[data-cy="cuisine-${name.toLowerCase()}"]`).click();
  const selectDiet = (name) => cy.get(`[data-cy="diet-${name}"]`).click();

  // -------------------------------------------------------------------------
  // 1. App loads
  // -------------------------------------------------------------------------
  it('loads the application', () => {
    cy.visit(BASE_URL);
    cy.wait(3000); // Allow Flutter web to bootstrap
    cy.get('body').should('be.visible');
    cy.log('Application loaded successfully');
  });

  // -------------------------------------------------------------------------
  // 2. Signup flow
  // -------------------------------------------------------------------------
  it('completes user signup', () => {
    cy.visit(`${BASE_URL}/signup`);
    cy.get('input[name="email"]').type(user.email);
    cy.get('input[name="password"]').type(user.password);
    cy.get('input[name="firstName"]').type(user.firstName);
    cy.get('input[name="lastName"]').type(user.lastName);
    cy.get('input[name="phone"]').type(user.phone);
    cy.get('button[type="submit"]').click();

    cy.url().should('include', '/onboarding');
    cy.contains('Welcome', { timeout: 10000 }).should('be.visible');
    cy.log('Signup completed');
  });

  // -------------------------------------------------------------------------
  // 3. Concierge onboarding
  // -------------------------------------------------------------------------
  it('completes concierge onboarding', () => {
    // Already on /onboarding after signup
    onboarding.cuisines.forEach(selectCuisine);
    onboarding.dietary.forEach(selectDiet);
    cy.get(`[data-cy="price-${onboarding.price}"]`).click();
    cy.get('input[data-cy="city"]').type(onboarding.city);
    cy.get('input[data-cy="zip"]').type(onboarding.zip);
    cy.get('[data-cy="onboard-complete"]').click();

    cy.url().should('include', '/dashboard');
    cy.contains('Your concierge is ready', { timeout: 10000 }).should('be.visible');
    cy.log('Onboarding completed');
  });

  // -------------------------------------------------------------------------
  // 4. Primary task – restaurant reservation
  // -------------------------------------------------------------------------
  it('creates a restaurant reservation', () => {
    cy.visit(`${BASE_URL}/dashboard`);
    cy.get('[data-cy="create-task-btn"]').click();
    cy.get('[data-cy="task-type-reservation"]').click();
    cy.get('input[data-cy="restaurant"]').type(reservation.restaurant);
    cy.get('input[data-cy="party-size"]').clear().type(reservation.partySize.toString());
    cy.get('input[data-cy="datetime"]').type(reservation.dateTime.slice(0, 16));
    cy.get('textarea[data-cy="special-requests"]').type(reservation.notes);
    cy.get('[data-cy="task-submit"]').click();

    cy.contains('Task created', { timeout: 15000 }).should('be.visible');
    cy.get('[data-cy="task-status"]').should('contain', 'pending');
    cy.log('Reservation task created');
  });

  // -------------------------------------------------------------------------
  // 5. Full end-to-end flow (all steps in one test)
  // -------------------------------------------------------------------------
  it('runs the full end-to-end flow', () => {
    cy.log('=== Full E2E Flow Start ===');

    // 1. Load
    cy.visit(BASE_URL);
    cy.wait(3000);

    // 2. Signup
    cy.visit(`${BASE_URL}/signup`);
    cy.get('input[name="email"]').type(user.email);
    cy.get('input[name="password"]').type(user.password);
    cy.get('button[type="submit"]').click();
    cy.url().should('include', '/onboarding');

    // 3. Onboarding
    onboarding.cuisines.forEach(selectCuisine);
    onboarding.dietary.forEach(selectDiet);
    cy.get(`[data-cy="price-${onboarding.price}"]`).click();
    cy.get('input[data-cy="city"]').type(onboarding.city);
    cy.get('input[data-cy="zip"]').type(onboarding.zip);
    cy.get('[data-cy="onboard-complete"]').click();
    cy.url().should('include', '/dashboard');

    // 4. Reservation
    cy.get('[data-cy="create-task-btn"]').click();
    cy.get('[data-cy="task-type-reservation"]').click();
    cy.get('input[data-cy="restaurant"]').type(reservation.restaurant);
    cy.get('input[data-cy="party-size"]').clear().type(reservation.partySize.toString());
    cy.get('input[data-cy="datetime"]').type(reservation.dateTime.slice(0, 16));
    cy.get('textarea[data-cy="special-requests"]').type(reservation.notes);
    cy.get('[data-cy="task-submit"]').click();

    cy.contains('Task created', { timeout: 15000 }).should('be.visible');
    cy.log('=== Full E2E Flow Completed Successfully ===');
  });

  // -------------------------------------------------------------------------
  // Optional: API endpoint health checks (won’t fail the suite)
  // -------------------------------------------------------------------------
  context('API endpoint availability (smoke)', () => {
    const endpoints = [
      { name: 'signup', path: '/auth/signup' },
      { name: 'onboarding', path: '/onboarding' },
      { name: 'primary task', path: '/tasks/primary' },
    ];

    endpoints.forEach(({ name, path }) => {
      it(`has ${name} endpoint reachable`, () => {
        cy.request({
          method: 'OPTIONS',
          url: `${API_URL}${path}`,
          failOnStatusCode: false,
        }).then((resp) => {
          cy.log(`${name} endpoint → ${resp.status}`);
        });
      });
    });
  });
});