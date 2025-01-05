import os
import yaml
from glob import glob
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI

# Load environment variables
load_dotenv()
openai_api_key = os.getenv("OPENAI_API_KEY")
if not openai_api_key:
    raise ValueError("OPENAI_API_KEY is not set in the .env file")

# Initialize the chat model
model = ChatOpenAI(model="gpt-4", openai_api_key=openai_api_key)

# Load prompts dynamically from the "prompts" directory
def load_prompts(directory):
    prompts = {}
    for filepath in glob(os.path.join(directory, "*.yaml")):
        with open(filepath, "r") as file:
            prompt_data = yaml.safe_load(file)
            prompts[prompt_data["id"]] = prompt_data
    return prompts

# Use the LLM to recommend the best matching prompt
def recommend_prompt_with_llm(user_query, prompts):
    """
    Use the LLM to recommend the best matching prompt based on the user's query.
    """
    # Summarize all prompts into a concise format for the LLM
    prompt_list = "\n".join(
        [f"- {data['name']}: {data['description']}" for data in prompts.values()]
    )

    # Define the recommendation prompt
    llm_prompt = f"""
You are a helpful assistant specializing in recommending prompts for tasks. Below is a list of available prompts:

{prompt_list}

The user has asked: "{user_query}"

Based on the user's request, recommend the most relevant prompt from the list. Return the name of the recommended prompt and a brief explanation.
"""

    # Use the LLM to get a response
    response = model.invoke(llm_prompt)

    # Parse the response to extract the recommended prompt
    lines = response.content.strip().split("\n")
    recommended_prompt = lines[0] if lines else None

    if recommended_prompt:
        # Find the corresponding prompt data
        for prompt_id, prompt_data in prompts.items():
            if prompt_data["name"].lower() in recommended_prompt.lower():
                return prompt_id, prompt_data

    # Return None if no valid recommendation is made
    return None, None

# Collect required inputs for a prompt
def collect_inputs(prompt_data):
    inputs = {}
    for var, details in prompt_data["variables"].items():
        if details.get("required", False):
            user_input = input(f"{details['desc']} ({details['type']}): ")
            inputs[var] = user_input
        elif "default" in details:
            inputs[var] = details["default"]
    return inputs

# Fill and execute a prompt
def execute_prompt(prompt_data, inputs):
    filled_prompt = prompt_data["prompt"]
    for key, value in inputs.items():
        filled_prompt = filled_prompt.replace(f"{{{{ {key} }}}}", value)
    response = model.invoke(filled_prompt)
    return response.content

# Main program
def main():
    # Load all prompts
    prompts_directory = "prompts"
    prompts = load_prompts(prompts_directory)

    print("Welcome to the LangChain Console with LLM-Powered Prompt Recommendation!")
    print("Type 'exit' to quit or 'list prompts' to see available prompts.\n")

    while True:
        user_query = input("What do you need help with? ")
        if user_query.lower() in {"exit", "quit"}:
            print("Goodbye!")
            break

        if user_query.lower() == "list prompts":
            print("Available Prompts:")
            for prompt_id, prompt_data in prompts.items():
                print(f"- {prompt_data['name']}: {prompt_data['description']}")
            continue

        # Use LLM to recommend a prompt
        prompt_id, prompt_data = recommend_prompt_with_llm(user_query, prompts)

        if not prompt_data:
            print("Sorry, I couldn't find a matching tool. Using the chat model to provide an answer...\n")
            try:
                # Use the chat model to answer the query directly
                response = model.invoke(f"You are an expert assistant. Answer the following question: {user_query}")
                print(f"Response:\n{response.content}\n")
            except Exception as e:
                print(f"An error occurred while processing your request: {str(e)}\n")
            continue

        print(f"\nMatched Prompt: {prompt_data['name']}")
        print(f"Description: {prompt_data['description']}\n")

        # Collect required inputs
        inputs = collect_inputs(prompt_data)

        # Execute the prompt
        print("\nProcessing your request...\n")
        response = execute_prompt(prompt_data, inputs)
        print(f"Response:\n{response}\n")


if __name__ == "__main__":
    main()
