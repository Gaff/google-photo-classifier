import photoclassifier.main as main_module
import photoclassifier.events as events
import json

def main_http(request):
    ret = main_module.advanced_gcf(request)
    summary = {
        "body": request.get_json(silent=True) or {},
        "query_params": request.args.to_dict(),
        "headers": dict(request.headers),
        "method": request.method,
        "path": request.path,
        "output": ret
    }
    print(json.dumps(summary, separators=(",", ":")))

    return (
        json.dumps(ret),
        200,
        {'Content-Type': 'application/json'}
    )

def main_pubsub(event, context):
    return events.on_event(event, context)

if __name__ == "__main__":
    from flask import Flask, request
    app = Flask(__name__)

    @app.route('/hello', methods=['GET'])
    def hello():
        return main_http(request)
    
    @app.route('/test', methods=['GET', 'POST'])
    def test():
        return main_pubsub([], request.environ)

    @app.route('/event', methods=['GET', 'POST'])
    def pubsub():
        return main_pubsub(request.get_json(), request.environ)

    app.run(debug=True, host='localhost', port=8080)