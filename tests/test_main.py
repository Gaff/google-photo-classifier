#from main import hello_world
from photoclassifier.main import hello_gcf

def test_hello_world2():
    request = None  # Simulate a request object (could be a mock)
    response = hello_gcf(request)
    assert response == "Hello GCF!"