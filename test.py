import openai
import os
import requests
import json

openai.api_key = "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"

def ask_LLM(prompt):
    response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "You are Brimsley, an LLM based on GPT-4. You are connected to a prolog interpreter to help you reason. Your response must be a prolog predicate only. It cannot have anything else."},
                    {"role": "user", "content": prompt},
                ]
)
    return response['choices'][0]['message']['content']

prompt = "Who is the father of ahmed?"

ret = ask_LLM(prompt)
print(ret)


url = 'http://localhost:3000/query'
headers = {'Content-Type': 'application/json'}


data = {'fact': ret}

response = requests.post(url, json=data)

print(response.json())



