from app import app, db
from flask import jsonify
import requests

@app.route('/')
def home():
    return "Hello, World!"  # Simple route for testing

@app.route('/ask', methods=['POST'])
def ask_question():
    question = "What is a stock?"  # Example question, replace with dynamic input
    # Query the database
    cursor = db.cursor()
    cursor.execute("SELECT answer FROM finance_qa WHERE question = %s", (question,))
    result = cursor.fetchone()

    if result:
        answer = result[0]
    else:
        answer = "I don't know the answer to that question."

    return jsonify({"question": question, "answer": answer})

# Example: Route for connecting to AI API
@app.route('/ai_answer', methods=['POST'])
def ai_answer():
    question = "What is a bond?"  # Example question
    api_url = "https://api.tidio.com/ai/ask"  # Example AI API URL
    headers = {"Authorization": f"Bearer {app.config['API_KEY']}"}
    data = {"question": question}
    
    response = requests.post(api_url, json=data, headers=headers)
    ai_answer = response.json().get('answer', "AI could not find an answer.")

    return jsonify({"question": question, "ai_answer": ai_answer})
