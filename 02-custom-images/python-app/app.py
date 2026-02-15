from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def home():
    return '''
    <h1>Welcome to Dockerized Python App! 🐳</h1>
    <p>Environment: %s</p>
    <p><a href="/api/data">Get Data</a></p>
    <p><a href="/health">Health Check</a></p>
    ''' % os.getenv('APP_ENV', 'development')

@app.route('/api/data')
def get_data():
    return jsonify({
        'message': 'Hello from Docker!',
        'environment': os.getenv('APP_ENV'),
        'version': '1.0.0',
        'framework': 'Flask',
        'language': 'Python'
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy', 'service': 'python-app'}), 200

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5001))
    app.run(host='0.0.0.0', port=port, debug=False)
