-- Initialize Claudia database

-- Create user sessions table
CREATE TABLE IF NOT EXISTS user_sessions (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(255) UNIQUE NOT NULL,
    ai_service VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB
);

-- Create usage analytics table
CREATE TABLE IF NOT EXISTS usage_analytics (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(255) REFERENCES user_sessions(session_id),
    tokens_used INTEGER,
    cost_estimate DECIMAL(10,4),
    service VARCHAR(100),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_sessions_service ON user_sessions(ai_service);
CREATE INDEX IF NOT EXISTS idx_analytics_timestamp ON usage_analytics(timestamp);
CREATE INDEX IF NOT EXISTS idx_analytics_service ON usage_analytics(service);
