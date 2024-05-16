from unstructured.embed.bedrock import BedrockEmbeddingEncoder
from unstructured.embed.huggingface import HuggingFaceEmbeddingEncoder
from unstructured.embed.octoai import OctoAIEmbeddingEncoder
from unstructured.embed.openai import OpenAIEmbeddingEncoder
from unstructured.embed.vertexai import VertexAIEmbeddingEncoder

EMBEDDING_PROVIDER_TO_CLASS_MAP = {
    "langchain-openai": OpenAIEmbeddingEncoder,
    "langchain-huggingface": HuggingFaceEmbeddingEncoder,
    "langchain-aws-bedrock": BedrockEmbeddingEncoder,
    "langchain-vertexai": VertexAIEmbeddingEncoder,
    "octoai": OctoAIEmbeddingEncoder,
}
