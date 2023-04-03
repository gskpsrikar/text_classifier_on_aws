from flask import Flask, jsonify, request
from models import IncomingData, InferenceResult


app = Flask(__name__)


@app.route('/', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'ok'
    })


@app.route('/inference/predict', methods=['POST'])
def post_mock_data():
    data = IncomingData(**request.get_json())

    result = InferenceResult(**data.dict())
    result.prediction = data.input_data

    with app.app_context():
        return jsonify({
            "status": 'ok',
            "message": result.dict()
        })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
