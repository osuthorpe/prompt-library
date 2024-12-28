
# Prompt Repository

Welcome to the Prompt Repository! This repository is designed to store and manage reusable prompts for novel tasks. Each prompt is saved in a YAML file, allowing for easy reading, editing, and integration into various tools and workflows.

## **Repository Structure**

```
project/
│
├── prompts/
│   ├── paraphraser_prompt.yaml       # A specialized paraphraser prompt
│   └── index.yaml                    # Registry of all available prompts
├── notebooks/
│   ├── manage_prompts.ipynb          # Jupyter notebook for managing and using prompts
│   ├── example_usage.ipynb          # Example notebook demonstrating API integration
└── README.md                         # This documentation
```

---

## **How to Read and Use the YAML Files**

Each YAML file represents a single prompt with detailed instructions, configurable variables, and examples. Below is a guide to understanding its structure:

### **Key Sections**
1. **`id`**: Unique identifier for the prompt. Use this for referencing in systems.
2. **`name`**: The name of the prompt, summarizing its purpose.
3. **`description`**: Explains what the prompt is designed to do.
4. **`recommended_model`**:
    - **`provider`**: Which company to use for best results.
    - **`model`**: Which model to use for best results.
5. **`category`**: The type of task the prompt supports (e.g., text processing).
6. **`tags`**: Keywords for easy classification and search.
7. **`variables`**: Configurable inputs that allow customization of the prompt (e.g., percentages for lexical diversity).
8. **`instructions`**:
    - **`system`**: A brief summary of the task.
    - **`steps`**: Actions for the system to perform.
    - **`rules`**: Constraints or guidelines for ensuring the output meets expectations.
    - **`format`**: Specific templates for structuring responses.
9. **`example_request`**: Example input to demonstrate prompt usage.
10. **`example_response`**: Sample output for reference.
11. **`notes`**: Additional guidance or context for the prompt.
12. **`full_prompt`**: A complete, copy-paste-ready version of the prompt for direct use.

### **Using the YAML Files**
- **Manual Use**: Copy the `full_prompt` field and paste it directly into a language model interface (e.g., GPT-4o).
- **Automated Systems**: Parse the YAML files programmatically to load and use prompts dynamically in your workflow.

---

## **How to Use This Repository**

1. **Browse Prompts**: Review the prompts in the `prompts/` directory. Use the `index.yaml` file as a registry to find the right prompt for your task.
2. **Edit Prompts**: Modify YAML files to adapt prompts for your specific use cases.
3. **Load in Code**: Use the Python examples below to load and use prompts dynamically.

---

## **Setting Up API Keys**

1. **Create a `secrets.yaml` File**  
   Copy the example file and fill in your API keys:
   ```bash
   cp supporting_files/secrets.example.yaml supporting_files/secrets.yaml

Edit the supporting_files/secrets.yaml file to include your actual API keys:
```
openai_api_key: "your-actual-api-key-here"
another_service_api_key: "your-actual-api-key-here"
```

### Ensure Security
The .gitignore file is configured to exclude supporting_files/secrets.yaml from being committed to version control.
Run the Notebook
Open the Jupyter notebooks and execute the cells. The API keys will be securely loaded from supporting_files/secrets.yaml.

### **Advantages of Using YAML Secrets**
1. **Consistency**: YAML is already used for the prompts, so keeping the secrets in YAML ensures uniformity.
2. **Human-Readable**: YAML’s structure makes it easy to read and edit API keys.
3. **Integration**: Works seamlessly with existing YAML loaders in the code.


---

## **Python Usage Examples**

### **Load a Prompt**
```python
import yaml

# Load a specific prompt
with open("prompts/paraphraser_prompt.yaml", "r") as file:
    prompt_data = yaml.safe_load(file)

# Access the full prompt
print(prompt_data["full_prompt"])
```

### **List All Prompts**
```python
import os

# List all YAML files in the prompts directory
directory = "prompts"
prompts = [f for f in os.listdir(directory) if f.endswith(".yaml")]
print("Available Prompts:", prompts)
```

### **Combine Multiple Prompts**
```python
def combine_prompts(files):
    combined = {"full_prompts": []}
    for file in files:
        with open(file, "r") as f:
            data = yaml.safe_load(f)
            combined["full_prompts"].append(data["full_prompt"])
    return combined

# Combine prompts
files_to_combine = ["prompts/paraphraser_prompt.yaml", "prompts/summarizer_prompt.yaml"]
combined = combine_prompts(files_to_combine)
for i, prompt in enumerate(combined["full_prompts"], start=1):
    print(f"Prompt {i}:
{prompt}
")
```

---

## **Contributing**

1. Fork the repository and create a new branch.
2. Add or modify prompts in the `prompts/` directory.
3. Update the `index.yaml` file to include your changes.
4. Submit a pull request with a clear description of your changes.

---

## **License**

This repository is open-source and available under the [MIT License](LICENSE).

---

## **Contact**

If you have questions or suggestions, feel free to reach out to the repository maintainer, Alex Thorpe.
