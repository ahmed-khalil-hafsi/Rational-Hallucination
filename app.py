from pyswip import Prolog
import openai
import os


openai.api_key = "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"
prolog = Prolog()

def ask_prolog(query):
    list(prolog.query(query))  # Query prolog
    for soln in prolog.query(query):
        return soln  # Return first solution

def ask_LLM(prompt):
    response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "You are Brimsley, an LLM based on GPT-4. You are connected to a prolog interpreter to help you reason. If you need to invoke Prolog, just add the prolog commands between ''' "},
                    {"role": "user", "content": prompt},
                ]
)
    return response['choices'][0]['message']['content'].text.strip()

prompt = "how much is 1+1"

#while True:
gpt4_prompt = ask_LLM(prompt)
prolog_result = ask_prolog(gpt4_prompt)
prompt = ask_LLM(prolog_result)
