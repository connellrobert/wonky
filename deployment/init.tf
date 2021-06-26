terraform {
    required_providers {
      aws = {
          source = "hashicorp/aws"
          version = ">=3.46.0"
    }

    random = {
        source = "hashicorp/random"
        version = ">=3.1.0"
    }

    local = {
        source = "hashicorp/local"
        version = ">=2.1.0"
    }

    null = {
        source = "hashicorp/null"
        version = ">=3.1.0"
    }

    kubernetes = {
        source = "hashicorp/kubernetes"
        version = ">=2.3.2"
    }

    }

    required_version = "1.0.0"
}