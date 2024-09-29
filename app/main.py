from app import app, db  # Import the initialized Flask app and db connection
from flask import jsonify, request
from flask_cors import CORS
import requests
from app.utils.db_connector import get_db_connection

# Enable CORS on the Flask app
CORS(app)

# Simple home route for testing
@app.route('/')
def home():
    return "Hello, World!"

# Route for handling the question request
@app.route('/ask', methods=['POST'])
def ask_question():
    # Get the JSON data sent by the client
    data = request.get_json()
    question = data.get('question')

    if not question:
        return jsonify({"error": "No question provided"}), 400

    # Query the database for the answer
    cursor = db.cursor()
    cursor.execute("SELECT answer FROM finance_qa WHERE question = %s", (question,))
    result = cursor.fetchone()

    if result:
        answer = result[0]
    else:
        answer = "I don't know the answer to that question."

    return jsonify({"question": question, "answer": answer})

# Route for connecting to AI API
@app.route('/ai_answer', methods=['POST'])
def ai_answer():
    # Get the question from the request
    data = request.get_json()
    question = data.get('question')

    if not question:
        return jsonify({"error": "No question provided"}), 400

    # Example AI API integration
    api_url = "https://api.tidio.com/ai/ask"  # Replace with actual API URL
    headers = {"Authorization": f"Bearer {app.config['API_KEY']}"}
    data = {"question": question}

    # Request AI answer
    response = requests.post(api_url, json=data, headers=headers)
    if response.status_code == 200:
        ai_answer = response.json().get('answer', "AI could not find an answer.")
    else:
        ai_answer = "Error contacting the AI service."

    return jsonify({"question": question, "ai_answer": ai_answer})

# Route for testing database connection
@app.route('/test_db', methods=['GET'])
def test_db():
    try:
        connection = get_db_connection()  # Assuming this connects to DB
        return "Database connection successful!"
    except Exception as e:
        return str(e)

# Make sure this runs only when called directly (useful in development)
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
