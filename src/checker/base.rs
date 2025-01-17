use std::{
    collections::{BTreeMap, VecDeque}, time::Duration,
};

use tokio::{process::Command, time::timeout};

use serde::{Deserialize, Serialize};

use super::inject::InjectResponse;



#[derive(Serialize, Deserialize, Clone, Default)]
pub struct Score {
    pub score: u32,
    pub up: bool,
    pub history: VecDeque<bool>,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct Service {
    pub name: String,
    pub command: String,
    pub multiplier: u8,
}

impl Service {
    pub fn new(name: String, command: String) -> Self {
        Service {
            name,
            command,
            multiplier: 1,
        }
    }
    pub fn is_valid(&self) -> bool {
        return self.name != "" && self.command != "";
    }
    pub async fn check_with_env(&self, env: &Vec<(String, String)>) -> Result<TestOutput, ()> {
        // get PATH from env
        let path = std::env::var("PATH").unwrap_or("/usr/bin:/bin:/usr/sbin:/sbin".to_string());
        let output = Command::new("sh")
            .current_dir("./resources")
            .arg("-c")
            .arg(&self.command)
            .env_clear()
            .env("PATH", path)
            .envs(env.clone())
            .output();
        let Ok(res) = timeout(Duration::from_secs(5), output).await else {
            return Ok(TestOutput {
                up: false,
                message: "".to_string(),
                error: "timeout".to_string(),
            });
        };
        let Ok(res) = res else {
            return Err(());
        };
        Ok(TestOutput {
            up: res.status.success(),
            message: String::from_utf8_lossy(&res.stdout).to_string(),
            error: String::from_utf8_lossy(&res.stderr).to_string(),
        })
    }
}

pub struct TestOutput {
    pub up: bool,
    pub message: String,
    pub error: String,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct Team {
    pub scores: BTreeMap<String, Score>,
    pub env: Vec<(String, String)>,
    pub inject_responses: Vec<InjectResponse>,
}

impl Team {
    pub fn score(&self) -> u32 {
        self.scores.iter().map(|(_, s)| s.score).sum()
    }
}

pub enum TeamError {
    InvalidName,
    AlreadyExists,
}

