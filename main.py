import os, sys, json
from http.server import HTTPServer, BaseHTTPRequestHandler

instance_id=os.getenv("APP_INSTANCE_ID","backend-default")
port=int(sys.argv[1]) if len(sys.argv)>1 else 8000

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path=="/api/status":
            body=json.dumps({"status":"ok","instance":instance_id}).encode()
            self.send_response(200)
            self.send_header("Content-Type","application/json")
            self.send_header("X-Backend-Id",instance_id)
            self.end_headers()
            self.wfile.write(body)
        else:
            self.send_response(404)
            self.end_headers()

    def log_message(self,format,*args):
        pass

HTTPServer(("127.0.0.1",port),Handler).serve_forever()
