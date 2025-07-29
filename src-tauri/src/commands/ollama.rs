use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use tauri::command;

#[derive(Debug, Serialize, Deserialize)]
pub struct OllamaModel {
    pub name: String,
    pub size: Option<u64>,
    pub digest: Option<String>,
    pub modified_at: Option<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct OllamaModelsResponse {
    pub models: Vec<OllamaModel>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct OllamaChatMessage {
    pub role: String,
    pub content: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct OllamaChatRequest {
    pub model: String,
    pub messages: Vec<OllamaChatMessage>,
    pub stream: bool,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct OllamaChatResponse {
    pub message: OllamaChatMessage,
    pub done: bool,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct OllamaStatusResponse {
    pub status: String,
    pub version: Option<String>,
}

#[command]
pub async fn get_ollama_models(url: String) -> Result<Vec<OllamaModel>, String> {
    let client = reqwest::Client::new();
    let models_url = format!("{}/api/tags", url.trim_end_matches('/'));
    
    match client.get(&models_url).send().await {
        Ok(response) => {
            if response.status().is_success() {
                match response.json::<OllamaModelsResponse>().await {
                    Ok(models_response) => Ok(models_response.models),
                    Err(e) => Err(format!("Failed to parse models response: {}", e)),
                }
            } else {
                Err(format!("Failed to fetch models: HTTP {}", response.status()))
            }
        }
        Err(e) => Err(format!("Failed to connect to Ollama: {}", e)),
    }
}

#[command]
pub async fn check_ollama_status(url: String) -> Result<OllamaStatusResponse, String> {
    let client = reqwest::Client::new();
    let status_url = format!("{}/api/version", url.trim_end_matches('/'));
    
    match client.get(&status_url).send().await {
        Ok(response) => {
            if response.status().is_success() {
                match response.json::<HashMap<String, serde_json::Value>>().await {
                    Ok(version_info) => {
                        let version = version_info
                            .get("version")
                            .and_then(|v| v.as_str())
                            .map(|s| s.to_string());
                        
                        Ok(OllamaStatusResponse {
                            status: "connected".to_string(),
                            version,
                        })
                    }
                    Err(_) => Ok(OllamaStatusResponse {
                        status: "connected".to_string(),
                        version: None,
                    }),
                }
            } else {
                Err(format!("Ollama server error: HTTP {}", response.status()))
            }
        }
        Err(e) => Err(format!("Cannot connect to Ollama: {}", e)),
    }
}

#[command]
pub async fn send_ollama_chat(
    url: String,
    model: String,
    messages: Vec<OllamaChatMessage>,
) -> Result<String, String> {
    let client = reqwest::Client::new();
    let chat_url = format!("{}/api/chat", url.trim_end_matches('/'));
    
    let request = OllamaChatRequest {
        model,
        messages,
        stream: false,
    };
    
    match client.post(&chat_url).json(&request).send().await {
        Ok(response) => {
            if response.status().is_success() {
                match response.json::<OllamaChatResponse>().await {
                    Ok(chat_response) => Ok(chat_response.message.content),
                    Err(e) => Err(format!("Failed to parse chat response: {}", e)),
                }
            } else {
                let error_text = response.text().await.unwrap_or_else(|_| "Unknown error".to_string());
                Err(format!("Chat request failed: {}", error_text))
            }
        }
        Err(e) => Err(format!("Failed to send chat request: {}", e)),
    }
}