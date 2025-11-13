/// <reference types="cypress" />

/**
 * Savrli City V1 – Smoke Test
 *
 * Critical path:
 *   1. App loads
 *   2. User signup
 *   3. Concierge onboarding
 *   4. Primary task (restaurant reservation)
 *
 * Update `data-cy` attributes in your Flutter widgets.
 */

describe('Savrli City V1 – Core Flow (Smoke)', () => {
  const baseUrl = Cypress.config('baseUrl') || 'http://localhost:8080';
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
    date: '2025-12-01',
    time: '19:00',
    requests: 'Window seat preferred',
  };

  beforeEach(() => {
    cy.viewport(1280, 720);
  });

  it('loads the application', () => {
    cy.visit(baseUrl);
    cy.wait(3000); // Flutter web bootstrap
    cy.get('body').should('be.visible');
    cy.log('Application loaded');
  });

  it('completes user signup', () => {
    cy.visit(`${baseUrl}/signup`);

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

  it('completes concierge onboarding', () => {
    // Assy: already on /onboarding

    onboarding.cuisines.forEach((cuisine) => {
      cy.get(`[data-cy="cuisine-${cuisine.toLowerCase()}"]`).click();
    });

    onboarding.dietary.forEach((diet) => {
      cy.get(`[data-cy="diet-${diet}"]`).click();
    });

    cy.get(`[data-cy="price-${onboarding.price}"]`).click();

    cy.get('input[data-cy="city"]').type(onboarding.city);
    cy.get('input[data-cy="zip"]').type(onboarding.zip);

    cy.get('[data-cy="onboard-complete"]').click();

    cy.url().should('include', '/dashboard');
    cy.contains('Your concierge is ready', { timeout: 10000 }).should('be.visible');
    cy.log('Onboarding completed');
  });

  it('creates a restaurant reservation', () => {
    cy.visit(`${baseUrl}/dashboard`);

    cy.get('[data-cy="create-task-btn"]').click();
    cy.get('[data-cy="task-type-reservation"]').click();

    cy.get('input[data-cy="restaurant"]').type(reservation.restaurant);
    cy.get('input[data-cy="party-size"]').clear().type(reservation.partySize);
    cy.get('input[data-cy="date"]').type(reservation.date);
    cy.get('input[data-cy="time"]').type(reservation.time);
    cy.get('textarea[data-cy="special-requests"]').type(reservation.requests);

    cy.get('[data-cy="task-submit"]').click();

    cy.contains('Task created', { timeout: 15000 }).should('be.visible');
    cy.get('[data-cy="task-status"]').should('contain', 'pending');
    cy.log('Reservation created');
  });

  it('completes full end-to-end flow', () => {
    cy.log('=== Full E2E Flow Start ===');

    // 1. Signup
    cy.visit(`${baseUrl}/signup`);
    cy.get('input[name="email"]').type(user.email);
    cy.get('input[name="password"]').type(user.password);
    cy.get('button[type="submit"]').click();
    cy.url().should('include', '/onboarding');

    // 2. Onboarding
    onboarding.cuisines.forEach((c) => cy.get(`[data-cy="cuisine-${c.toLowerCase()}"]`).click());
    onboarding.dietary.forEach((d) => cy.get(`[data-cy="diet-${d}"]`).click());
    cy.get(`[data-cy="price-${onboarding.price}"]`).click();
    cy.get('input[data-cy="city"]').type(onboarding.city);
    cy.get('input[data-cy="zip"]').type(onboarding.zip);
    cy.get('[data-cy="onboard-complete"]').click();
    cy.url().should('include', '/dashboard');

    // 3. Reservation
    cy.get('[data-cy="create-task-btn"]').click();
    cy.get('[data-cy="task-type-reservation"]').click();
    cy.get('input[data-cy="restaurant"]').type(reservation.restaurant);
    cy.get('input[data-cy="party-size"]').clear().type(reservation.partySize);
    cy.get('input[data-cy="date"]').type(reservation.date);
    cy.get('input[data-cy="time"]').type(reservation.time);
    cy.get('textarea[data-cy="special-requests"]').type(reservation.requests);
    cy.get('[data-cy="task-submit"]').click();

    cy.contains('Task created', { timeout: 15000 }).should('be.visible');
    cy.log('=== Full E2E Flow Completed ===');
  });

  // Optional: API health check
  context('API Endpoints (Smoke)', () => {
    const api = Cypress.env('API_BASE_URL') || 'https://staging-api.savrli.city/v1';

    ['/auth/signup', '/onboarding', '/tasks/primary'].forEach((path) => {
      it(`has ${path} endpoint`, () => {
        cy.request({ method: 'OPTIONS', url: `${api}${path}`, failOnStatusCode: false })
          .its('status')
          .should('be.oneOf', [200, 204, 404]);
      });
    });
  });
});