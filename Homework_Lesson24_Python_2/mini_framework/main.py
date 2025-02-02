from http.server import BaseHTTPRequestHandler, HTTPServer
import urllib.parse

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(b"<html><body><h1>Tylko jedno w glowie mam - Koksu piec gram</h1></body></html>")

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        parsed_data = urllib.parse.parse_qs(post_data.decode())

        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        response = f"<html><body><h1>Received Data:</h1><p>{parsed_data}</p></body></html>"
        self.wfile.write(response.encode())

if __name__ == "__main__":
    server = HTTPServer(('localhost', 8080), SimpleHandler)
    print("Server started at http://localhost:8080") #чек сервера в консоли
    server.serve_forever()
