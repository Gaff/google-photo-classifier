from main import hello_world

def test_hello_world():
    request = None  # Simulate a request object (could be a mock)
    response = hello_world(request)
    assert response == "Hello World!"