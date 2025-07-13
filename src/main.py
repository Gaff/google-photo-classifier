import photoclassifier.main as main_module
import photoclassifier.event as event
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
    return event.on_event(event, context)
