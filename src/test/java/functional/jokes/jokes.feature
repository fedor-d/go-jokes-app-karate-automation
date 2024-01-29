Feature: Go Jokes App Functional Tests


  Background:
    # Define URL for all the tests
      # https://github.com/karatelabs/karate?tab=readme-ov-file#url
    * url 'http://localhost:8080/v1/'

    # Define path for some kind of flexibility
    * def jokesPath = 'jokes'


    # Define simple auxiliary methods via
    # Java
    * def uuid = function() { return java.util.UUID.randomUUID() + ''}

    # and JavaScript
    * def uppercase = function(s) { return s.toUpperCase()}

  Scenario: Get all jokes and then get the first joke by id
  and then verify response equals predefined first joke
    # Get all jokes
    Given path jokesPath
    When method get
    Then status 200
    * print uuid()
    * print uppercase(uuid())

    # Store the first joke in the firstJoke variable
    * def firstJoke = response[0]

    # Build a new path that build path by using the init URL, jokesPath and first.id
    Given path jokesPath, firstJoke.id
    When method get
    Then status 200

    # Read the valid response from repository
    * def validFirstJoke = read('classpath:functional/jokes/data/the_first_joke.json')

    * match response == validFirstJoke


  Scenario: Create a joke and then get it by id
    * def joke =
      """
      {
          "id": "10000",
          "jokeText": "It's not a joke!!!"
        }
      }
      """
    # Another method to define a joke. An example is in the previous case
    #    * def joke = read('classpath:functional/jokes/data/yet_another_joke.json')

    # Use Java predefined method to generate uuid and reassign it to joke.id

    Given path jokesPath
    And request joke
    When method post
    Then status 201

    * def id = response.id
    * print 'Created id is: ', id

    Given path jokesPath, id
    When method get
    Then status 200
    And match response contains joke


  Scenario: Schema Validation tests

    Given path jokesPath
    When method get

    * def jokes = response
    * match each jokes == { id: '#string', jokeText: '#string' }
    * match each jokes == { id: '#notnull', jokeText: '#present', i_should_not_be_here: '#notpresent' }
