Feature: Crear personaje para eliminar posteriormente

  Background:
    * url urlBase

  @Id 4 @creacion @creacionExitosa
  Scenario: creacion de personaje exitosa
    Given path '/testuser/api/characters'
    * def uuid = java.util.UUID.randomUUID() + ''
    * def requestBody = read('classpath:../request/CrearPersonajeRequest.json')
    * requestBody.name = 'IronMan-' + uuid
    And request requestBody
    When method post
    Then status 201
    * def personajeId = response.id
    * def statusCode = responseStatus
    * print 'ID creado:', personajeId
    * karate.set('personajeId', personajeId)
    * karate.set('statusCode', statusCode)