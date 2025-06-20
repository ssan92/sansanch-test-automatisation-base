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
