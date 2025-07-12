from main import hello_world
from photoclassifier.main import hello_gcf

def test_hello_world():
    request = None  # Simulate a request object (could be a mock)
    response = hello_world(request)
    assert response == "Hello World!"

def test_hello_world2():
    request = None  # Simulate a request object (could be a mock)
    response = hello_gcf(request)
    assert response == "Hello World!"