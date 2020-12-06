/// <reference types="cypress" />
describe('tiny blog', () => {
  it('loads', () => {
    cy.visit('localhost:5000')
    cy.contains('h1', 'Tiny Blog')
  })

  it('fails on purpose', () => {
    cy.visit('localhost:5000')
    cy.contains('h1', 'Some other text')
  })
})
