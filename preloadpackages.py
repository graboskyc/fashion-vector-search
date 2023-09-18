from sentence_transformers import SentenceTransformer, util

preTrainedModelName = "clip-ViT-L-14"
model = SentenceTransformer(preTrainedModelName)