import os
from dotenv import load_dotenv

# Import the Pinecone library
from pinecone.grpc import PineconeGRPC as Pinecone

# Load environment variables
load_dotenv()
pinecone_api_key = os.getenv("PINECONE_API_KEY")
if not pinecone_api_key:
    raise ValueError("PINECONE_API_KEY is not set in the .env file")

pc = Pinecone(api_key=pinecone_api_key)

# Target the index where you stored the vector embeddings
pc.delete_index("idea-index")