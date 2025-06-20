@HU639 @marvel
Feature: Test de APi Personajes de Marvel

  Background:
    * configure ssl = false
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'

    @Id 1 @personsajes @personajesOk
  Scenario: Obtener lista de personajes
    Given path '/testuser/api/characters'
    When method get
    Then status 200
    And match response !=null

    @Id 2 @personsajes @personajesPorId
  Scenario: Obtener lista de personajes por id
    Given path '/testuser/api/characters/133'
    When method get
    Then status 200
    And match response.id == 133
    And print response

  @Id 3 @personsajes @personajesPorIdNoExiste
  Scenario: Obtener lista de personajes por id y el id no existe
    Given path '/testuser/api/characters/1'
    When method get
    Then status 404
    And match response.error == "Character not found"
    And print response

@Id 4 @creacion @creacionExitosa
  Scenario: creacion de personaje exitosa
    * def result = call read('classpath:karate-creacion-personsaje.feature') { urlBase: 'http://bp-se-test-cabcd9b246a5.herokuapp.com' }
    * def personajeId = result.personajeId
    * def statusCode = result.statusCode
    * match statusCode == 201
    * match personajeId != null

@Id 5 @creacion @creacionNoExitosa
  Scenario: creacion de personaje no exitosa
    Given path '/testuser/api/characters'
    * def requestBody = read('classpath:../request/CrearPersonsajeExistenteRequest.json')
    And request requestBody
    When method post
    Then status 400
    And match response.error contains "already exists"
    And print response

@Id 6 @creacion @creacionFaltanCampos
  Scenario: creacion de personaje, faltan campos obligatorios
    Given path '/testuser/api/characters'
    * def requestBody = read('classpath:../request/CrearPersonajeCampoObligatorio.json')
    And request requestBody
    When method post
    Then status 400
    And match response.name contains "required"
    And match response.description contains "required"
    And match response.powers contains "required"
    And match response.alterego contains "required"
    And print response

@Id 7 @actualizacion @actualizacionExitosa
  Scenario: actualizacion de personaje exitosa
    Given path '/testuser/api/characters/133'
    * def requestBody = read('classpath:../request/UpdatePersonsajeRequest.json')
    And request requestBody
    When method put
    Then status 200
    And match response.name == "Santiago Sanchez"
    And match response.description == "Ingeniero"

    @Id 8 @actualizacion @actualizacionNoExitosa
  Scenario: actualizacion de personaje no exitosa
    Given path '/testuser/api/characters/999'
    * def requestBody = read('classpath:../request/UpdatePersonsajeRequest.json')
    And request requestBody
    When method put
    Then status 404
    And match response.error == "Character not found"


    @Id 9 @eliminacion @eliminacionNoExistosa
  Scenario: eliminacion de personaje no exitosa
    Given path '/testuser/api/characters/999'
    When method delete
    Then status 404
    And match response.error == "Character not found"

  @Id 10 @eliminacion @eliminacionExistosa
  Scenario: eliminacion de personaje exitosa
    * def result = call read('classpath:karate-creacion-personsaje.feature') { urlBase: 'http://bp-se-test-cabcd9b246a5.herokuapp.com' }
    * def personajeId = result.personajeId
    Given path '/testuser/api/characters/',personajeId
    When method delete
    Then status 204