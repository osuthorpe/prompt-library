import os
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_core.prompts import ChatPromptTemplate

def main():
    # Load environment variables
    load_dotenv()
    openai_api_key = os.getenv("OPENAI_API_KEY")
    if not openai_api_key:
        raise ValueError("OPENAI_API_KEY is not set in the .env file")

    # Initialize the chat model
    model = ChatOpenAI(model="gpt-4", openai_api_key=openai_api_key)

    # Define the chat prompt
    system_message = "You are a helpful assistant. How can I assist you today?"
    print(f"System: {system_message}")

    while True:
        user_input = input("Human: ")
        if user_input.lower() in {"exit", "quit"}:
            print("Goodbye!")
            break

        # Create chat messages
        prompt = ChatPromptTemplate.from_messages([
            ("system", system_message),
            ("user", user_input),
        ])

        # Generate a response
        formatted_prompt = prompt.invoke({"text": user_input})
        response = model.invoke(formatted_prompt)
        print(f"System: {response.content}")

if __name__ == "__main__":
    main()
