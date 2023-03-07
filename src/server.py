from flask import Blueprint, jsonify, request

# Initialize global variable here
api_bp = Blueprint('api', __name__)

@api_bp.route('/hello', methods=['GET'])
def hello_world():
    message = {'message': 'Hello, world!'}
    return jsonify(message), 200, {'Content-Type': 'application/json'}

@api_bp.route('/echo', methods=['POST'])
def echo():
    data = request.get_json()
    return jsonify(data)