from flask import Flask, jsonify, request
from application.models import IncomingData, InferenceResult
from application.services import load_model

model = load_model

app = Flask(__name__)


@app.route('/', methods=['GET'])
def health_check():
    load_model()
    return jsonify({
        'status': 'ok',
        'model': load_model()
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
    MODE = "local"

    if MODE == "local":
        app.run( port=5000, debug=True)
    elif MODE == "local_container":
        app.run(host="0.0.0.0", port=5000, debug=True)
    elif MODE == "cloud_container":
        pass
