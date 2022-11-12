from flask import Flask, render_template, request
import torch
from transformers import pipeline

model_path = "facebook/bart-large-cnn"
app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

#background process happening without any refreshing
@app.route('/background_process_button', methods=['POST'])
def background_process_button():
    try:
        input_text = request.form['text']
        summarizer = pipeline("summarization", model=model_path)
        summary = summarizer(input_text, max_length=130, min_length=30, do_sample=False)[0]["summary_text"]
    except:
        summary = "ERROR: Please try again"
    return render_template('index.html', variable=input_text, summary=summary)


if __name__ == "__main__":
    app.run(debug=True)